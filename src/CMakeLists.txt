cmake_minimum_required(VERSION 3.2)
project (master)

message("--- Master ---")

macro(Subdirs result parent)
    file(GLOB children LIST_DIRECTORIES true RELATIVE ${parent} "[^.]*")
    set(dirlist "")
    foreach(child ${children})
        if(IS_DIRECTORY ${parent}/${child})
            list(APPEND dirlist ${child})
        endif()
    endforeach()
    set(${result} ${dirlist})
endmacro()

Subdirs(modules ${CMAKE_SOURCE_DIR})

foreach(module ${modules})
    message("module: ${module}")
    set(CMAKE_MODULE_PATH "${CMAKE_SOURCE_DIR}/${module}/cmake/Modules")
    add_subdirectory(${module})
endforeach()

# set(CMAKE_MODULE_PATH "${CMAKE_SOURCE_DIR}/LongBow/cmake/Modules")
# add_subdirectory(LongBow)

# set(CMAKE_MODULE_PATH "${CMAKE_SOURCE_DIR}/Libparc/cmake/Modules")
# add_subdirectory(Libparc)

# set(CMAKE_MODULE_PATH "${CMAKE_SOURCE_DIR}/Libccnx-common/cmake/Modules")
# add_subdirectory(Libccnx-common)

# set(CMAKE_MODULE_PATH "${CMAKE_SOURCE_DIR}/Libccnx-portal/cmake/Modules")
# add_subdirectory(Libccnx-portal)

# set(CMAKE_MODULE_PATH "${CMAKE_SOURCE_DIR}/Libccnx-transport-rta/cmake/Modules")
# add_subdirectory(Libccnx-transport-rta)

# set(CMAKE_MODULE_PATH "${CMAKE_SOURCE_DIR}/Metis/cmake/Modules")
# add_subdirectory(Metis)

# set(CMAKE_MODULE_PATH "${CMAKE_SOURCE_DIR}/Athena/cmake/Modules")
# add_subdirectory(Athena)

