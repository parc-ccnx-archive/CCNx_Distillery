#! /usr/bin/env python
#
# Copyright (c) 2015, Xerox Corporation (Xerox) and Palo Alto Research Center, Inc (PARC)
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
# @author Ignacio (Nacho) Solis, Palo Alto Research Center (PARC)
# @copyright (c) 2015, Xerox Corporation (Xerox) and Palo Alto Research Center, Inc (PARC).  All rights reserved.
#

import os, signal, shutil, sys
import tempfile
import hashlib
import time
import random
import string

##
## A quick way to test metis and the ccnxSimpleFileTransfer_Server/ccnxSimpleFileTransfer_Client end to end.
##
## Starts a forwarder, creates a test data file in a temp directory, and tries to
## transfer the file using the ccnxSimpleFileTransfer example. It prints a message and returns 0 if
## successful. It prints another message and returns non-0 if there's a failure.
##
## Usage: sanityCheck-FileTransfer.py /path/to/build/bin
##        e.g. > sanityCheck-FileTransfer.py /home/you/CCNx_Distillery/usr/bin
##
## It will timeout in MAX_SECONDS_TO_WAIT_FOR_COMPLETION seconds, so can be used
## in automation scripts.
##

# Exit values
STATUS_OK = 0
STATUS_NEED_ARGUMENTS = 5
STATUS_COPY_FAILED = 10
STATUS_CHECKSUM_FAILED = 20
STATUS_MISSING_BINARIES = 30
STATUS_UNKNOWN_ERROR = 99

# The size of the file to create and transfer
TEST_FILE_SIZE = 1024 * 1024 * 2 # 2M

# How long to wait before killing child processes
MAX_SECONDS_TO_WAIT_FOR_COMPLETION = 55.0  # This is a function of file size and bandwidth

FORWARDER = "athena"

##
## Generator to return bytes, in chunks, from a file
##
def getBytesFromFile(filePath, chunksize=8192):
    with open(filePath, "rb") as f:
        while True:
            chunk = f.read(chunksize)
            if chunk:
                for b in chunk:
                    yield b
            else:
                break

##
## Calculate the checksum of a given file
##
def getChecksumOfFile(filePath):
    checksum = None
    hasher = hashlib.md5()

    for b in getBytesFromFile(filePath):
        hasher.update(b);

    checksum = hasher.hexdigest()
    return checksum

##
## Given two directories and a filename, check that the
## file exists in both directories and has the same
## contents.
##
def verifyChecksums(sourceDir, sinkDir, fileName):
    sourceFile = '%s/%s' % (sourceDir, fileName)
    sinkFile = '%s/%s' % (sinkDir, fileName)

    sourceSize = os.path.getsize(sourceFile)
    sinkSize = os.path.getsize(sinkFile)

    print "Comparing original [%d bytes] to copy [%d bytes]" % (sourceSize, sinkSize)
    if (sinkSize != sourceSize):
        print "The size of the copy did not match the size of the original"
        return False

    print "Comparing\n [%s] to\n [%s] " % (sourceFile, sinkFile)

    result = False
    try:
        sourceSum = getChecksumOfFile(sourceFile)
        sinkSum = getChecksumOfFile(sinkFile)
        result = (sourceSum == sinkSum)
    except:
        result = False

    return result

##
## Create something to transfer around
##
def createTestFile(dir, fileName):
    fullPath = '%s/%s' % (dir, fileName)

    print "Generating test file of size >= %d bytes ... " % TEST_FILE_SIZE

    testFile = open(fullPath, 'w+')
    numBytesWritten = 0

    while numBytesWritten < TEST_FILE_SIZE:
        #bytes = 'aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa'
        bytes = ''.join(random.choice(string.ascii_uppercase
                                      + string.digits) for _ in range(80))
        testFile.write(bytes)
        numBytesWritten = numBytesWritten + len(bytes)
        #print "Wrote: ",bytes,  numBytesWritten, len(bytes)

    testFile.close()

    return fullPath

##
## Create our temp directories and test file
##
def createTestData():
    testDir = tempfile.mkdtemp()
    sourceDir = '%s/sourceDir' % testDir
    sinkDir = '%s/sinkDir' % testDir

    os.mkdir(sourceDir)
    os.mkdir(sinkDir)

    fileName = 'testData.txt'
    fullNameOfData = createTestFile(sourceDir, fileName)

    return (testDir, sourceDir, sinkDir, fileName)


##
## Spawn a child process
##
def spawnChildProcess(workingDir, path, name, args):
    pid = os.fork()

    if pid == 0:
        # In the child.
        print "Starting [%s]" % name
        os.chdir(workingDir)
        os.execv(path, ['SANITY-' + name] + args)

    return pid


