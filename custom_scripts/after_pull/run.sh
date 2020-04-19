#!/bin/bash

source /custom_scripts/potato/utils-git-webhook-node.sh

# notify send
notify_all "AfterPull"

# install deps
echo "installing deps..."
if [ -n "$INSTALL_DEPS_COMMAND" ]; then
    eval "$INSTALL_DEPS_COMMAND"
else
    npm install
fi


# build code
echo "building code..."
if [ -n "$BUILD_COMMAND" ]; then
    eval "$BUILD_COMMAND"
else
    npm run build
fi

# move target
echo "moving to target dir..."
if [ -z "$OUTPUT_DIRECTORY" ]; then
    rsync -q -r --delete ./ /app/target/
else
    eval "rsync -q -r --delete $OUTPUT_DIRECTORY /app/target/"
fi

# calc package elasped time
elasped_package_time "end"

# after package command
echo "after package command do..." 
eval "$AFTER_PACKAGE_COMMANDS"

echo "after package shell do..." 
source /usr/bin/run_scripts_after_package.sh
