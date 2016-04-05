$(eval Master_SOURCE_DIR?=${DISTILLERY_SOURCE_DIR})
$(eval Master_XCODE_DIR?=${DISTILLERY_XCODE_DIR})
$(eval modules_xcode+=MasterIDE)

${Master_SOURCE_DIR}/CMakeLists.txt:
	@echo "No CMakeLists.txt in ${Master_SOURCE_DIR}, copying config/MasterIDE-CMakeLists.txt"
	@cp config/MasterIDE-CMakeLists.txt ${Master_SOURCE_DIR}/CMakeLists.txt

MasterIDE.build: ${Master_SOURCE_DIR}/CMakeLists.txt debug-all

MasterIDE.xcode: debug-MasterIDE.build
	@mkdir -p ${Master_XCODE_DIR}
	cd ${Master_XCODE_DIR}; \
	  DEPENDENCY_HOME=${DISTILLERY_EXTERN_DIR} \
      cmake -DCMAKE_BUILD_TYPE=Debug -G Xcode ${Master_SOURCE_DIR}

MasterIDE.xcodeopen: debug-MasterIDE.xcode
	@open ${Master_XCODE_DIR}/Master.xcodeproj

MasterIDE.clion: debug-MasterIDE.build

MasterIDE.clionopen: debug-MasterIDE.clion
	@tools/bin/clion_wrapper.sh&
	@echo "CLion has be spawned"

xcode: debug-MasterIDE.xcode

