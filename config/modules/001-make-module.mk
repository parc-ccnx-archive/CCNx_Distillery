############################################################
# Distillery Make Module
#
# This is a framework for Distillery Modules using make. 
#
# Modules can add themselves do distillery by calling the addMakeModule
# function. A module called Foo would do the following:
#
# $(eval $(call addMakeModule,Foo))
#
# Assumptions
# - The source for Foo is in git, located at: ${DISTILLERY_GITHUB_URL}/Foo
#   You can change this via a variable, see bellow.
# - The source can do an off-tree build.
# - The source is compiled via Make
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


define addMakeModule
$(eval $(call addModule,$1))

${$1_BUILD_DIR}/Makefile: ${$1_SOURCE_DIR}/Makefile
	@cp -rf ${$1_SOURCE_DIR}/ ${$1_BUILD_DIR}/

${$1_SOURCE_DIR}/Makefile: 
	@$(MAKE) distillery.checkout.error

$1.check: ${$1_BUILD_DIR}/Makefile
	@${MAKE} ${MAKE_BUILD_FLAGS} -C ${$1_BUILD_DIR} check

endef
