#!/bin/bash

source /custom_scripts/potato/utils-git-webhook-node.sh

notify_all "StartUp"

echo 'starting nginx'
nginx