LONGBOW_MODULE_NAME=LongBow

ENABLE_LONGBOW?=${ENABLE_ALL_MODULES_BY_DEFAULT}

ifeq (${ENABLE_LONGBOW},YES)
modules+=${LONGBOW_MODULE_NAME}
endif

LONGBOW_SOURCE_DIR=${FOUNDATION_SOURCE_DIR}/${LONGBOW_MODULE_NAME}
LONGBOW_BUILD_DIR=${DISTILLERY_BUILD_DIR}/${LONGBOW_MODULE_NAME}
LONGBOW_GIT_CONFIG=${LONGBOW_SOURCE_DIR}/.git/config

LONGBOW_GIT_REPOSITORY=https://github.com/PARC/LongBow

modules_dir+=${LONGBOW_SOURCE_DIR}

# init target, called to initialize the module, normally this would do a git
# checkout or download the source/binary from somewhere
LongBow.init: ${LONGBOW_GIT_CONFIG}
	@cd ${LONGBOW_SOURCE_DIR} && git pull

${LONGBOW_GIT_CONFIG}:
	@git clone ${LONGBOW_GIT_REPOSITORY} ${LONGBOW_SOURCE_DIR}

LongBow.build: ${LONGBOW_BUILD_DIR}/Makefile
	${MAKE} ${MAKE_BUILD_FLAGS} -C ${LONGBOW_BUILD_DIR} 

${LONGBOW_BUILD_DIR}/Makefile: ${LONGBOW_SOURCE_DIR}/CMakeLists.txt ${DISTILLERY_STAMP}
	    mkdir -p ${LONGBOW_BUILD_DIR}
	    cd ${LONGBOW_BUILD_DIR}; \
		    DEPENDENCY_HOME=${DISTILLERY_EXTERN_DIR} \
			cmake ${LONGBOW_SOURCE_DIR} \
		    -DCMAKE_INSTALL_PREFIX=${DISTILLERY_INSTALL_DIR}

LongBow.install: ${LONGBOW_BUILD_DIR}/Makefile
	@${MAKE} ${MAKE_BUILD_FLAGS} -C ${LONGBOW_BUILD_DIR} install

LongBow.clean: ${LONGBOW_BUILD_DIR}/Makefile
	@${MAKE} ${MAKE_BUILD_FLAGS} -C ${LONGBOW_BUILD_DIR} clean

LongBow.distclean: 
	rm -rf ${LONGBOW_BUILD_DIR}

LongBow.check: ${LONGBOW_BUILD_DIR}/Makefile
	@${MAKE} ${MAKE_BUILD_FLAGS} -C ${LONGBOW_BUILD_DIR} test ${CMAKE_MAKE_TEST_ARGS}

# The Makefile.am (or any other dependency for a Makefile) is created when a
# repository is cloned. We do not know what the user wants at this point so
# give the user an error.
${LONGBOW_SOURCE_DIR}/CMakeLists.txt:
	    @$(MAKE) distillery.checkout.error
