cmake_minimum_required(VERSION 2.8.12)

set(CMAKE_C_COMPILER "/home/wzy/sycl_workspace/build-cuda/bin/clang")
set(CMAKE_CXX_COMPILER "/home/wzy/sycl_workspace/build-cuda/bin/clang++")
set(CMAKE_CXX_STANDARD 17)

project(oneDNN-example)

set(DPCPP_HOME "/home/wzy/sycl_workspace")
set(LLVM_HOME "/home/wzy/sycl_workspace/build-cuda")
set(DNN_HOME "${DPCPP_HOME}/oneDNN-cuda-debug")

message(STATUS "dpcpp_home : "${DPCPP_HOME})
message(STATUS "dnn_home : "${DNN_HOME})


link_directories("${LLVM_HOME}/lib")
link_directories("${DNN_HOME}/lib")


set(CMAKE_BUILD_RPATH "${LLVM_HOME}/lib;${CMAKE_BUILD_RPATH}")
set(CMAKE_BUILD_RPATH "${DNN_HOME}/lib;${CMAKE_BUILD_RPATH}")
message(STATUS "cmake build rpath : ${CMAKE_BUILD_RPATH}")

set(CMAKE_BUILD_TYPE "Debug")
set(CMAKE_CXX_FLAGS_DEBUG "$ENV{CXXFLAGS} -O0 -Wall -g -ggdb -std=c++17")
set(CMAKE_CXX_FLAGS_RELEASE "$ENV{CXXFLAGS} -O3 -Wall -std=c++17")

# no warning
add_definitions(-w)

aux_source_directory(. DIR_SRCS)
add_executable(starter ${DIR_SRCS})

target_include_directories(starter PRIVATE "${LLVM_HOME}/include/sycl")
target_include_directories(starter PRIVATE "${LLVM_HOME}/include")
target_include_directories(starter PRIVATE "${DNN_HOME}/include")
target_link_libraries(starter sycl dnnl )
