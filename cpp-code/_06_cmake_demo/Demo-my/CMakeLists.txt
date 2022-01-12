cmake_minimum_required(VERSION 2.8)

set(CMAKE_C_COMPILER "clang")
set(CMAKE_CXX_COMPILER "clang++")
set(CMAKE_CXX_STANDARD 17)

project(oneDNN-example)

include_directories(/home/wzy/sycl_workspace/llvm/build-cuda/include/sycl)
include_directories(/home/wzy/sycl_workspace/llvm/build-cuda/include)
include_directories(/home/wzy/sycl_workspace/oneDNN-cuda/include)

set(CMAKE_BUILD_TYPE "Realease")
set(CMAKE_CXX_FLAGS_DEBUG "$ENV{CXXFLAGS} -O0 -Wall -g -ggdb -std=c++17")
set(CMAKE_CXX_FLAGS_RELEASE "$ENV{CXXFLAGS} -O3 -Wall -std=c++17")

aux_source_directory(. DIR_SRCS)
add_executable(t3s ${DIR_SRCS})
target_link_libraries(t3s -lsycl -ldnnl )
