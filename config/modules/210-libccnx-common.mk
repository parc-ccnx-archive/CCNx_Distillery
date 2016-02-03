LIBCCNX_MODULE_NAME=Libccnx-common

ENABLE_LIBCCNX?=${ENABLE_ALL_MODULES_BY_DEFAULT}

ifeq (${ENABLE_LIBCCNX},YES)
modules+=${LIBCCNX_MODULE_NAME}
endif

LIBCCNX_SOURCE_DIR=${FRAMEWORK_SOURCE_DIR}/${LIBCCNX_MODULE_NAME}
LIBCCNX_BUILD_DIR=${DISTILLERY_BUILD_DIR}/${LIBCCNX_MODULE_NAME}
LIBCCNX_GIT_CONFIG=${LIBCCNX_SOURCE_DIR}/.git/config

LIBCCNX_GIT_REPOSITORY=https://${DISTILLERY_GITHUB_SERVER}/${DISTILLERY_GITHUB_USER}/Libccnx-common
LIBCCNX_GIT_UPSTREAM_REPOSITORY=https://github.com/PARC/Libccnx-common

modules_dir+=${LIBCCNX_SOURCE_DIR}

# init target, called to initialize the module, normally this would do a git
# checkout or download the source/binary from somewhere
Libccnx-common.init: ${LIBCCNX_GIT_CONFIG}
	@cd ${LIBCCNX_SOURCE_DIR} && git pull
	@cd ${LIBCCNX_SOURCE_DIR} && git remote add \
	  ${DISTILLERY_GITHUB_UPSTREAM_NAME} ${LIBCCNX_GIT_UPSTREAM_REPOSITORY}
	@cd ${LIBCCNX_SOURCE_DIR} && git fetch --all

${LIBCCNX_GIT_CONFIG}:
	@git clone ${LIBCCNX_GIT_REPOSITORY} ${LIBCCNX_SOURCE_DIR}

Libccnx-common.build: ${LIBCCNX_BUILD_DIR}/Makefile
	${MAKE} ${MAKE_BUILD_FLAGS} -C ${LIBCCNX_BUILD_DIR} 

${LIBCCNX_BUILD_DIR}/Makefile: ${LIBCCNX_SOURCE_DIR}/CMakeLists.txt ${DISTILLERY_STAMP}
	    mkdir -p ${LIBCCNX_BUILD_DIR}
	    cd ${LIBCCNX_BUILD_DIR}; \
			cmake ${LIBCCNX_SOURCE_DIR} \
		    -DCMAKE_INSTALL_PREFIX=${DISTILLERY_INSTALL_DIR}

Libccnx-common.install: ${LIBCCNX_BUILD_DIR}/Makefile
	@${MAKE} ${MAKE_BUILD_FLAGS} -C ${LIBCCNX_BUILD_DIR} install

Libccnx-common.clean: ${LIBCCNX_BUILD_DIR}/Makefile
	@${MAKE} ${MAKE_BUILD_FLAGS} -C ${LIBCCNX_BUILD_DIR} clean

Libccnx-common.distclean: 
	@rm -rf ${LIBCCNX_BUILD_DIR}

Libccnx-common.check: ${LIBCCNX_BUILD_DIR}/Makefile
	@${MAKE} ${MAKE_BUILD_FLAGS} -C ${LIBCCNX_BUILD_DIR} test ${CMAKE_MAKE_TEST_ARGS}

# The Makefile.am (or any other dependency for a Makefile) is created when a
# repository is cloned. We do not know what the user wants at this point so
# give the user an error.
${LIBCCNX_SOURCE_DIR}/CMakeLists.txt: 
	    @$(MAKE) distillery.checkout.error
