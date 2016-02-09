##############################################################
#
# CCNx Distillery project
#
# Copyright PARC 2015, 2016
#
# See LICENSE FILE
# Ignacio Solis <Ignacio.Solis@parc.com>
#
# This is the main Makefile for the Distillery CCNx distribution.
# It is in charge of pulling in all necessary modules to build a full CCNx
# system. 
# There is normally no need to modify this file. You can run "make help" to get
# more information or you can go directly to the configuration files to modify
# behavior.

DISTILLERY_VERSION=2.0

default.target: help

all: install-all

##############################################################
# Variables
#
# Set some variables
DISTILLERY_STAMP=.distillery.stamp
REBUILD_DEPENDS=

##############################################################
# Load the configuration
#
# For more information please see config.default.mk
#
DISTILLERY_CONFIG_DIR ?= config
DISTILLERY_USER_CONFIG_DIR  ?= ${HOME}/.ccnx/distillery

DISTILLERY_DEFAULT_CONFIG ?= ${DISTILLERY_CONFIG_DIR}/config.mk
DISTILLERY_LOCAL_CONFIG   ?= ${DISTILLERY_CONFIG_DIR}/local/config.mk
DISTILLERY_USER_CONFIG    ?= ${DISTILLERY_USER_CONFIG_DIR}/config.mk

ifneq (,$(wildcard ${DISTILLERY_USER_CONFIG}))
    include ${DISTILLERY_USER_CONFIG}
    REBUILD_DEPENDS+=${DISTILLERY_USER_CONFIG}
else
    DISTILLERY_USER_CONFIG+="[Not Found]"
endif

ifneq (,$(wildcard ${DISTILLERY_LOCAL_CONFIG}))
    include ${DISTILLERY_LOCAL_CONFIG}
    REBUILD_DEPENDS+=${DISTILLERY_LOCAL_CONFIG}
endif

include ${DISTILLERY_DEFAULT_CONFIG}


##############################################################
# Set the paths
#
# PATH: add our install dir, build dependencies and system dependencies
# LD_RUN_PATH: add our install dir

export PATH := $(DISTILLERY_INSTALL_DIR)/bin:$(DISTILLERY_TOOLS_DIR)/bin:$(PATH)
#export LD_RUN_PATH := $(DISTILLERY_INSTALL_DIR)/lib
#export LD_LIBRARY_PATH := $(DISTILLERY_INSTALL_DIR)/lib
export CCNX_HOME
export FOUNDATION_HOME


##############################################################
# Modules
#
# Load the modules config. Please refer to that file for more information
DISTILLERY_MODULES_DIR=${DISTILLERY_CONFIG_DIR}/modules

# The modules variable is a list of modules. It will be populated by the
# modules config files.
modules=
modules_dir=

