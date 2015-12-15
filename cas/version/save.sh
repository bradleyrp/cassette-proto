#!/bin/bash

#---save changes via git commit
if [[ -z "${@:2}" ]]; then echo "[ERROR] make save is a git commit and requires a message" && exit 1; fi
echo "[NOTE] directory size = $(du -h -d 0)"
timestamp=$(date +%Y.%m.%d.%H%M)
echo "[NOTE] committing changes via: 'git commit -a -m \"${@:2}\"'"
read -p "[QUESTION] continue (y/N)? " -r
if [[ $REPLY =~ ^[Yy]$ ]]; then
commit_message=${@:2}
git commit -a -m "$commit_message"
fi
