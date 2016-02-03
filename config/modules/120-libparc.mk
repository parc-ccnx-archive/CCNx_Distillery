LIBPARC_MODULE_NAME=Libparc

ENABLE_LIBPARC?=${ENABLE_ALL_MODULES_BY_DEFAULT}

ifeq (${ENABLE_LIBPARC},YES)
modules+=${LIBPARC_MODULE_NAME}
endif

LIBPARC_SOURCE_DIR=${FOUNDATION_SOURCE_DIR}/${LIBPARC_MODULE_NAME}
LIBPARC_BUILD_DIR=${DISTILLERY_BUILD_DIR}/${LIBPARC_MODULE_NAME}
LIBPARC_GIT_CONFIG=${LIBPARC_SOURCE_DIR}/.git/config

LIBPARC_GIT_REPOSITORY=https://${DISTILLERY_GITHUB_SERVER}/${DISTILLERY_GITHUB_USER}/Libparc
LIBPARC_GIT_UPSTREAM_REPOSITORY=https://github.com/PARC/Libparc

modules_dir+=${LIBPARC_SOURCE_DIR}

# init target, called to initialize the module, normally this would do a git
# checkout or download the source/binary from somewhere
Libparc.init: ${LIBPARC_GIT_CONFIG}
	@cd ${LIBPARC_SOURCE_DIR} && git pull && git fetch --all

${LIBPARC_GIT_CONFIG}:
	@git clone ${LIBPARC_GIT_REPOSITORY} ${LIBPARC_SOURCE_DIR}
	@cd ${LIBPARC_SOURCE_DIR} && git remote add \
	  ${DISTILLERY_GITHUB_UPSTREAM_NAME} ${LIBPARC_GIT_UPSTREAM_REPOSITORY}

Libparc.build: ${LIBPARC_BUILD_DIR}/Makefile
	${MAKE} ${MAKE_BUILD_FLAGS} -C ${LIBPARC_BUILD_DIR} 

${LIBPARC_BUILD_DIR}/Makefile: ${LIBPARC_SOURCE_DIR}/CMakeLists.txt ${DISTILLERY_STAMP}
	    mkdir -p ${LIBPARC_BUILD_DIR}
	    cd ${LIBPARC_BUILD_DIR}; \
			cmake ${LIBPARC_SOURCE_DIR} \
		    -DCMAKE_INSTALL_PREFIX=${DISTILLERY_INSTALL_DIR}

Libparc.install: ${LIBPARC_BUILD_DIR}/Makefile
	@${MAKE} ${MAKE_BUILD_FLAGS} -C ${LIBPARC_BUILD_DIR} install

Libparc.clean: ${LIBPARC_BUILD_DIR}/Makefile
	@${MAKE} ${MAKE_BUILD_FLAGS} -C ${LIBPARC_BUILD_DIR} clean

Libparc.distclean: 
	@rm -rf ${LIBPARC_BUILD_DIR}

Libparc.check: ${LIBPARC_BUILD_DIR}/Makefile
	@${MAKE} ${MAKE_BUILD_FLAGS} -C ${LIBPARC_BUILD_DIR} test ${CMAKE_MAKE_TEST_ARGS}

# The Makefile.am (or any other dependency for a Makefile) is created when a
# repository is cloned. We do not know what the user wants at this point so
# give the user an error.
${LIBPARC_SOURCE_DIR}/CMakeLists.txt:
	    @$(MAKE) distillery.checkout.error
