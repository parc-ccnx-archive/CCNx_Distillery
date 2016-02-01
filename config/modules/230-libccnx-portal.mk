LIBCCNX_PORTAL_MODULE_NAME=Libccnx-portal

ENABLE_LIBCCNX_PORTAL?=${ENABLE_ALL_MODULES_BY_DEFAULT}

ifeq (${ENABLE_LIBCCNX_PORTAL},YES)
modules+=${LIBCCNX_PORTAL_MODULE_NAME}
endif

LIBCCNX_PORTAL_SOURCE_DIR=${FRAMEWORK_SOURCE_DIR}/${LIBCCNX_PORTAL_MODULE_NAME}
LIBCCNX_PORTAL_BUILD_DIR=${DISTILLERY_BUILD_DIR}/${LIBCCNX_PORTAL_MODULE_NAME}
LIBCCNX_PORTAL_GIT_CONFIG=${LIBCCNX_PORTAL_SOURCE_DIR}/.git/config

LIBCCNX_PORTAL_GIT_REPOSITORY=https://github.com/PARC/Libccnx-portal

modules_dir+=${LIBCCNX_PORTAL_SOURCE_DIR}

# init target, called to initialize the module, normally this would do a git
# checkout or download the source/binary from somewhere
Libccnx-portal.init: ${LIBCCNX_PORTAL_GIT_CONFIG}
	@cd ${LIBCCNX_PORTAL_SOURCE_DIR} && git pull

${LIBCCNX_PORTAL_GIT_CONFIG}:
	@git clone ${LIBCCNX_PORTAL_GIT_REPOSITORY} ${LIBCCNX_PORTAL_SOURCE_DIR}

Libccnx-portal.build: ${LIBCCNX_PORTAL_BUILD_DIR}/Makefile
	${MAKE} ${MAKE_BUILD_FLAGS} -C ${LIBCCNX_PORTAL_BUILD_DIR} 

${LIBCCNX_PORTAL_BUILD_DIR}/Makefile: ${LIBCCNX_PORTAL_SOURCE_DIR}/CMakeLists.txt ${DISTILLERY_STAMP}
		mkdir -p ${LIBCCNX_PORTAL_BUILD_DIR}
	    cd ${LIBCCNX_PORTAL_BUILD_DIR}; \
			cmake ${LIBCCNX_PORTAL_SOURCE_DIR} \
		    -DCMAKE_INSTALL_PREFIX=${DISTILLERY_INSTALL_DIR}

Libccnx-portal.install: ${LIBCCNX_PORTAL_BUILD_DIR}/Makefile
	@${MAKE} ${MAKE_BUILD_FLAGS} -C ${LIBCCNX_PORTAL_BUILD_DIR} install

Libccnx-portal.clean: ${LIBCCNX_PORTAL_BUILD_DIR}/Makefile
	@${MAKE} ${MAKE_BUILD_FLAGS} -C ${LIBCCNX_PORTAL_BUILD_DIR} clean

Libccnx-portal.distclean: 
	@rm -rf ${LIBCCNX_PORTAL_BUILD_DIR} 

Libccnx-portal.check: ${LIBCCNX_PORTAL_BUILD_DIR}/Makefile
	@${MAKE} ${MAKE_BUILD_FLAGS} -C ${LIBCCNX_PORTAL_BUILD_DIR} test ${CMAKE_MAKE_TEST_ARGS} 

# The Makefile.am (or any other dependency for a Makefile) is created when a
# repository is cloned. We do not know what the user wants at this point so
# give the user an error.
${LIBCCNX_PORTAL_SOURCE_DIR}/CMakeLists.txt:
	    @$(MAKE) distillery.checkout.error