##
## Spawn the tutorialClient, but wait for it to finish transferring the
## specified file.
##
def transferData(binDir, sinkDir, fileName):
    result = False

    pid = None
    try:
        print "Starting ccnxSimpleFileTransfer_Client, in [%s]" % sinkDir
        childPID = spawnChildProcess(sinkDir,
                                     '%s/ccnxSimpleFileTransfer_Client' % binDir,
                                     'ccnxSimpleFileTransfer_Client', ['fetch', fileName])

        #os.waitpid(childPID, 0)
        waitSeconds = MAX_SECONDS_TO_WAIT_FOR_COMPLETION
        sleepTime = 1.0
        while waitSeconds > 0:
            time.sleep(sleepTime)
            print "Waiting for client to complete. Time out in %4.2f seconds..." % waitSeconds
            waitSeconds = waitSeconds - sleepTime
            pid, err_code = os.waitpid(childPID, os.WNOHANG)
            #print "pid, err", pid, err_code

            if pid != 0:   # Child process finished
                childPID = None
                if err_code >> 8 == 0:
                    result = True
                break;

    except(exc):
        print "Error running ccnxSimpleFileTransfer_Client", exc
        result = False

    finally:
        if childPID and childPID != 0:
            print "Killing ccnxSimpleFileTransfer_Client... (pid %d)" % childPID
            os.kill(childPID, signal.SIGTERM)

    return result


##
## Run the checks, given a directory in which to find metis and the tutorial binaries
##
def runFileTransferSanityCheck(binDir):
    result = STATUS_UNKNOWN_ERROR
    forwarderPID = None
    serverPID = None
    testDir = None

    try:
        # Start a forwarder
        forwarderPID = spawnChildProcess('.',
                                     '%s/%s' % (binDir, FORWARDER),
                                     FORWARDER, [])

        # create some test data while it starts...
        testDir, sourceDir, sinkDir, dataFile = createTestData()

        # start the ccnxSimpleFileTransfer_Server
        serverPID = spawnChildProcess(sourceDir,
                                      '%s/ccnxSimpleFileTransfer_Server' % binDir,
                                      'ccnxSimpleFileTransfer_Server', [sourceDir])

        # wait for it...
        time.sleep(1)

        # Run the ccnxSimpleFileTransfer_Client and transfer the test file from the sourceDir
        # to the sinkDir. This will block until ccnxSimpleFileTransfer_Client finishes.
        if transferData(binDir, sinkDir, dataFile):

            # Verify that the copied file matches the source
            if verifyChecksums(sourceDir, sinkDir, dataFile):
                print "\n\n>>>>   Looks good!   <<<<\n\n"
                result = STATUS_OK
            else:
                print "\n\n>>>>   Checksum test failed.  <<<<\n\n"
                result = STATUS_CHECKSUM_FAILED

        else:
            print "\n\n>>>>   File transfer failed.  <<<<\n\n"
            result = STATUS_COPY_FAILED

    except:
        # Need to be more specific...
        print "Unexpected error:", sys.exc_info()[0]
        result = STATUS_UNKNOWN_ERROR

    finally:
        # kill ccnxSimpleFileTransfer_Server
        if serverPID:
            print "Killing ccnxSimpleFileTransfer_Server..."
            os.kill(serverPID, signal.SIGTERM)

        # kill metis
        if forwarderPID:
            print "Killing metis..."
            os.kill(forwarderPID, signal.SIGTERM)

        # remove the tmp directories and test data
        print "Removing generated test directories..."
        #os.removedirs(testDir)
        if testDir:
            shutil.rmtree(testDir)

    return result

def checkBinariesExist(binDir):
    result = True
    apps = ['athena', 'metis_daemon',
            'ccnxSimpleFileTransfer_Client',
            'ccnxSimpleFileTransfer_Server']
    for app in apps:
        appPath = '%s/%s' % (binDir, app)
        if not os.path.isfile(appPath):
            result = False
            print "Can't find:", appPath

    return result


if __name__ == '__main__':

    result = STATUS_UNKNOWN_ERROR

    if (len(sys.argv) < 2):
        print "\nUsage: sanityCheck-FileTransfer.py /path/to/distillery/build/bin\n"
        result = STATUS_NEED_ARGUMENTS
    else:
        binDir = os.path.abspath(sys.argv[1])
        if checkBinariesExist(binDir):
            result = runFileTransferSanityCheck(binDir)
        else:
            result = STATUS_MISSING_BINARIES

    if result == STATUS_OK:
        print "Test successful. Returning [%d]" % result
    else:
        print "Test failed. Returning [%d]" % result

    sys.exit(result)
