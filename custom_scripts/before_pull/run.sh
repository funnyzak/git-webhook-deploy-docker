#!/bin/ash

source /custom_scripts/potato/utils-git-webhook-node.sh

notify_all "BeforePull"

# record pull start timestamp
elasped_package_time