#!/bin/bash

if [ $# -lt 3 ]; then
  echo "ERROR incorrect number of parameters"
  echo "Usage:"
  echo "   $0 <repo_name> <repo_directory> <remote1> [<remote2>...]"
  echo
  echo "$0 clones repository <repo_name> to the directory <repo_directory>"
  echo "It clones off of <remote1>. If git can't clone off of <remote1> it tries"
  echo "to clone off of <remote2>, then <remote3> etc."
  exit 1
fi

REPO_NAME=$1
REPO_DIR=$2

REMOTES=${@:3}

if [ -d $REPO_DIR ]; then
  echo "Directory $REPO_DIR exists, no need to clone"
  exit 0
fi

echo "###################################################################"
echo "# Cloning $REPO_NAME"

for remote in $REMOTES; do
	echo "# Trying $remote"
	git clone $remote $REPO_DIR >/dev/null 2>&1
	ERROR=$?
	if [ $ERROR -eq 0 ]; then
	  echo "#  SUCCESS"
	  exit 0
	fi
	echo "#  Skipped "
done
echo "#  FAILED cloning "
exit 1
