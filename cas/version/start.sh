#!/bin/bash

#---create and checkout a new branch
if [[ -z "${@:2}" ]]; then echo "[ERROR] branch needs a name" && exit 1; fi
echo "[STATUS] checking out a new branch via: 'git checkout -b $2'"
read -p "[QUESTION] continue (y/N)? " -r
if [[ $REPLY =~ ^[Yy]$ ]]; then
branch_name=$2
git checkout -b $branch_name
fi
