#!/bin/bash

set -e
set -u

git config --local user.email infinite.monkeys.with.keyboards@gmail.com
git config --local user.name LTLA

git fetch --all
git checkout compiled 2>/dev/null || git checkout -b compiled 
git merge master

# Stripping out existing images, for a clean slate.
if [ -e images ]
then 
    git rm -rf images
fi

# Compiling the images.
CMD=Rscript
$CMD -e "source('compile.R')"

# Committing everything in sight.
find images/ -name '*.png' | xargs git add
git commit -m "Automated recompilation of screenshots."

git push https://${GITHUB_ACTOR}:${GITHUB_TOKEN}@github.com/${GITHUB_REPOSITORY}.git compiled
