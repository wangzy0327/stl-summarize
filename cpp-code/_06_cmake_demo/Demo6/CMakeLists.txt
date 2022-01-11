# CMake 最低版本号要求
cmake_minimum_required (VERSION 3.16)

# 一定要设置在project之前  否则无效
set (CMAKE_C_COMPILER "/usr/bin/gcc")
set (CMAKE_CXX_COMPILER "/usr/bin/gcc")

# 项目信息
project (Demo6)

set (CMAKE_INCLUDE_CURRENT_DIR ON)


message("C compiler : "${CMAKE_C_COMPILER})
message("CXX compiler : "${CMAKE_CXX_COMPILER})


set(CMAKE_<LANG>_STANDARD_LIBRARIES "m")

set(CMAKE_CXX_COMPILE_FEATURES " -g -Wall -Werror -std=c++14")
set(CMAKE_C_COMPILE_FEATURES " -std=c14")

set(CMAKE_BUILD_TYPE "Debug")
message("ENV{CXXFLAGS} : "$ENV{CXXFLAGS})
# 使用$ENV{NAME}指令就可以调用系统的环境变量了
set(CMAKE_CXX_FLAGS_DEBUG "$ENV{CXXFLAGS} -O0 -Wall -g -ggdb")
set(CMAKE_CXX_FLAGS_RELEASE "$ENV{CXXFLAGS} -O3 -Wall")


# 检查系统是否支持 pow 函数
include (${CMAKE_ROOT}/Modules/CheckFunctionExists.cmake)
include (${CMAKE_ROOT}/Modules/CheckSymbolExists.cmake)
include (${CMAKE_ROOT}/Modules/CheckCXXSymbolExists.cmake)
#check_function_exists (pow HAVE_POW)
# Prefer using :Module:`CheckSymbolExists` instead of this module
# check_function_exists() can't detect functions that are inlined in headers or specified as a macro
# check_function_exists() only verifies linking, it does not verify that the function is declared in system headers
check_cxx_symbol_exists(pow "math.h" HAVE_POW)
check_cxx_symbol_exists(sqrt "math.h" HAVE_SQRT)
check_cxx_symbol_exists(printf "stdio.h" HAVE_PRINT)
check_cxx_symbol_exists(scanf "stdio.h" HAVE_SCAN)
check_cxx_symbol_exists(log "math.h" HAVE_LOG)

message("CMAKE_ROOT : "${CMAKE_ROOT})
message("hava pow : " ${HAVE_POW})
message("hava sqrt : " ${HAVE_SQRT})
message("hava log : " ${HAVE_LOG})
message("hava print : " ${HAVE_PRINT})
message("hava scan : " ${HAVE_SCAN})

# 加入一个配置头文件，用于处理 CMake 对源码的设置
configure_file (
  "${PROJECT_SOURCE_DIR}/config.h.in"
  "${PROJECT_BINARY_DIR}/config.h"
  )

# 是否加入 MathFunctions 库
if (NOT HAVE_POW)
  include_directories ("${PROJECT_SOURCE_DIR}/math")
  add_subdirectory (math)
  set (EXTRA_LIBS ${EXTRA_LIBS} MathFunctions)
endif (NOT HAVE_POW)

# 查找当前目录下的所有源文件
# 并将名称保存到 DIR_SRCS 变量
aux_source_directory(. DIR_SRCS)

# 指定生成目标
add_executable(Demo ${DIR_SRCS})
target_link_libraries (Demo  m)
#target_link_libraries (Demo  ${EXTRA_LIBS} m)

# 指定安装路径
install (TARGETS Demo DESTINATION bin)
install (FILES "${PROJECT_BINARY_DIR}/config.h"
         DESTINATION include)

# 启用测试
enable_testing()

# 测试程序是否成功运行
add_test (test_run Demo 5 2)

# 测试帮助信息是否可以正常提示
add_test (test_usage Demo)
set_tests_properties (test_usage
  PROPERTIES PASS_REGULAR_EXPRESSION "Usage: .* base exponent")

# 定义一个宏，用来简化测试工作
macro (do_test arg1 arg2 result)
  add_test (test_${arg1}_${arg2} Demo ${arg1} ${arg2})
  set_tests_properties (test_${arg1}_${arg2}
    PROPERTIES PASS_REGULAR_EXPRESSION ${result})
endmacro (do_test)
 
# 利用 do_test 宏，测试一系列数据
do_test (5 2 "is 25")
do_test (10 5 "is 100000")
do_test (2 10 "is 1024")
