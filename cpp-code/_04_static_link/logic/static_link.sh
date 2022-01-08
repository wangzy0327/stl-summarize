MYDIR=`dirname $0`
# 1 将所有指定的源文件，都编译成相应的目标文件
# gcc -xc++ -c add.cpp sub.cpp mul.cpp div.cpp 
gcc -xc++ -c and.cpp or.cpp not.cpp xor.cpp 
# 2 然后使用ar压缩指令，将生成的目标文件打包成静态链接库
# Linux 系统下，静态链接库的后缀名为 .a；Windows 系统下，静态链接库的后缀名为 .lib
# 静态链接库的命名 规则: libxxx.a , xxx代指为该库起的名字
# ar rcs libarithmetic.a add.o sub.o mul.o div.o
ar rcs liblogic.a and.o or.o not.o xor.o