# 查找当前目录下的所有源文件
# 并将名称保存到 DIR_LIB_SRCS 变量
aux_source_directory(. DIR_LIB_SRCS)

# 指定生成 MathFunctions 链接库
add_library (MathFunctions ${DIR_LIB_SRCS})

# set (CMAKE_INSTALL_PREFIX  "${PROJECT_BINARY_DIR}")

MESSAGE ("TARGETS : "${TARGETS})
MESSAGE ("FILES : "${FILES})
MESSAGE ("DESTINATION : "${DESTINATION})
MESSAGE ("PROJECT_BINARY_DIR : "${PROJECT_BINARY_DIR})
MESSAGE ("CMAKE_INSTALL_PREFIX : "${CMAKE_INSTALL_PREFIX})

# 指定 MathFunctions 库的安装路径
install (TARGETS MathFunctions DESTINATION lib)
install (FILES MathFunctions.h DESTINATION include)
