#!/bin/bash

#---push changes to source
echo "[NOTE] directory size = $(du -h -d 0)"
echo "[NOTE] pushing changes to source: 'git push'"
read -p "[QUESTION] continue (y/N)? " -r
if [[ $REPLY =~ ^[Yy]$ ]]; then
git push
fi
