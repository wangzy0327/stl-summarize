cmake_minimum_required(VERSION 2.8)

# file(GLOB HEADERS_SUBDIR
#     ${CMAKE_CURRENT_SOURCE_DIR}/../include/*.h
#     ${CMAKE_CURRENT_SOURCE_DIR}/../include/*.hpp
#     )


# include_directories(
#     ${CMAKE_CURRENT_BINARY_DIR}
#     ${CMAKE_CURRENT_SOURCE_DIR})

message(STATUS "bin : ${CMAKE_CURRENT_BINARY_DIR}")    
message(STATUS "source : ${CMAKE_CURRENT_SOURCE_DIR}")   

# 查找当前目录下的所有源文件
# 并将名称保存到 DIR_LIB_SRCS 变量
aux_source_directory(. DIR_LIB_SRCS)

# 指定生成 MathFunctions 链接库
add_library (MathFunctions SHARED ${DIR_LIB_SRCS})
