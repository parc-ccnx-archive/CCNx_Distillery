############################################################
# Distillery CMake Module
#
# This is a framework for Distillery Modules using cmake. 
#
# Modules can add themselves do distillery by calling the addCMakeModule
# function. A module called Foo would do the following:
#
# $(eval $(call addCmakeModule,Foo))
#
# Assumptions
# - The source for Foo is in git, located at: ${DISTILLERY_GITHUB_URL}/Foo
#   You can change this via a variable, see bellow.
# - The source can do an off-tree build.
# - The source is compiled via CMake
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
# - Module_XCODE_DIR
#   Location where to put the xcode project Defaults to
#   ${DISTILLERY_XCODE_DIR}/Module



define addCMakeModule
$(eval $(call addModule,$1))
$(eval $1_XCODE_DIR?=${DISTILLERY_XCODE_DIR}/$1)
$(eval modules_xcode+=$1)

${$1_BUILD_DIR}/Makefile: ${$1_SOURCE_DIR}/CMakeLists.txt ${DISTILLERY_STAMP}
	    mkdir -p ${$1_BUILD_DIR}
	    cd ${$1_BUILD_DIR}; \
		    DEPENDENCY_HOME=${DISTILLERY_EXTERN_DIR} \
			cmake ${$1_SOURCE_DIR} \
			${CMAKE_BUILD_TYPE_FLAG} \
		    -DCMAKE_INSTALL_PREFIX=${DISTILLERY_INSTALL_DIR}

${$1_SOURCE_DIR}/CMakeLists.txt:
	    @$(MAKE) distillery.checkout.error

$1.check: ${$1_BUILD_DIR}/Makefile
	@${MAKE} ${MAKE_BUILD_FLAGS} -C ${$1_BUILD_DIR} test ${CMAKE_MAKE_TEST_ARGS}

$1.xcode: 
	@mkdir -p ${$1_XCODE_DIR}
	@cd ${$1_XCODE_DIR} && cmake -G Xcode ${$1_SOURCE_DIR}

$1.xcodeopen: $1.xcode
	@open ${$1_XCODE_DIR}/$1.xcodeproj

$1.coverage:
	@echo "### $1: "
	@longbow-coverage-report ` find ${$1_BUILD_DIR}  -type f -name 'test_*' -not -name '*\.*' `

$1.average-coverage:
	@echo "### $1: "
	@longbow-coverage-report -a ` find ${$1_BUILD_DIR}  -type f -name 'test_*' -not -name '*\.*' `


xcode: $1.xcode

endef
