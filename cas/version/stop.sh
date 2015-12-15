#!/bin/bash

#---merge and delete a branch
if [[ -z "${@:2}" ]]; then echo "[ERROR] you must name the branch to delete" && exit 1; fi
echo "[STATUS] switching to master: 'git checkout master'"
echo "[STATUS] merging via: 'git merge --no-ff $2'"
echo "[STATUS] then deleting branch via: 'git branch -d $2'"
read -p "[QUESTION] continue (y/N)? " -r
if [[ $REPLY =~ ^[Yy]$ ]]; then
git checkout master
git merge --no-ff -m "merge branch $2" $2
git branch -d $2
fi
