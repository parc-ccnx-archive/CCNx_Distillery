#!/bin/sh

if [ $# -lt 4 ]; then
  echo "ERROR incorrect number of parameters"
  echo "Usage:"
  echo "   $0 <repo_name> <repo_directory> <remote_name> <remote_url>"
  echo
  echo "$0 adds a remote named <remote_name> to repository <repo_name> located"
  echo "in directory <repo_directory>. The remote will point towards <remote_url>"
  echo "If <remote_name> already exits nothing will be done."
  exit 1
fi

REPO_NAME=$1
REPO_DIR=$2
REMOTE_NAME=$3
REMOTE_URL=$4

if [ ! -d $REPO_DIR ]; then
  echo "ERROR running $0"
  echo "      Directory $REPO_DIR not found"
  exit 1
fi

echo "###################################################################"
echo "# Updationg remote $REMOTE_NAME for $REPO_NAME"

cd $REPO_DIR

git remote add $REMOTE_NAME $REMOTE_URL > /dev/null 2>&1
if [ $? -ne 0 ]; then
  echo "# Skipped - not needed"
  exit 0
fi

echo "# Added $REMOTE_URL"
exit 0
