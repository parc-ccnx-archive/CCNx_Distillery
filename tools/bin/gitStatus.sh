#!/bin/sh

if [ $# -lt 5 ]; then
  echo "ERROR incorrect number of parameters"
  echo "Usage:"
  echo "   $0 <repo_name> <repo_directory> <origin> <remote_name> <remote_url>"
  echo
  echo "$0 check the values of the repo. Compare what git things with what we would like"
  echo "  repo_name      - Name of the repo (cosmetic)"
  echo "  repo_directory - Directory where to find the git repo"
  echo "  origin         - What origin should be set to"
  echo "  remote_name    - The name of a remote to check"
  echo "  remote_url     - What that remote should be set to"
  exit 1
fi

REPO_NAME=$1
REPO_DIR=$2
ORIGIN=$3
REMOTE_NAME=$4
REMOTE_URL=$5

if [ ! -d $REPO_DIR ]; then
  echo "ERROR running $0"
  echo "      Directory $REPO_DIR not found"
  exit 1
fi

cd $REPO_DIR

NEEDS_UPDATE=NO

echo "###################################################################"
echo "# $REPO_NAME "

# An origin of - means we should ignore the origin check
if [ $ORIGIN != - ]; then
  ORIGIN_ACTUAL=`git config --get remote.origin.url`
  if [ $ORIGIN_ACTUAL != $ORIGIN ]; then
	echo "# WARNING: remote origin missmatch"
	echo "#   Expected $ORIGIN"
	echo "#   Found    $ORIGIN_ACTUAL"
	NEEDS_UPDATE=YES
  fi
fi

REMOTE_URL_ACTUAL=`git config --get remote.$REMOTE_NAME.url 2>/dev/null`

if [ $? -ne 0 ]; then
  echo "# WARNING remote $REMOTE_NAME does not exist"
  echo "#   Expected $REMOTE_NAME = $REMOTE_URL"
  echo "#   Found    a remote called $REMOTE_NAME does not exist"
  NEEDS_UPDATE=YES
else
  if [ $REMOTE_URL_ACTUAL != $REMOTE_URL ]; then
    echo "# WARNING remote $REMOTE_NAME missmatch"
    echo "#   Expected $REMOTE_NAME = $REMOTE_URL"
    echo "#   Found    $REMOTE_NAME = $REMOTE_URL_ACTUAL"
    NEEDS_UPDATE=YES
  fi
fi

if [ $NEEDS_UPDATE = NO ]; then
  echo "# Up to date"
  exit 0
fi

echo "#"
echo "# Your settings don't match the default settings for $REPO_NAME"
echo "#   located at $REPO_DIR"


