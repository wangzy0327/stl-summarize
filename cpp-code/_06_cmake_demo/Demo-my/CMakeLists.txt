cmake_minimum_required(VERSION 2.8)

set(CMAKE_C_COMPILER "clang")
set(CMAKE_CXX_COMPILER "clang++")
set(CMAKE_CXX_STANDARD 17)

project(oneDNN-example)

set(DPCPP_HOME "/home/wzy/sycl_workspace")
set(DNN_HOME "${DPCPP_HOME}/oneDNN-cuda-debug")

message("dpcpp_home : "${DPCPP_HOME})
message("dnn_home : "${DNN_HOME})

include_directories("${DPCPP_HOME}/llvm/build-cuda-debug/include/sycl")
include_directories("${DPCPP_HOME}/llvm/build-cuda-debug/include")
include_directories("${DNN_HOME}/include")

link_directories("${DPCPP_HOME}/llvm/build-cuda-debug/lib")
link_directories("${DNN_HOME}/lib")


#set(CMAKE_INSTALL_RPATH "${DPCPP_HOME}/llvm/build-cuda-debug/lib" "${DNN_HOME}/lib")


set(CMAKE_BUILD_TYPE "Debug")
set(CMAKE_CXX_FLAGS_DEBUG "$ENV{CXXFLAGS} -O0 -Wall -g -ggdb -std=c++17")
set(CMAKE_CXX_FLAGS_RELEASE "$ENV{CXXFLAGS} -O3 -Wall -std=c++17")

aux_source_directory(. DIR_SRCS)
add_executable(t3s ${DIR_SRCS})
target_link_libraries(t3s -lsycl -ldnnl )
