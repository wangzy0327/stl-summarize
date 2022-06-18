cmake_minimum_required(VERSION 3.5)

project(hello_library)

############################################################
# Create a library
############################################################

#Generate the shared library from the library sources
#打包动态链接库
# add_library(hello_library SHARED 
#     src/Hello.cpp
# )
# add_library(hello::library ALIAS hello_library)

#compiler with the -I flag eg. -I/directory/path
# target_include_directories(hello_library
#     PUBLIC 
#         ${PROJECT_SOURCE_DIR}/include
#         /home/wzy/cpp-code/demo/include
# )



############################################################
# Create an executable
############################################################

# Add an executable with the above sources
add_executable(hello_binary
    src/main.cpp
)

#compiler with the -I flag eg. -I/directory/path
#引入外部的头文件 路径是 /home/wzy/cpp-code/demo/include
target_include_directories(hello_binary PUBLIC /home/wzy/cpp-code/demo/include)


# set(CMAKE_INSTALL_RPATH "${CMAKE_INSTALL_PREFIX}/lib")
# set(CMAKE_INSTALL_RPATH_USE_LINK_PATH TRUE)
# set(CMAKE_SKIP_BUILD_RPATH FALSE)
# set(CMAKE_BUILD_RPATH "/home/wzy/cpp-code/demo/shared/;${CMAKE_BUILD_RPATH}")
# message(STATUS "cmake rpath : " ${CMAKE_BUILD_RPATH})

#find libmymath.so library
#引入外部的动态链接库 与 上面头文件对应
find_library(MYMATH 
    mymath 
    "/home/wzy/cpp-code/demo/shared" )

IF (NOT MYMATH)
    MESSGAGE(FATAL_ERROR "libmymath.so not found")
ENDIF(NOT MYMATH)

message(STATUS " mymath path : " ${MYMATH})


# link the new hello_library target with the hello_binary target
# cmake to link the hello_library against the hello_binary
# 将动态链接库链接进去
target_link_libraries( hello_binary
    PRIVATE 
        # hello::library
        ${MYMATH}
)
