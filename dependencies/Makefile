########################################################################
# CCNx Distillery project
#
# Copyright PARC 2014, 2015, 2016
# Ignacio.Solis@parc.com
#

.PHONY: dir_check


DEPENDENCIES_VERSION=20160131

########################################################################
# Define general variables to load dependencies

# Initialize these lists to empty
dep_clean=
dep_clobber=

all: system directories tools externs

include Makefile.downloader
include Makefile.unix

########################################################################
# We need a root dir for Distillery. If this is not in the environment, 
# assume it's in our parent directory
DISTILLERY_ROOT_DIR?=$(shell pwd)/..

# Load our config variables, the default, and the locally defined
ifneq (,$(wildcard ${HOME}/.ccnx/distillery/config.mk))
	include ${HOME}/.ccnx/distillery/config.mk
endif
ifneq (,$(wildcard ${DISTILLERY_ROOT_DIR}/config/local/config.mk))
	include ${DISTILLERY_ROOT_DIR}/config/local/config.mk
endif
include ${DISTILLERY_ROOT_DIR}/config/config.mk

# Set our PATH to include our own tools directory
export PATH := ${DISTILLERY_TOOLS_DIR}/bin:$(PATH)

DOWNLOAD_DIR=${DISTILLERY_DEPENDENCIES_DIR}/download


#############################################################################
# Dependency Modules


#######################
# PCRE
#######################

PCRE_DIR=pcre-8.38
PCRE_TARGZ=${PCRE_DIR}.tar.gz
PCRE_TARGZ_DOWNLOAD=${DOWNLOAD_DIR}/${PCRE_TARGZ}
PCRE_SEMAPHORE=${DISTILLERY_EXTERN_DIR}/${PCRE_DIR}.sem
PCRE_DOWNLOAD_URL=http://downloads.sourceforge.net/project/pcre/pcre/8.38

${PCRE_TARGZ_DOWNLOAD}: 
	cd ${DOWNLOAD_DIR}; ${DOWNLOADER} ${PCRE_DOWNLOAD_URL}/${PCRE_TARGZ}

${PCRE_DIR}/Makefile.in: ${PCRE_TARGZ_DOWNLOAD}
	tar -xzf ${PCRE_TARGZ_DOWNLOAD}
	touch ${PCRE_DIR}/Makefile.in

${PCRE_DIR}/Makefile: ${PCRE_DIR}/Makefile.in
	cd ${PCRE_DIR}; CFLAGS=-O2 ./configure ${HOST_ENV} --prefix=${DISTILLERY_EXTERN_DIR} --disable-debug-mode; 

${DISTILLERY_EXTERN_DIR}/include/pcre.h: 
	$(MAKE) ${PCRE_DIR}/Makefile
	cd ${PCRE_DIR}; $(MAKE) $(MAKE_BUILD_FLAGS); $(MAKE) install
	touch ${PCRE_SEMAPHORE}

pcre: ${DISTILLERY_EXTERN_DIR}/include/pcre.h

dep_clean += pcre-clean
dep_clobber += pcre-clobber

pcre-clean:
	@rm -rf ${PCRE_SEMAPHORE}

pcre-clobber:
	@rm -rf ${PCRE_DIR} 
	@rm -rf ${PCRE_SEMAPHORE}



#######################
# SWIG
#######################

SWIG_DIR=swig-3.0.2
SWIG_TARGZ=${SWIG_DIR}.tar.gz
SWIG_TARGZ_DOWNLOAD=${DOWNLOAD_DIR}/${SWIG_TARGZ}
SWIG_SEMAPHORE=${DISTILLERY_TOOLS_DIR}/${SWIG_DIR}.sem
SWIG_DOWNLOAD_URL=

${SWIG_TARGZ_DOWNLOAD}: 
	cd ${DOWNLOAD_DIR}; ${DOWNLOADER} ${SWIG_DOWNLOAD_URL}/${SWIG_TARGZ}

