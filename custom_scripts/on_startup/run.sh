#!/bin/ash

source /custom_scripts/potato/utils-git-webhook-node.sh

do_notify "start up"

echo 'starting nginx'
nginx -g