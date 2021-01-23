#!/usr/bin/env bash

if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  echo 'The current directory is not a git repository.'
  echo 'Please run this script inside the git repository that you want to syncup. Aborting.'
  exit 1
fi

GIT_DIRTY=$(test -n "$(git status --porcelain)" && echo "dirty" || echo "clean")

if [ "$GIT_DIRTY" = 'dirty' ]; then
  echo "git status is ${GIT_DIRTY}."
  echo 'Please make sure the git status is clean before running this script. Aborting.'
  exit 1
fi

BRANCH='master'
if git rev-parse --quiet --verify refs/heads/main >/dev/null; then
  BRANCH='main'
fi

git fetch --all
git log --graph upstream/"$BRANCH" origin/"$BRANCH" "$BRANCH"
git status
git checkout "$BRANCH"
git merge --ff-only upstream/"$BRANCH"
git push
git log --graph upstream/"$BRANCH" origin/"$BRANCH" "$BRANCH"
