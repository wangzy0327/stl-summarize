MYDIR=`dirname $0`
# 动态链接库的创建有两种
# 一种是直接使用源文件创建动态链接库
# -shared选项用于生成动态链接库; 
# -fpic 令 GCC 编译器生成动态链接库（多个目标文件的压缩包）时，表示各目标文件中函数、类等功能模块的地址使用相对地址，而非绝对地址
gcc -xc++ -fpic -shared and.cpp or.cpp xor.cpp not.cpp -o liblogic.so
# 另一种是先使用gcc -c 编译为目标文件，而后利用动态文件生成动态链接库
# 1 将所有指定的源文件，都编译成相应的目标文件
# 注意，为了后续生成动态链接库并能正常使用，将源文件编译为目标文件时，也需要使用 -fpic 选项
gcc -xc++ -c -fpic and.cpp or.cpp xor.cpp not.cpp  
# 2 利用上一步生成的目标文件生成动态链接库
# Linux 系统下，静态链接库的后缀名为 .a；Windows 系统下，静态链接库的后缀名为 .lib
# 静态链接库的命名 规则: libxxx.a , xxx代指为该库起的名字
gcc -shared  and.o or.o xor.o not.o -o liblogic.so 
# ar rcs liblogic.a and.o or.o not.o xor.o