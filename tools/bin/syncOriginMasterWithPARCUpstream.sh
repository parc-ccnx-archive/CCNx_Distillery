#!/bin/sh
#
# Copyright (c) 2016, Xerox Corporation (Xerox) and Palo Alto Research Center, Inc (PARC)
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
#
# * Redistributions of source code must retain the above copyright
#   notice, this list of conditions and the following disclaimer.
# * Redistributions in binary form must reproduce the above copyright
#   notice, this list of conditions and the following disclaimer in the
#   documentation and/or other materials provided with the distribution.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
# ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
# WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
# DISCLAIMED. IN NO EVENT SHALL XEROX OR PARC BE LIABLE FOR ANY
# DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
# (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
# LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
# ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
# (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
# SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#
# ################################################################################
# #
# # PATENT NOTICE
# #
# # This software is distributed under the BSD 2-clause License (see LICENSE
# # file).  This BSD License does not make any patent claims and as such, does
# # not act as a patent grant.  The purpose of this section is for each contributor
# # to define their intentions with respect to intellectual property.
# #
# # Each contributor to this source code is encouraged to state their patent
# # claims and licensing mechanisms for any contributions made. At the end of
# # this section contributors may each make their own statements.  Contributor's
# # claims and grants only apply to the pieces (source code, programs, text,
# # media, etc) that they have contributed directly to this software.
# #
# # There is no guarantee that this section is complete, up to date or accurate. It
# # is up to the contributors to maintain their portion of this section and up to
# # the user of the software to verify any claims herein.
# #
# # Do not remove this header notification.  The contents of this section must be
# # present in all distributions of the software.  You may only modify your own
# # intellectual property statements.  Please provide contact information.
#
# - Palo Alto Research Center, Inc
# This software distribution does not grant any rights to patents owned by Palo
# Alto Research Center, Inc (PARC). Rights to these patents are available via
# various mechanisms. As of January 2016 PARC has committed to FRAND licensing any
# intellectual property used by its contributions to this software. You may
# contact PARC at cipo@parc.com for more information or visit http://www.ccnx.org
#
# @author Alan Walendowski, Palo Alto Research Center (PARC)
# @copyright (c) 2016, Xerox Corporation (Xerox) and Palo Alto Research Center, Inc (PARC).  All rights reserved.


# This script is intended to sync origin/master with parc_upstream/master.
# It will fetch the changes in parc_upstream, and merge them into to
# origin/master.
# If you were on a different branch than master, you should still be on
# that branch when the script exits.

CWD=`pwd`

# The shortname of the repo dir we're syncing
REPO_DIR_NAME=$(basename $CWD)

# A place to send output to reduce the visual clutter
OUTPUT=/dev/null

echo "$REPO_DIR_NAME - merging parc_upstream/master into master and origin/master"

ORIGIN=`git config --get remote.origin.url 2>$OUTPUT`
if [ $? -ne 0 ]; then
    echo "Skipped  [$REPO_DIR_NAME] No origin found."
    exit 0
fi

# Check if there is a parc_upstream remote at all
PARC_UPSTREAM=`git config --get remote.parc_upstream.url 2>$OUTPUT`
if [ $? -ne 0 ]; then
    echo "$REPO_DIR_NAME - No parc_upstream found."
    exit 0
fi

# Fetch ALL of the upstream remotes
git fetch --all >> $OUTPUT

BRANCH=`git symbolic-ref --short HEAD`

if [ x'master' != x$BRANCH ]; then
    git checkout master &> $OUTPUT
fi

if [ $? -ne 0 ]; then
    echo "$REPO_DIR_NAME "
    echo "$REPO_DIR_NAME ##########################################################"
    echo "$REPO_DIR_NAME Could not switch to master. "
    echo "$REPO_DIR_NAME Please commit any unsaved changes in your branch."
    echo "$REPO_DIR_NAME ##########################################################"
    echo "$REPO_DIR_NAME "
    exit $?
fi

git merge parc_upstream/master >> $OUTPUT
if [ $? -eq 0 ]; then
    echo "$REPO_DIR_NAME - parc_upstream/master successfully merged into master"

    if [ $PARC_UPSTREAM != $ORIGIN ]; then
        git push --porcelain 2>&1 >> $OUTPUT
        echo "$REPO_DIR_NAME - master pushed to origin/master"
    fi
else
    echo "$REPO_DIR_NAME - WARNING - was not able to be synced with parc_upstream/master"
fi

if [ x'master' != x$BRANCH ]; then
    echo "$REPO_DIR_NAME - Switching back to branch <$BRANCH>"
    git checkout $BRANCH &> $OUTPUT
fi

exit $?
