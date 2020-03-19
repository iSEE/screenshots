#!/bin/bash

git clone https://github.com/iSEE/screenshots
git config --global user.email "infinite.monkeys.with.keyboards@gmail.com"
git config --global user.name "LTLA"

cd screenshots
git checkout compiled
git merge master

# Compiling the data files.
#CMD="Rdevel --no-save --slave"
CMD=Rscript

cd data
for x in $(ls *.R)
do
    $CMD -e "source('$x')"
done
cd -

# Compiling the images.
cd images
$CMD -e "source('compile.R')"

# Committing everything in sight.
git add *
git commit -m "Recompiled PNGs."

git push https://${1}@github.com/iSEE/screenshots