${SWIG_DIR}/Makefile.in: ${SWIG_TARGZ_DOWNLOAD}
	tar -xzf ${SWIG_TARGZ_DOWNLOAD}
	touch ${SWIG_DIR}/Makefile.in

${SWIG_DIR}/Makefile: ${SWIG_DIR}/Makefile.in
	cd ${SWIG_DIR}; CFLAGS=-O2 ./configure ${HOST_ENV} --prefix=${DISTILLERY_TOOLS_DIR} --disable-debug-mode ${WITH_PCRE_OPTION};

${DISTILLERY_TOOLS_DIR}/share/swig/3.0.2/python/python.swg: 
	$(MAKE) ${SWIG_DIR}/Makefile
	cd ${SWIG_DIR}; $(MAKE) $(MAKE_BUILD_FLAGS); $(MAKE) install
	touch ${SWIG_SEMAPHORE}

swig: ${DISTILLERY_TOOLS_DIR}/share/swig/3.0.2/python/python.swg

dep_clean += swig-clean
dep_clobber += swig-clobber

swig-clean:
	@rm -rf ${SWIG_SEMAPHORE}

swig-clobber:
	@rm -rf ${SWIG_DIR} 
	@rm -rf ${SWIG_SEMAPHORE}



#######################
# LIBEVENT
#######################

LIBEVENT_DIR=libevent-2.0.22-stable
LIBEVENT_TARGZ=${LIBEVENT_DIR}.tar.gz
LIBEVENT_TARGZ_DOWNLOAD=${DOWNLOAD_DIR}/${LIBEVENT_TARGZ}
LIBEVENT_SEMAPHORE=${DISTILLERY_EXTERN_DIR}/${LIBEVENT_DIR}.sem
LIBEVENT_DOWNLOAD_URL=https://github.com/libevent/libevent/releases/download/release-2.0.22-stable

${LIBEVENT_TARGZ_DOWNLOAD}: 
	cd ${DOWNLOAD_DIR}; ${DOWNLOADER} ${LIBEVENT_DOWNLOAD_URL}/${LIBEVENT_TARGZ}

${LIBEVENT_DIR}/Makefile.in: ${LIBEVENT_TARGZ_DOWNLOAD}
	tar -xzf ${LIBEVENT_TARGZ_DOWNLOAD}
	touch ${LIBEVENT_DIR}/Makefile.in

${LIBEVENT_DIR}/Makefile: ${LIBEVENT_DIR}/Makefile.in
	cd ${LIBEVENT_DIR}; CFLAGS=-O2 ./configure ${HOST_ENV} --prefix=${DISTILLERY_EXTERN_DIR} \
                       --disable-debug-mode --disable-openssl; 

${DISTILLERY_EXTERN_DIR}/include/event.h: 
	$(MAKE) ${LIBEVENT_DIR}/Makefile
	cd ${LIBEVENT_DIR}; $(MAKE) $(MAKE_BUILD_FLAGS); $(MAKE) install
	touch ${LIBEVENT_SEMAPHORE}

libevent: ${DISTILLERY_EXTERN_DIR}/include/event.h

dep_clean += libevent-clean
dep_clobber += libevent-clobber

libevent-clean:
	@rm -rf ${LIBEVENT_SEMAPHORE}

libevent-clobber:
	@rm -rf ${LIBEVENT_DIR} 
	@rm -rf ${LIBEVENT_SEMAPHORE}


#######################
# OPENSSL
#######################

OPENSSL_TARGZ=openssl-1.0.1q.tar.gz
OPENSSL_DIR=openssl-1.0.1q
OPENSSL_TARGZ_DOWNLOAD=${DOWNLOAD_DIR}/${OPENSSL_TARGZ}
OPENSSL_DOWNLOAD_URL=http://www.openssl.org/source
OPENSSL_SEMAPHORE=${DISTILLERY_EXTERN_DIR}/${OPENSSL_DIR}.sem
OPENSSL_URL=${OPENSSL_DOWNLOAD_URL}/${OPENSSL_TARGZ}

