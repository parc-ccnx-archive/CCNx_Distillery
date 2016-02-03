METIS_MODULE_NAME=Metis

ENABLE_METIS?=${ENABLE_ALL_MODULES_BY_DEFAULT}

ifeq (${ENABLE_METIS},YES)
modules+=${METIS_MODULE_NAME}
endif

METIS_SOURCE_DIR=${FORWARDER_SOURCE_DIR}/${METIS_MODULE_NAME}
METIS_BUILD_DIR=${DISTILLERY_BUILD_DIR}/${METIS_MODULE_NAME}
METIS_GIT_CONFIG=${METIS_SOURCE_DIR}/.git/config

METIS_GIT_REPOSITORY=https://${DISTILLERY_GITHUB_SERVER}/${DISTILLERY_GITHUB_USER}/Metis
METIS_GIT_UPSTREAM_REPOSITORY=https://github.com/PARC/Metis

modules_dir+=${METIS_SOURCE_DIR}

# init target, called to initialize the module, normally this would do a git
# checkout or download the source/binary from somewhere
Metis.init: ${METIS_GIT_CONFIG}
	@cd ${METIS_SOURCE_DIR} && git pull && git fetch --all

${METIS_GIT_CONFIG}:
	@git clone ${METIS_GIT_REPOSITORY} ${METIS_SOURCE_DIR}
	@cd ${METIS_SOURCE_DIR} && git remote add \
	  ${DISTILLERY_GITHUB_UPSTREAM_NAME} ${METIS_GIT_UPSTREAM_REPOSITORY}

Metis.build: ${METIS_BUILD_DIR}/Makefile
	${MAKE} ${MAKE_BUILD_FLAGS} -C ${METIS_BUILD_DIR} 

${METIS_BUILD_DIR}/Makefile: ${METIS_SOURCE_DIR}/CMakeLists.txt ${DISTILLERY_STAMP}
		mkdir -p ${METIS_BUILD_DIR}
	    cd ${METIS_BUILD_DIR}; \
			cmake ${METIS_SOURCE_DIR} \
		    -DCMAKE_INSTALL_PREFIX=${DISTILLERY_INSTALL_DIR}

Metis.install: ${METIS_BUILD_DIR}/Makefile
	@${MAKE} ${MAKE_BUILD_FLAGS} -C ${METIS_BUILD_DIR} install

Metis.clean: ${METIS_BUILD_DIR}/Makefile
	@${MAKE} ${MAKE_BUILD_FLAGS} -C ${METIS_BUILD_DIR} clean

Metis.distclean:
	@rm -rf ${METIS_BUILD_DIR}

Metis.check: ${METIS_BUILD_DIR}/Makefile
	@${MAKE} ${MAKE_BUILD_FLAGS} -C ${METIS_BUILD_DIR} test ${CMAKE_MAKE_TEST_ARGS} 

# The CMakeLists.txt (or any other dependency for a Makefile) is created when a
# repository is cloned. We do not know what the user wants at this point so
# give the user an error.
${METIS_SOURCE_DIR}/CMakeLists.txt: 
	    @$(MAKE) distillery.checkout.error
