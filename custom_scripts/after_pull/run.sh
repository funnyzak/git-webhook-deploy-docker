#!/bin/bash

source /custom_scripts/potato/utils-git-webhook-node.sh

# notify send
notify_all "AfterPull"

# install deps
if [ -n "$INSTALL_DEPS_COMMAND" ]; then
    echo "run installing deps command: $INSTALL_DEPS_COMMAND"
    $INSTALL_DEPS_COMMAND
fi


set -e

# build code
if [ -n "$BUILD_COMMAND" ]; then
    echo "run build command: $BUILD_COMMAND"
    $BUILD_COMMAND || (echo "Build failed. Aborting;"; notify_error ; exit 1)
fi

set +e


# copy output files  
if [ -n "$OUTPUT_DIRECTORY" ]; then
    echo "moving to target dir..."
    eval "rsync -q -r --delete $OUTPUT_DIRECTORY /app/target/"
    echo "moving to target dir done."
fi


# calc package elasped time
elasped_package_time "end"
# record current git commit id
echo $(parse_git_hash) > /tmp/CURRENT_GIT_COMMIT_ID


# after package notify
notify_all "AfterPackage"


# after package command
if [ -n "$AFTER_PACKAGE_COMMANDS" ]; then
    echo "after package command do: ${AFTER_PACKAGE_COMMANDS}" 
    $AFTER_PACKAGE_COMMANDS || (echo "After Package Command failed. Aborting!"; notify_error; exit 1)
fi


echo "after package shell do..." 
source /usr/bin/run_scripts_after_package.sh
