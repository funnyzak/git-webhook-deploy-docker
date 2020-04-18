#!/bin/sh

source /custom_scripts/potato/func.sh

do_notify "after pull"

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

do_notify "after build"
