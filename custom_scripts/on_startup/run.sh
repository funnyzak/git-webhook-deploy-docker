#!/bin/bash

source /custom_scripts/potato/utils-git-webhook-node.sh

notify_all "StartUp"

# run nginx
echo 'starting nginx'
nginx