#!/bin/sh

GIT_DIRECTORY=$1
GIT_REPO=`basename ${GIT_DIRECTORY}`

cd ${GIT_DIRECTORY}

CURRENT_SHA=`git branch -av | grep "\*" | awk '{print $3}'`
CURRENT_BRANCH=`git branch -av | grep "\*" | awk '{print $2}'`
UPSTREAM_SHA=`git branch -av | grep "remotes/parc_upstream/master" | awk '{print $2}'`
PARC_MASTER_IN_BRANCH=`git branch -v --contains $UPSTREAM_SHA | grep "\*" | awk '{print $3}'`

echo '===================================================================='

#echo CURRENT_SHA ${CURRENT_SHA}
#echo CURRENT_BRANCH ${CURRENT_BRANCH}
#echo UPSTREAM_SHA ${UPSTREAM_SHA}
#echo PARC_MASTER_IN_BRANCH ${PARC_MASTER_IN_BRANCH}
#echo "git branch --contains $UPSTREAM_SHA | grep \"\*\" | awk '{print $3}'"

if [ "x${PARC_MASTER_IN_BRANCH}" != "x" ]; then
  # This branch is master OR ahead of master
  if [ ${CURRENT_SHA} = ${UPSTREAM_SHA} ]; then
    echo "PARC    ${GIT_REPO} ${CURRENT_BRANCH}"
  else
    echo "PARC++  ${GIT_REPO} ${CURRENT_BRANCH} ${CURRENT_SHA}::${UPSTREAM_SHA}"
  fi
else
    echo "------  ${GIT_REPO} ${CURRENT_BRANCH} ${CURRENT_SHA}::${UPSTREAM_SHA}"
fi
git status -s 
