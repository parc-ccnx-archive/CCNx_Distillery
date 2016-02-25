#!/bin/sh
#
# Copyright (c) 2016, Xerox Corporation (Xerox)and Palo Alto Research Center (PARC)
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
#
#     * Redistributions of source code must retain the above copyright
#       notice, this list of conditions and the following disclaimer.
#     * Redistributions in binary form must reproduce the above copyright
#       notice, this list of conditions and the following disclaimer in the
#       documentation and/or other materials provided with the distribution.
#     * Patent rights are not granted under this agreement. Patent rights are
#       available under FRAND terms.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
# ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
# WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
# DISCLAIMED. IN NO EVENT SHALL XEROX or PARC BE LIABLE FOR ANY
# DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
# (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
# LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
# ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
# (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
# SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#
# @author Alan Walendowski, Palo Alto Research Center (PARC)
# @copyright 2016, Xerox Corporation (Xerox)and Palo Alto Research Center (PARC).  All rights reserved.


# This script is intended to sync origin/master with parc_upstream/master.
# It will fetch the changes in parc_upstream, and merge them into to
# origin/master. 
# If you were on a different branch than master, you should still be on
# that branch when the script exits.

CWD=`pwd`

# You should not be syncing if you are set to the github.com/PARC or
# githubenterprise.com/CCNX users
declare -a READ_ONLY_REMOTES=('.com/PARC/' '.com/CCNX/')  # NO COMMAS

# The shortname of the repo dir we're syncing
REPO_DIR_NAME=$(basename $CWD)

# A place to send output to reduce the visual clutter
OUTPUT=/dev/null

echo "Syncing [$REPO_DIR_NAME] origin/master with parc_upstream/master"

# First, check if there is a parc_upstream remote at all
git remote | grep parc_upstream >> $OUTPUT
if [ $? -ne 0 ]; then
    echo "  - OK: [$REPO_DIR_NAME] update skipped."
    exit 0
fi

for _remote in "${READ_ONLY_REMOTES[@]}"
do
    # Now check that origin does not point to a PARC repo
    git remote show origin | grep $_remote >> $OUTPUT
    if [ $? -eq 0 ]; then
        echo "  - OK: [$REPO_DIR_NAME] origin points to a PARC repo - skipping sync to avoid accidental pushes."
        exit 0
    fi
done

# Fetch ALL of the upstream remotes
git fetch --all >> $OUTPUT

BRANCH=`git symbolic-ref --short HEAD`

if [ x'master' != x$BRANCH ]; then
    git checkout master &> $OUTPUT
fi

if [ $? -ne 0 ]; then
    echo " "
    echo "  - ######################################################################"
    echo "  - [$REPO_DIR_NAME] Could not switch to master. "
    echo "  - Please commit any unsaved changes in your branch."
    echo "  - ######################################################################"
    echo " "
    exit $?
fi

git merge parc_upstream/master >> $OUTPUT
if [ $? -eq 0 ]; then
    echo "  - OK: [$REPO_DIR_NAME] successfully synced with parc_upstream/master"
    git push --porcelain 2>&1 >> $OUTPUT
else
    echo "  - Warning: [$REPO_DIR_NAME] was not able to be synced with parc_upstream/master"
fi

if [ x'master' != x$BRANCH ]; then
    echo "  - Switching back to branch <$BRANCH> in $REPO_DIR_NAME"
    git checkout $BRANCH &> $OUTPUT
fi

exit $?
