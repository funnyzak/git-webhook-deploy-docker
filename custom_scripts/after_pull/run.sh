#!/bin/bash

set -e

source /custom_scripts/potato/utils-git-webhook-node.sh

# notify send
notify_all "AfterPull"


# install deps
echo "installing deps..."
if [ -n "$INSTALL_DEPS_COMMAND" ]; then
    eval "$INSTALL_DEPS_COMMAND || (echo \"Installing deps failed. Aborting!\"; $(notify_error); exit 1)"
else
    npm install || (echo "Installing deps failed. Aborting!"; $(notify_error); exit 1)
fi


# build code
echo "building code..."
if [ -n "$BUILD_COMMAND" ]; then
    eval "$BUILD_COMMAND || (echo \"Build failed. Aborting!\"; $(notify_error); exit 1)"
else
    npm run build || (echo "Build failed. Aborting!"; $(notify_error); exit 1)
fi

# move target
echo "moving to target dir..."
if [ -z "$OUTPUT_DIRECTORY" ]; then
    rsync -q -r --delete ./ /app/target/
else
    eval "rsync -q -r --delete $OUTPUT_DIRECTORY /app/target/"
fi
echo "moving to target dir done"


set +e

# calc package elasped time
elasped_package_time "end"
# record current git commit id
echo $(parse_git_hash) > /tmp/CURRENT_GIT_COMMIT_ID

# after package command
if [ -n "$AFTER_PACKAGE_COMMANDS" ]; then
    echo "after package command do..." 
    eval "$AFTER_PACKAGE_COMMANDS"
fi

echo "after package shell do..." 
source /usr/bin/run_scripts_after_package.sh
