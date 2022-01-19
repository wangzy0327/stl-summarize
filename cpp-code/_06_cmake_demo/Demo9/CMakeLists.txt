cmake_minimum_required(VERSION 2.8)

#项目信息
project(Demo9)

#添加项目搜索路径
include_directories(include)

set (CMAKE_INCLUDE_CURRENT_DIR ON)

# 查找目录下的所有源文件
# 并将名称保存到 DIR_SRCS 变量
aux_source_directory(. DIR_SRCS)

# 添加 math 子目录
add_subdirectory(mymath)

# 指定生成目标
add_executable(Demo9 ${DIR_SRCS})

# 添加链接库
target_link_libraries(Demo9 MathFunctions)