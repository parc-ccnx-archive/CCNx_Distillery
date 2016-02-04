#!/bin/sh

BRANCH=`git symbolic-ref --short HEAD`
echo "Currently on " $BRANCH
git checkout master && git merge parc_upstream/master && git push
STATUS=$?
git checkout $BRANCH

exit $STATUS
