$(eval Master_SOURCE_DIR?=${DISTILLERY_SOURCE_DIR})
$(eval Master_XCODE_DIR?=${DISTILLERY_XCODE_DIR})
$(eval Master_CLION_DIR?=${DISTILLERY_CLION_DIR})
$(eval modules_xcode+=MasterIDE)

# MasterIDE: MasterIDE.build

MasterIDE.build: MasterIDE.xcode

MasterIDE.clion: ${Master_CLION_DIR}/Makefile 
	@CMAKE_BUILD_TYPE_FLAG="-DCMAKE_BUILD_TYPE=DEBUG" DISTILLERY_BUILD_NAME=-debug ${MAKE} ${MAKE_BUILD_FLAGS} -C ${Master_CLION_DIR}

${Master_CLION_DIR}/Makefile: ${DISTILLERY_SOURCE_DIR}/CMakeLists.txt ${DISTILLERY_STAMP}
	    mkdir -p ${Master_CLION_DIR}
	    cd ${Master_CLION_DIR}; \
		    DEPENDENCY_HOME=${DISTILLERY_EXTERN_DIR} \
			cmake ${DISTILLERY_SOURCE_DIR} \
			${CMAKE_BUILD_TYPE_FLAG} \
		    -DCMAKE_INSTALL_PREFIX=${DISTILLERY_INSTALL_DIR}

MasterIDE.xcode-debug:
	@CMAKE_BUILD_TYPE_FLAG="-DCMAKE_BUILD_TYPE=DEBUG" DISTILLERY_BUILD_NAME=-debug ${MAKE} MasterIDE.xcode

MasterIDE.xcode: 
	@mkdir -p ${Master_XCODE_DIR}
	@cd ${Master_XCODE_DIR}; \
	  DEPENDENCY_HOME=${DISTILLERY_EXTERN_DIR} cmake -DCMAKE_BUILD_TYPE=Debug -G Xcode ${Master_SOURCE_DIR}

MasterIDE.xcodeopen: MasterIDE.xcode-debug
	@open ${Master_XCODE_DIR}/Master.xcodeproj

# xcode: MasterIDE.xcode