${OPENSSL_TARGZ_DOWNLOAD}: 
	cd ${DOWNLOAD_DIR}; ${DOWNLOADER} ${OPENSSL_URL}

${OPENSSL_DIR}/Makefile.in: ${OPENSSL_TARGZ_DOWNLOAD}
	tar -xzf ${OPENSSL_TARGZ_DOWNLOAD}
	touch ${OPENSSL_DIR}/Makefile.in

${OPENSSL_DIR}/Makefile: ${OPENSSL_DIR}/Makefile.in
ifeq (${CROSS_COMPILE_FLAG}, MIPS)
	cd ${OPENSSL_DIR}; patch < ../patches/openssl.patch ; ./Configure --prefix=${DISTILLERY_EXTERN_DIR} threads shared linux-octeon64
else
	cd ${OPENSSL_DIR}; ${OPENSSL_CONFIGURE} --prefix=${DISTILLERY_EXTERN_DIR} threads shared
endif

${DISTILLERY_EXTERN_DIR}/include/openssl/ssl.h: 
	$(MAKE) ${OPENSSL_DIR}/Makefile
	cd ${OPENSSL_DIR}; $(MAKE) $(MAKE_BUILD_FLAGS); $(MAKE) install
	touch ${OPENSSL_SEMAPHORE}

openssl: ${DISTILLERY_EXTERN_DIR}/include/openssl/ssl.h

dep_clean += openssl-clean
dep_clobber += openssl-clobber

openssl-clean:
	@rm -rf ${OPENSSL_SEMAPHORE}

openssl-clobber:
	@rm -rf ${OPENSSL_DIR} 
	@rm -rf ${OPENSSL_SEMAPHORE}


#######################
# CMAKE
#######################

CMAKE_DIR=cmake-3.4.3
CMAKE_TARGZ=${CMAKE_DIR}.tar.gz
CMAKE_TARGZ_DOWNLOAD=${DOWNLOAD_DIR}/${CMAKE_TARGZ}
CMAKE_SEMAPHORE=${DISTILLERY_TOOLS_DIR}/${CMAKE_DIR}.sem
CMAKE_DOWNLOAD_URL=https://cmake.org/files/v3.4

${CMAKE_TARGZ_DOWNLOAD}:
	cd ${DOWNLOAD_DIR}; ${DOWNLOADER} ${CMAKE_DOWNLOAD_URL}/${CMAKE_TARGZ}

${CMAKE_DIR}/Makefile.in: ${CMAKE_TARGZ_DOWNLOAD}
	tar -xzf ${CMAKE_TARGZ_DOWNLOAD}
	touch ${CMAKE_DIR}/Makefile.in

${CMAKE_DIR}/Makefile: ${CMAKE_DIR}/Makefile.in
	cd ${CMAKE_DIR}; ./configure ${HOST_ENV} --prefix=${DISTILLERY_TOOLS_DIR}

${DISTILLERY_TOOLS_DIR}/bin/cmake: 
	$(MAKE) ${CMAKE_DIR}/Makefile
	cd ${CMAKE_DIR}; $(MAKE) $(MAKE_BUILD_FLAGS); $(MAKE) install
	touch ${DISTILLERY_TOOLS_DIR}/bin/cmake
	touch ${CMAKE_SEMAPHORE}

cmake: ${DISTILLERY_TOOLS_DIR}/bin/cmake

dep_clean += cmake-clean
dep_clobber += cmake-clobber

cmake-clean:
	@rm -rf ${CMAKE_SEMAPHORE}

cmake-clobber:
	@rm -rf ${CMAKE_DIR} 
	@rm -rf ${CMAKE_SEMAPHORE}


#----------------------------------------------------
# uncrustify

UNCRUSTIFY_DIR=uncrustify-0.61
UNCRUSTIFY_TARGZ=${UNCRUSTIFY_DIR}.tar.gz
UNCRUSTIFY_SEMAPHORE=${DISTILLERY_TOOLS_DIR}/${UNCRUSTIFY_DIR}.sem
UNCRUSTIFY_DOWNLOAD_URL=http://downloads.sourceforge.net/project/uncrustify/uncrustify/uncrustify-0.61

