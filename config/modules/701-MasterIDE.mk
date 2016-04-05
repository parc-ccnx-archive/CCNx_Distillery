$(eval Master_SOURCE_DIR?=${DISTILLERY_SOURCE_DIR})
$(eval Master_XCODE_DIR?=${DISTILLERY_XCODE_DIR})
$(eval modules_xcode+=MasterIDE)

MasterIDE.build: debug-all

MasterIDE.xcode: debug-MasterIDE.build
	@mkdir -p ${Master_XCODE_DIR}
	cd ${Master_XCODE_DIR}; \
	  DEPENDENCY_HOME=${DISTILLERY_EXTERN_DIR} \
      cmake -DCMAKE_BUILD_TYPE=Debug -G Xcode ${Master_SOURCE_DIR}

MasterIDE.xcodeopen: debug-MasterIDE.xcode
	@open ${Master_XCODE_DIR}/Master.xcodeproj

MasterIDE.clion: debug-MasterIDE.build

MasterIDE.clionopen: debug-MasterIDE.clion
	@tools/bin/clion_wrapper.sh

xcode: debug-MasterIDE.xcode

