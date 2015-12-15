#!/bin/bash

#---save changes via git commit
additions=${@:2}
git add $additions