dep_clean += uncrustify-clean
dep_clobber += uncrustify-clobber

uncrustify: ${DISTILLERY_TOOLS_DIR}/bin/uncrustify

${DISTILLERY_TOOLS_DIR}/bin/uncrustify: 
	$(MAKE) ${DOWNLOAD_DIR}/${UNCRUSTIFY_TARGZ} 
	tar xzf ${DOWNLOAD_DIR}/${UNCRUSTIFY_TARGZ}
	(cd ${UNCRUSTIFY_DIR} && ./configure --prefix=${DISTILLERY_TOOLS_DIR} && make)
	(cd ${UNCRUSTIFY_DIR} && make install )
	touch ${UNCRUSTIFY_SEMAPHORE}

uncrustify-clean:
	@rm -rf ${UNCRUSTIFY_SEMAPHORE}

uncrustify-clobber:
	@rm -rf ${UNCRUSTIFY_DIR} 
	@rm -rf ${UNCRUSTIFY_SEMAPHORE}

${DOWNLOAD_DIR}/${UNCRUSTIFY_TARGZ}:
	cd ${DOWNLOAD_DIR}; ${DOWNLOADER} ${UNCRUSTIFY_DOWNLOAD_URL}/${UNCRUSTIFY_TARGZ}


#----------------------------------------------------
# doxygen

DOXYGEN_DIR=doxygen-1.8.11
DOXYGEN_TARGZ=${DOXYGEN_DIR}.src.tar.gz
DOXYGEN_SEMAPHORE=${DISTILLERY_TOOLS_DIR}/${DOXYGEN_DIR}.sem
DOXYGEN_DOWNLOAD_URL=http://ftp.stack.nl/pub/users/dimitri/doxygen-1.8.11.src.tar.gz


dep_clean += doxygen-clean
dep_clobber += doxygen-clobber

doxygen: ${DISTILLERY_TOOLS_DIR}/bin/doxygen

${DISTILLERY_TOOLS_DIR}/bin/doxygen: 
	$(MAKE) ${DOWNLOAD_DIR}/${DOXYGEN_TARGZ}
	tar xzf ${DOWNLOAD_DIR}/${DOXYGEN_TARGZ}
	(cd ${DOXYGEN_DIR} && cmake -DCMAKE_INSTALL_PREFIX=${DISTILLERY_TOOLS_DIR} && make)
	(cd ${DOXYGEN_DIR} && make install)
	touch ${DOXYGEN_SEMAPHORE}

${DOWNLOAD_DIR}/${DOXYGEN_TARGZ}:
	cd ${DOWNLOAD_DIR}; ${DOWNLOADER} ${DOXYGEN_DOWNLOAD_URL}/${DOXYGEN_TARGZ}

doxygen-clean:
	@rm -rf ${DOXYGEN_SEMAPHORE}

doxygen-clobber:
	@rm -rf ${DOXYGEN_DIR}
	@rm -rf ${DOXYGEN_SEMAPHORE}


#############################################################################
# Figure out what we actually need

LONGBOW_EXTERNS=
LONGBOW_SEMAPHORES=

ifeq (${UNAME},Darwin)
    system_fix_as_root=
    DARWIN_LIBRARIES=libevent openssl
    DARWIN_SEMAPHORES=${LIBEVENT_SEMAPHORE} 
    DARWIN_TOOLS=pcre
    DARWIN_TOOLS_SEMAPHORES=${PCRE_SEMAPHORE} ${AUTOCONF_SEMAPHORE} ${AUTOMAKE_SEMAPHORE} ${LIBTOOL_SEMAPHORE}
    WITH_PCRE_OPTION=--with-pcre-prefix=${DISTILLERY_EXTERN_DIR}
    LONGBOW_EXTERNS+=doxygen uncrustify
    LONGBOW_SEMAPHORES+=${DOXYGEN_SEMAPHORE} ${UNCRUSTIFY_SEMAPHORE}
