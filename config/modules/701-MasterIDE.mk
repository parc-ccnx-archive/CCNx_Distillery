$(eval Master_SOURCE_DIR?=${DISTILLERY_SOURCE_DIR})
$(eval Master_XCODE_DIR?=${DISTILLERY_XCODE_DIR})
$(eval modules_xcode+=MasterIDE)

MasterIDE.build: debug-all

MasterIDE.xcode: MasterIDE.build
	@mkdir -p ${Master_XCODE_DIR}
	@cd ${Master_XCODE_DIR}; \
	  DEPENDENCY_HOME=${DISTILLERY_EXTERN_DIR} \
      CMAKE_BUILD_TYPE_FLAG="-DCMAKE_BUILD_TYPE=DEBUG" \
      DISTILLERY_BUILD_NAME=-debug \
      cmake -DCMAKE_BUILD_TYPE=Debug -G Xcode ${Master_SOURCE_DIR}

MasterIDE.xcodeopen: MasterIDE.xcode
	@open ${Master_XCODE_DIR}/Master.xcodeproj

MasterIDE.clion: MasterIDE.build

MasterIDE.clionopen: MasterIDE.clion
	@tools/bin/clion_wrapper.sh

xcode: MasterIDE.xcode

