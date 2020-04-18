#!/bin/bash
for file in /custom_scripts/after_package/*; do
    "$file"
done