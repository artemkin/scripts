#!/bin/bash
#
# This script lets you merge a development branch, and
# skip changes made in branch-specific files.
#
# The list of branch specific files extracted from .gitattributes.
#
# Let's say .gitattributes contains the following lines:
# readme.txt merge=ours
# version.h merge=ours
#
# It means all changes made to 'readme.txt' and 'version.h' files in
# a development branch, won't be merged.
#
# -----------------------------------------------------------------------------
# NOTE: call the next command at least once, to install 'ours' merge driver.
# It will automatically resolve merge conflicts for branch specific files.
#
# git config --global merge.ours.driver true
# -----------------------------------------------------------------------------
#
# Usage: merge-branch.sh [branch to merge]

Branch=$1

if [[ -z "$Branch" ]]
then
    echo "Usage: merge-branch.sh [branch to merge]"
    exit 1
fi

if [[ ! -d .git ]]
then
    echo "error: a git repository is not found in the current directory"
    exit 1
fi

if [[ ! -f .gitattributes ]]
then
    echo "error: a .gitattributes file is not found in the current directory"
    exit 1
fi

git merge --no-commit --no-ff "$Branch"

MergeExitCode=$?

git checkout HEAD -- $(cat .gitattributes | grep "merge=ours" | tr -s " " | cut -d " " -f 1)

if [[ $MergeExitCode -eq 0 ]]
then
    git commit --no-edit
fi
