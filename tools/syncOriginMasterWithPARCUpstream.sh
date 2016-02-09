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

echo "Syncing $CWD origin/master with parc_upstream/master"

# First, check if there is a parc_upstream remote at all
git remote | grep parc_upstream > /dev/null
if [ $? -ne 0 ]; then
    echo "  - No parc_upstream remote found in $CWD - skipping sync"
    exit 0
fi

# Now check that origin does not point to a PARC repo
git remote show origin | grep 'github.com/PARC/'
if [ $? -eq 0 ]; then
    echo "  - Origin points to a PARC repo - skipping sync to avoid accidental pushes."
    exit 0
fi

BRANCH=`git symbolic-ref --short HEAD`
git checkout master && git merge parc_upstream/master && git push
STATUS=$?
if [ $? -eq 0 ]; then
    echo "  - master succesfully synced with parc_upstream/master"
fi

echo "  - Switching back to branch <$BRANCH> in $CWD"
git checkout $BRANCH

exit $STATUS
