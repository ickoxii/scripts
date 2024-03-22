#!/bin/bash

if [ $# -ne 1 ]; then
    echo "Usage: $0 <new_remote_origin>"
    exit 1
fi

new_remote_origin="$1"

# Remove current origin
echo "git remote remove origin"
git remote remove origin
echo "-----"

# Update remote origin with new URL
echo "git remote add origin $new_remote_origin"
git remote add origin "$new_remote_origin"
echo "-----"

# Pring new remote origin
echo "git remote -v"
git remote -v
echo "-----"
