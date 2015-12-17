#!/bin/bash

<<'notes'
This script pulls cassette codes from a remote repo so that changes to the codebase in an
active document can be added to the empty cassette.
notes

write=$2
if [ -z $write ]; then { echo "[USAGE] make getcode <write-path>"; exit; }; fi
git archive --remote=$write master cas/* | tar xvf -
git archive --remote=$write master makefile | tar xvf -
