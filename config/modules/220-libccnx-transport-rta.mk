LIBCCNX_TRANSPORT_RTA_MODULE_NAME=Libccnx-transport-rta

ENABLE_LIBCCNX_TRANSPORT_RTA?=${ENABLE_ALL_MODULES_BY_DEFAULT}

ifeq (${ENABLE_LIBCCNX_TRANSPORT_RTA},YES)
modules+=${LIBCCNX_TRANSPORT_RTA_MODULE_NAME}
endif

LIBCCNX_TRANSPORT_RTA_SOURCE_DIR=${FRAMEWORK_SOURCE_DIR}/${LIBCCNX_TRANSPORT_RTA_MODULE_NAME}
LIBCCNX_TRANSPORT_RTA_BUILD_DIR=${DISTILLERY_BUILD_DIR}/${LIBCCNX_TRANSPORT_RTA_MODULE_NAME}
LIBCCNX_TRANSPORT_RTA_GIT_CONFIG=${LIBCCNX_TRANSPORT_RTA_SOURCE_DIR}/.git/config

LIBCCNX_TRANSPORT_RTA_GIT_REPOSITORY=https://github.com/PARC/Libccnx-transport-rta

modules_dir+=${LIBCCNX_TRANSPORT_RTA_SOURCE_DIR}

# init target, called to initialize the module, normally this would do a git
# checkout or download the source/binary from somewhere
Libccnx-transport-rta.init: ${LIBCCNX_TRANSPORT_RTA_GIT_CONFIG}
	@cd ${LIBCCNX_TRANSPORT_RTA_SOURCE_DIR} && git pull

${LIBCCNX_TRANSPORT_RTA_GIT_CONFIG}:
	@git clone ${LIBCCNX_TRANSPORT_RTA_GIT_REPOSITORY} ${LIBCCNX_TRANSPORT_RTA_SOURCE_DIR}

Libccnx-transport-rta.build: ${LIBCCNX_TRANSPORT_RTA_BUILD_DIR}/Makefile
	${MAKE} ${MAKE_BUILD_FLAGS} -C ${LIBCCNX_TRANSPORT_RTA_BUILD_DIR} 

${LIBCCNX_TRANSPORT_RTA_BUILD_DIR}/Makefile: ${LIBCCNX_TRANSPORT_RTA_SOURCE_DIR}/CMakeLists.txt ${DISTILLERY_STAMP}
		mkdir -p ${LIBCCNX_TRANSPORT_RTA_BUILD_DIR}
	    cd ${LIBCCNX_TRANSPORT_RTA_BUILD_DIR}; \
			cmake ${LIBCCNX_TRANSPORT_RTA_SOURCE_DIR} \
		    -DCMAKE_INSTALL_PREFIX=${DISTILLERY_INSTALL_DIR}

Libccnx-transport-rta.install: ${LIBCCNX_TRANSPORT_RTA_BUILD_DIR}/Makefile
	@${MAKE} ${MAKE_BUILD_FLAGS} -C ${LIBCCNX_TRANSPORT_RTA_BUILD_DIR} install

Libccnx-transport-rta.clean: ${LIBCCNX_TRANSPORT_RTA_BUILD_DIR}/Makefile
	@${MAKE} ${MAKE_BUILD_FLAGS} -C ${LIBCCNX_TRANSPORT_RTA_BUILD_DIR} clean

Libccnx-transport-rta.distclean: 
	@rm -rf ${LIBCCNX_TRANSPORT_RTA_BUILD_DIR} 

Libccnx-transport-rta.check: ${LIBCCNX_TRANSPORT_RTA_BUILD_DIR}/Makefile
	@${MAKE} ${MAKE_BUILD_FLAGS} -C ${LIBCCNX_TRANSPORT_RTA_BUILD_DIR} test ${CMAKE_MAKE_TEST_ARGS} 

# The Makefile.am (or any other dependency for a Makefile) is created when a
# repository is cloned. We do not know what the user wants at this point so
# give the user an error.
${LIBCCNX_TRANSPORT_RTA_SOURCE_DIR}/CMakeLists.txt: 
	    @$(MAKE) distillery.checkout.error
