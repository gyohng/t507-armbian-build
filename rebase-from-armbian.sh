#!/bin/bash

set -e

if [[ ! -z $(git status -s) ]]; then
    echo Uncommitted changes are present. Please commit first
    exit 1
fi

if [ "$1" == "push" ]; then
    # reintegrate
    git push --force-with-lease
    git pull --no-commit
    git pull --all --no-commit
    git push
else
    if ! (git remote | grep -q armbian-github); then
        git remote add -t main armbian-github https://github.com/armbian/build
    fi

    git fetch armbian-github main:armbian-main

    git pull
    git pull --all

    CUR_BRANCH=`git rev-parse --abbrev-ref HEAD`

    git checkout armbian-main
    git pull --no-commit armbian-github main:armbian-main
    git push --set-upstream origin armbian-main

    git checkout "$CUR_BRANCH"
    git rebase -i -X patience -s recursive --autosquash armbian-github/main
fi
