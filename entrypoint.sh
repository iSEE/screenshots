#!/bin/bash

git clone https://github.com/iSEE/screenshots
git config --global user.email "infinite.monkeys.with.keyboards@gmail.com"
git config --global user.name "LTLA"

cd screenshots
git checkout compiled
git merge master

git rm -rf images

# Compiling the images.
#CMD="Rdevel --slave --no-save"
CMD=Rscript
$CMD -e "source('compile.R')"

# Committing everything in sight.
git add images
git commit -m "Recompiled PNGs."

git push https://${GITHUB_ACTOR}:${GITHUB_TOKEN}@github.com/${GITHUB_REPOSITORY}.git
