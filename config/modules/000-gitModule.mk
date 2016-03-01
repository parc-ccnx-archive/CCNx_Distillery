############################################################
# Distillery Git Module
#
# This is a framework for Distillery Git Modules. 
#
# Modules can add themselves do distillery by calling the addGitModule
# function. A module called Foo would do the following:
#
# $(eval $(call addGitModule,Foo))
#
# Assumptions
# - The source for Foo is in git, located at: ${DISTILLERY_GITHUB_URL}/Foo
#   You can change this via a variable, see bellow.
#
# Parameters:
# This function can be modified by setting some variables for the specified
# module. These variables must be set BEFORE you call the function. replace
# "Module" by the parameter passed on to the funcion.
#
# - Module_GIT_REPOSITORY
#   URL to the Git repository of the source. 
#   Defaults to: ${DISTILLERY_GITHUB_URL}${DISTILLERY_GITHUB_URL_USER}/Foo
#   You can modify this to point to a different repository. (git origin)
# - Module_GIT_UPSTREAM_REPOSITORY
#   URL to the remote git repository to use as upstream. This defaults to
#   ${DISTILLERY_GITHUB_UPSTREAM_URL}/Module. The remote will be added to git
#   under the name ${DISTILLERY_GITHUB_UPSTREAM_NAME}    
# - Module_SOURCE_DIR
#   Location where the source will be downloaded. Don't change this unless you
#   have a very good reason to. 
# - Module_BUILD_DIR
#   Location where the source will be built. Don't change this unless you have
#   a very good reason to.


define addGitModule
$(eval $1_SOURCE_DIR?=${DISTILLERY_SOURCE_DIR}/$1)
$(eval $1_BUILD_DIR?=${DISTILLERY_BUILD_DIR}/$1)
$(eval $1_GIT_CONFIG?=${$1_SOURCE_DIR}/.git/config)
$(eval $1_GIT_REPOSITORY?=${DISTILLERY_GITHUB_URL}${DISTILLERY_GITHUB_URL_USER}/$1)
$(eval $1_GIT_UPSTREAM_REPOSITORY?=${DISTILLERY_GITHUB_UPSTREAM_URL}/$1)

status: $1.status

$1.status: tools/bin/getStatus
	@tools/bin/getStatus ${$1_SOURCE_DIR}

fetch: $1.fetch

$1.fetch:
	@echo --------------------------------------------
	@echo $1
	@cd ${$1_SOURCE_DIR}; git fetch --all

branch: $1.branch

$1.branch:
	@echo --------------------------------------------
	@echo $1
	@cd ${$1_SOURCE_DIR}; git branch -avv
	@echo

nuke-all-modules: $1.nuke

$1.nuke:
	@cd ${$1_SOURCE_DIR}; git clean -dfx && git reset --hard

sync: $1.sync

$1.sync: ${DISTILLERY_ROOT_DIR}/tools/bin/syncOriginMasterWithPARCUpstream
	@echo "-------------------------------------------------------------------"
	@echo $1
	@cd ${$1_SOURCE_DIR}; ${DISTILLERY_ROOT_DIR}/tools/bin/syncOriginMasterWithPARCUpstream

update: $1.update

$1.update: ${$1_GIT_CONFIG}
	@echo "-------------------------------------------------------------------"
	@echo "-  Updating ${$1_SOURCE_DIR}"
	@cd ${$1_SOURCE_DIR} && git fetch --all && git pull
	@echo

${$1_GIT_CONFIG}: tools/bin/gitCloneOneOf tools/bin/gitAddUpstream
	@tools/bin/gitCloneOneOf $1 ${$1_SOURCE_DIR} ${$1_GIT_REPOSITORY} ${$1_GIT_UPSTREAM_REPOSITORY}
	@tools/bin/gitAddUpstream $1 ${$1_SOURCE_DIR} ${DISTILLERY_GITHUB_UPSTREAM_NAME} ${$1_GIT_UPSTREAM_REPOSITORY}

info: $1.info

$1.info:
	@echo "# $1 INFO "
	@echo "$1_SOURCE_DIR = ${$1_SOURCE_DIR}"
	@echo "$1_BUILD_DIR = ${$1_BUILD_DIR}"
	@echo "$1_GIT_REPOSITORY = ${$1_GIT_REPOSITORY}"
	@echo "$1_GIT_UPSTREAM_REPOSITORY = ${$1_GIT_UPSTREAM_REPOSITORY}"

gitstatus: $1.gitstatus

$1.gitstatus: tools/bin/gitStatus
	@tools/bin/gitStatus $1 ${$1_SOURCE_DIR} ${$1_GIT_REPOSITORY} \
	  ${DISTILLERY_GITHUB_UPSTREAM_NAME} ${$1_GIT_UPSTREAM_REPOSITORY} 

endef
