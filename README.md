# Distillery 2.0

This is the CCNx Distillery software distribution. It is in charge of pulling
together all the necessary modules to build a full CCNx software suite.

While Distillery brings a bunch of modules together; each module is
independent. As such, each may be from a different author or institution and
have it's own set of requirements. Please read their respective documentation.

Distillery provices a set of features for building CCNx software as well as
tools for writing, testing and evaluating code.

For Distillery licensing information please read the LICENSE file.

## Quick Start ##

```
# Clone this distro
git clone git@github.com:PARC/CCNx_Distillery.git
cd CCNx_Distillery

# Install dependencies (if needed)
make dependencies

# Update each of the modules
make update

# Compile everything
make all

# Test everything
make check
```

The CCNx software will be installed in `CCNx_Distillery/usr`

## Contents ##

Distillery brings together a set of modules that are needed to build a full CCNx distribution. It checks each one out and compiles them in order.  The modules used by Distillery can be configured and customized.  By default the following modules are included:

- [LongBow](https://github.com/PARC/LongBow)
- [Libparc](https://github.com/PARC/Libparc)
- [Libccnx-common](https://github.com/PARC/Libccnx-common)
- [Libccnx-transport-rta](https://github.com/PARC/Libccnx-transport-rta)
- [Libccnx-portal](https://github.com/PARC/Libccnx-portal)
- [Metis](https://github.com/PARC/Metis)
- [Athena](https://github.com/PARC/Athena)

## Platforms ##

- Ubuntu 14.04LTS
- MacOS X 10.10 Yosemite
- MacOS X 10.11 El Capitan

We on Linux and Mac and spend most of our time in Ubuntu and El Capitan.  The software does run on other environemnts, both other OSs and other architectures. However we don't do much testing on this. Distillery has been known to work on ARM and MIPS, Debian and Android.

With time we expect portability will improve.

## Dependencies ##

You can install dependencies from Distillery with the command: `make dependencies`. We keep the dependency install as up-to-date as possible but it may fall out of date every once in a while.

For Ubuntu/Debian Linux systems you can install many of the dependencies via apt-get / aptitude or the relevant package manager.  While we aim to keep our depedencies in sync with what's available with Ubuntu 14.04LTS this is not always possible.

On Mac we install most of what we need by downloading and compiling the respective tarballs.

Currently Distillery has the following main dependencies:

- CMake 3.4.3
- Libevent 2.0.22
- OpenSSL 1.0.1q
- pcre 8.38

LongBow can also make use of the following tools:

- uncrustify 0.61
- doxygen 1.8.9.1


## Getting Started ##

To get simple help run `make`. This will give you a list of possible targets to
execute. You will basically want to download all the sources and compile.

Here's a short summary:

- `make dependencies` - Make the dependencies needed to build Distillery
- `make update` - Update all the source modules (git clone / git pull)
- `make all` - Compile all the software
- `make check` - Run all unit tests
- `make step` - Compile and test each module in sequence
- `make info` - Show some of the environment variables used by Distillery
- `make status` - Show the git status of each module
- `make distclean` - Delete build directory (but not built executables)
- `make clobber` - Delete build directory and install directories. WARNING - If you configure this to install on a system directory this may delete system files!


## Configuration ##

Distillery can be configured in multiple ways.  Please check the config directory (specifically `config/config.mk`) for more information.

## Contact ##

You can find more information about CCNx at the main web page, [CCNx.org](http://www.ccnx.org).
Discussion about CCNx Distillery takes place in the [CCNx mailing list](https://www.ccnx.org/mailman/listinfo/ccnx/), please join the discussion there.  You can also file any issues you find on the [CCNx Distillery github](https://github.com/PARC/CCNx_Distillery).


## License ##

This software is distributed under the following license:

```
Copyright (c) 2013,2014,2015,2016, Xerox Corporation (Xerox) and Palo Alto Research Center, Inc (PARC)
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:

* Redistributions of source code must retain the above copyright
  notice, this list of conditions and the following disclaimer.
* Redistributions in binary form must reproduce the above copyright
  notice, this list of conditions and the following disclaimer in the
  documentation and/or other materials provided with the distribution.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL XEROX OR PARC BE LIABLE FOR ANY
DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

################################################################################
#
# PATENT NOTICE
#
# This software is distributed under the BSD 2-clause License (see LICENSE
# file).  This BSD License does not make any patent claims and as such, does
# not act as a patent grant.  The purpose of this section is for each contributor
# to define their intentions with respect to intellectual property.
#
# Each contributor to this source code is encouraged to state their patent
# claims and licensing mechanisms for any contributions made. At the end of
# this section contributors may each make their own statements.  Contributor's
# claims and grants only apply to the pieces (source code, programs, text,
# media, etc) that they have contributed directly to this software.
#
# There is no guarantee that this section is complete, up to date or accurate. It
# is up to the contributors to maintain their portion of this section and up to
# the user of the software to verify any claims herein.
#
# Do not remove this header notification.  The contents of this section must be
# present in all distributions of the software.  You may only modify your own
# intellectual property statements.  Please provide contact information.

- Palo Alto Research Center, Inc
This software distribution does not grant any rights to patents owned by Palo
Alto Research Center, Inc (PARC). Rights to these patents are available via
various mechanisms. As of January 2016 PARC has committed to FRAND licensing any
intellectual property used by its contributions to this software. You may
contact PARC at cipo@parc.com for more information or visit http://www.ccnx.org
```
<div id="statcounter_image" style="display:inline;"><a
title="shopify visitor statistics"
href="http://statcounter.com/shopify/"
class="statcounter"><img src="//c.statcounter.com/11128191/0/f0069625/0/" alt="shopify visitor statistics" style="border:none;" /></a></div>
