#!/bin/bash
#automatically pushes code on github

git status
git add .
git commit -m "update"
git push