endif

ifeq (${UNAME},Linux)
  system_fix_as_root=ubuntu.install.packages
  LINUX_SYSTEM=
  ifndef DISABLE_UBUNTU_CHECK
    LINUX_SYSTEM += ubuntu-check-system
  endif
  ifndef DISABLE_UBUNTU_PACKAGE_CHECK
    LINUX_SYSTEM += ubuntu-check-packages
  endif
endif

ifdef HOST_ENV
    CROSS_COMPILE_LIBRARIES = libevent openssl
    CROSS_COMPILE_SEMAPHORES = ${LIBEVENT_SEMAPHORE} ${OPENSSL_SEMAPHORE}
endif

system: ${DARWIN_SYSTEM} ${LINUX_SYSTEM}

tools: ${DARWIN_TOOLS} cmake
	
tools_semaphores=${DARWIN_TOOLS_SEMAPHORES}

ifdef ENABLE_PYTHON_BINDINGS
tools: swig
tools_semaphores+=${SWIG_SEMAPHORE}
endif

externs: ${DARWIN_LIBRARIES} ${LINUX_LIBRARIES} ${LONGBOW_EXTERNS} ${CROSS_COMPILE_LIBRARIES}
externs_semaphores=${DARWIN_SEMAPHORES} ${LINUX_SEMAPHORES} ${LONGBOW_SEMAPHORES} ${CROSS_COMPILE_SEMAPHORES}

# In order to allow dependencies to change over time we have implemented
# a simple system of semaphores.  If the semaphore files are present, we 
# have already installed the required software.  
#
# If the semaphores are not present we are either new, or we have a missing
# dependency. If we do have a missing dependency then we must delete all the
# existing dependencies and start again. (This is so we don't keep track of
# inter-dependency dependencies and specific installed files.

DEPENDENCIES_SEMAPHORE=${DISTILLERY_EXTERN_DIR}/dependency-version-${DEPENDENCIES_VERSION}

DIRECTORIES_NEEDED=${DISTILLERY_TOOLS_DIR} ${DISTILLERY_EXTERN_DIR} ${DISTILLERY_DEPENDENCIES_DIR} ${DOWNLOAD_DIR}

directories: ${DEPENDENCIES_SEMAPHORE} ${tools_semaphores} ${externs_semaphores} ${DIRECTORIES_NEEDED}
	@touch ${DEPENDENCIES_SEMAPHORE}


${DIRECTORIES_NEEDED}:
	$(MAKE) directory_warning
	@mkdir -p ${DIRECTORIES_NEEDED} && touch ${DIRECTORIES_NEEDED}

directory_warning:
	@echo "**********************************************************************************"
	@echo Distillery will attempt to create the dependency directories if they don\'t exist.
	@echo If this fails you should create the directories yourself with the following commands:
	@echo 
	@echo sudo mkdir -p ${DIRECTORIES_NEEDED}
	@echo sudo chown `whoami` ${DIRECTORIES_NEEDED}
	@echo sudo chmod 755 ${DIRECTORIES_NEEDED}
	@echo
	@echo OR
	@echo
	@echo make -C dependencies fix-as-root
	@echo

fix-as-root: $(system_fix_as_root)
	sudo mkdir -p ${DIRECTORIES_NEEDED}
	sudo chown `whoami` ${DIRECTORIES_NEEDED}
	sudo chmod 755 ${DIRECTORIES_NEEDED}

${tools_semaphores}:
	@make clobber

${externs_semaphores}:
	@make clobber

${DEPENDENCIES_SEMAPHORE}:
	@make clobber

ubuntu.install.packages:
	@./ubuntu-install-packages.sh

ubuntu-check-system:
	@./ubuntu-check-system.sh

ubuntu-check-packages:
	@./ubuntu-check-packages.sh

clean: $(dep_clean)

clobber: $(dep_clobber) 
	@rm -rf ${DISTILLERY_TOOLS_DIR}
	@rm -rf ${DISTILLERY_EXTERN_DIR}