include ${DISTILLERY_MODULES_DIR}/*.mk

# Load user defined modules
DISTILLERY_USER_MODULES_DIR=${DISTILLERY_USER_CONFIG_DIR}/modules
ifneq (,$(wildcard ${DISTILLERY_USER_MODULES_DIR}))
    include ${DISTILLERY_USER_MODULES_DIR}/*.mk
else
    DISTILLERY_USER_MODULES_DIR+="[Not Found]"
endif

ifdef ${DISTILLERY_LOCAL_MODULES_DIR}
    include ${DISTILLERY_LOCAL_MODULES_DIR}/*.mk
else
    DISTILLERY_LOCAL_MODULES_DIR="[Undefined]"
endif


##############################################################
# Build variables and rules
#

# We're going to create lists of targets as convenience
modules_clean=$(modules:=.clean)
modules_distclean=$(modules:=.distclean)
modules_init=$(modules:=.init)
modules_check=$(modules:=.check)
modules_step=$(modules:=.step)
modules_fetch=$(modules_dir:=.fetch)
modules_status=$(modules_dir:=.status)
modules_nuke=$(modules_dir:=.nuke)
modules_sync=$(modules_dir:=.sync)

# These are the basic build rules. They will call the module specific rules
install-all: install-directories pre-requisites ${modules}

# If somebody calls "make Module", we will build and install it
${modules}:
	@$(MAKE) $(@:=.build)				# make Module.build
	@$(MAKE) $(@:=.install)				# make Module.install

${modules_step}:
	@$(MAKE) $(@:.step=.build)			# make Module.build
	@$(MAKE) $(@:.step=.check)			# make Module.check
	@$(MAKE) $(@:.step=.install)		# make Module.install

${modules_status}: tools/getStatus
	@tools/getStatus $(@:.status=)

${modules_fetch}:
	@#cd Module_dir; git fetch
	@cd $(@:.fetch=); \
		git fetch --all

${modules_nuke}:
	@#cd Module_dir; git nuke
	@cd $(@:.nuke=); \
		git clean -dfx && git reset --hard

sync: distillery-sync ${modules_sync} 

distillery-sync: distillery-update ${DISTILLERY_ROOT_DIR}/tools/syncWithMaster
	@${DISTILLERY_ROOT_DIR}/tools/syncWithMaster
	
${modules_sync}: ${DISTILLERY_ROOT_DIR}/tools/syncWithMaster
	@echo Updating $(@:.sync=)
	@cd $(@:.sync=); git fetch --all
	@cd $(@:.sync=); ${DISTILLERY_ROOT_DIR}/tools/syncWithMaster


clobber: distclean
	@rm -rf ${CONFIGURE_CACHE_FILE}
	@rm -rf ${DISTILLERY_INSTALL_DIR}/bin
	@rm -rf ${DISTILLERY_INSTALL_DIR}/lib
	@rm -rf ${DISTILLERY_INSTALL_DIR}/include
	@rm -rf ${DISTILLERY_INSTALL_DIR}/share
	@rm -rf ${DISTILLERY_INSTALL_DIR}/etc
	@rm -rf .*.stamp

clean: ${modules_clean}
	@rm -rf report.txt

distclean: 
	@rm -rf ${DISTILLERY_BUILD_DIR}
	@rm -rf report.txt

update: distillery-update ${modules_init}

distillery-update:
	@echo "Fetching Distillery..."
	@git fetch --all
	@git pull

distillery-upstream:
	git remote add ${DISTILLERY_GITHUB_UPSTREAM_NAME} http://github.com/PARC/CCNx_Distillery

check: ${modules_check}

step: ${modules_step}

status: ${modules_status}
	@tools/getStatus ../CCNx_Distillery 

fetch: ${modules_fetch}

nuke-all-modules: ${modules_nuke}

dependencies:
	@${MAKE} -C dependencies

dependencies.clean:
	@${MAKE} -C dependencies clean

dependencies.clobber:
	@${MAKE} -C dependencies clobber

pre-requisites: 

help:
	@echo "Simple instructions: run \"make update step\""
	@echo 
	@echo "---- Basic build targets ----"
	@echo "make help      - This help message"
	@echo "make info      - Show basic information"
	@echo "make update    - git clone and pull the different modules to the head of master"
	@echo "make step      - Module by module: configure, compile and install all software"
	@echo "                  in the install directory (see make info) and run tests"
	@echo "make all       - Configure, compile and install all software in Distillery/build"
	@echo "make check     - Run all the tests"
	@echo "make clobber   - Clean the build, remove the install software"
	@echo 
	@echo "---- Advanced targets ----"
	@echo "make nuke-all-modules - DANGEROUS! Clean all the modules to git checkout (git clean -dfx)"
	@echo "                       - You will lose all uncommited changes"
	@echo "make clean     - Clean the build"
	@echo "make distclean - Distclean the build"
	@echo 
	@echo "---- Basic module targets ----"
	@echo "Module Directory = ${MODULES_DIRECTORY_DEFAULT}"
	@echo "Modules Loaded   = ${modules}"
	@echo "Per-module targets: \"Module\" \"Module.distclean\" \"Module.nuke\" "


${DISTILLERY_STAMP}: ${REBUILD_DEPENDS}
	touch $@ 

install-directories:
	@mkdir -p ${DISTILLERY_INSTALL_DIR}/include
	@mkdir -p ${DISTILLERY_INSTALL_DIR}/lib
	@mkdir -p ${DISTILLERY_INSTALL_DIR}/bin

Distillery.report:
	@echo '###################################'
	@echo 'Distillery report'
	@echo "#" `date "+%Y-%m-%d %H:%M:%S"`
	@echo "#" `uname -sr` "-" `uname -pm`
	@echo "#" `uname -n`
	@echo "#" PATH=${PATH}

	@git status 
	@git log -1 
	@git diff -U1

report.txt:
	$(MAKE) report > report.txt
	@cat report.txt

distillery.checkout.error:
	@echo
	@echo ===========================================================
	@echo
	@echo DISTILLERY ERROR: You have not checked out a repository! 
	@echo Please make sure to run \"make update\" at least once
	@echo
	@echo Otherwise there is a misconfigured module, 
	@echo please check the module config files at .distillery/modules
	@echo
	@echo ===========================================================
	@echo

info:
	@echo ------ Distillery Info ------
	@echo DISTILLERY_ROOT_DIR=${DISTILLERY_ROOT_DIR}
	@echo DISTILLERY_DEFAULT_CONFIG=${DISTILLERY_DEFAULT_CONFIG}
	@echo DISTILLERY_LOCAL_CONFIG=${DISTILLERY_LOCAL_CONFIG}
	@echo DISTILLERY_USER_CONFIG=${DISTILLERY_USER_CONFIG}
	@echo DISTILLERY_MODULES_DIR=${DISTILLERY_MODULES_DIR}
	@echo DISTILLERY_LOCAL_MODULES_DIR=${DISTILLERY_LOCAL_MODULES_DIR}
	@echo DISTILLERY_USER_MODULES_DIR=${DISTILLERY_USER_MODULES_DIR}
	@echo DISTILLERY_INSTALL_DIR=${DISTILLERY_INSTALL_DIR}
	@echo DISTILLERY_DEPENDENCIES_DIR=${DISTILLERY_DEPENDENCIES_DIR}
	@echo DISTILLERY_EXTERN_DIR=${DISTILLERY_EXTERN_DIR}
	@echo DISTILLERY_TOOLS_DIR=${DISTILLERY_TOOLS_DIR}
	@echo DISTILLERY_GITHUB_USER=${DISTILLERY_GITHUB_USER}
	@echo DISTILLERY_GITHUB_SERVER=${DISTILLERY_GITHUB_SERVER}
	@echo LD_LIBRARY_PATH=${LD_LIBRARY_PATH}
	@echo LD_RUN_PATH=${LD_RUN_PATH}
	@echo FOUNDATION_HOME=${FOUNDATION_HOME}
	@echo CCNX_HOME=${CCNX_HOME}
	@echo PATH=${PATH}

.PHONY: dependencies
