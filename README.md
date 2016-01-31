# Distillery 2.0

This is the Distillery CCNx software distribution. It is in charge of pulling
together all the necessary modules to build a full CCNx software suite.

While Distillery brings a bunch of modules together; each module is
independent. As such, each may be from a different author or institution and
have it's own set of requirements. Please read their respective documentation.

Distillery provices a set of features for building CCNx software as well as
tools for writing, testing and evaluating code.

For Distillery licensing information please read the LICENSE file.

### Quick Start ###

Install dependencies:
```
make dependencies
```

The following commands will download all the code and compile it:
```
make update
make step
```

### Getting Started ###

To get simple help run `make`. This will give you a list of possible targets to
execute.

You will need to install dependencies `make dependencies`.  You can pull the
code from all the sub projects using `make update`. You can compile all the
binaries using `make all`. Run all tests using `make check`.  `make info` will
give you some information about the build environment.

### Contact ###

http://www.ccnx.org/

### License ###

This software is distributed under the following license:

```
Copyright (c) 2013, 2014, 2015, 2016, Xerox Corporation (Xerox)and Palo Alto
Research Center (PARC)
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:

* Redistributions of source code must retain the above copyright
  notice, this list of conditions and the following disclaimer.
* Redistributions in binary form must reproduce the above copyright
  notice, this list of conditions and the following disclaimer in the
  documentation and/or other materials provided with the distribution.
* Patent rights are not granted under this agreement. Patent rights are
  available under FRAND terms.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL XEROX or PARC BE LIABLE FOR ANY
DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
```
