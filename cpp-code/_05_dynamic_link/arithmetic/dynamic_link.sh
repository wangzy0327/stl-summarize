MYDIR=`dirname $0`
# 动态链接库的创建有两种
# 一种是直接使用源文件创建动态链接库
# -shared选项用于生成动态链接库; 
# -fpic 令 GCC 编译器生成动态链接库（多个目标文件的压缩包）时，表示各目标文件中函数、类等功能模块的地址使用相对地址，而非绝对地址
gcc -xc++ -fpic -shared add.cpp sub.cpp mul.cpp div.cpp -o libarithmetic.so
# 另一种是先使用gcc -c 编译为目标文件，而后利用动态文件生成动态链接库
# 1 将所有指定的源文件，都编译成相应的目标文件
# 注意，为了后续生成动态链接库并能正常使用，将源文件编译为目标文件时，也需要使用 -fpic 选项
gcc -xc++ -c -fpic add.cpp sub.cpp mul.cpp div.cpp  
# 2 利用上一步生成的目标文件生成动态链接库
# Linux 系统下，静态链接库的后缀名为 .a；Windows 系统下，静态链接库的后缀名为 .lib
# 静态链接库的命名 规则: libxxx.a , xxx代指为该库起的名字
gcc -shared  add.o sub.o mul.o div.o -o libarithmetic.so 
# ar rcs liblogic.a and.o or.o not.o xor.o


# 头文件 (编译时)
# gcc在编译时如何去寻找所需要的头文件：

# 1、先搜索-I指定的目录

# 2、然后找gcc的环境变量C_INCLUDE_PATH，CPLUS_INCLUDE_PATH，OBJC_INCLUDE_PATH可以通过设置这些环境变量来添加系统include的路径

# 3、最后搜索gcc的内定目录(编译时可以通过-nostdinc++选项屏蔽对内定目录搜索头文件)

# 引入搜索头文件的路径 include ; 
# gcc 搜索内定目录 /usr/include /usr/local/include /usr/lib/gcc/x86_64-linux-gnu/9/include
# exp: 对应的第三方库文件可以 通过-l 来添加 需要链接的 动态链接库 ; -Wl,-rpath 用来设置动态链接库搜索路径 如果有多个用:分割 或者设置在LD_LIBRARY_PATH
# -L 用来设置编译时需要查找库的路径
gcc main.o -I/home/wzy/sycl_workspace/oneDNN-cuda/include \
-I/home/wzy/sycl_workspace/llvm/build-cuda/include/sycl \
-I/home/wzy/sycl_workspace/llvm/build-cuda/include/sycl \
-Wl,-rpath=/home/wzy/sycl_workspace/llvm/build-cuda/lib:/home/wzy/sycl_workspace/oneDNN-cuda/lib

# 库文件(分为编译时+运行时)
# 编译时

#1、gcc会去找-L

#2、再找gcc的环境变量LIBRARY_PATH

# LIBRARY_PATH和LD_LIBRARY_PATH是Linux下的两个环境变量，区别：LIBRARY_PATH环境变量用于在程序编译期间查找动态链接库时指定查找共享库的路径，而LD_LIBRARY_PATH环境变量用于在程序加载运行期间查找动态链接库时指定除了系统默认路径之外的其他路径

#3、再找内定目录/lib:/usr/lib:/usr/local/lib这是当初compile gcc时写在程序内的

# 运行时

# 运行由动态链接库生成的可执行文件时，必须确保程序在运行时可以找到这个动态链接库。常用的解决方案有如下几种
# 1、将链接库文件移动到标准库目录下（例如 /usr/lib、/usr/lib64、/lib、/lib64）
# 2、在终端输入export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:xxx，其中 xxx 为动态链接库文件的绝对存储路径（此方式仅在当前终端有效，关闭终端后无效）；
# 3、修改~/.bashrc 或~/.bash_profile 文件，即在文件最后一行添加export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:xxx（xxx 为动态库文件的绝对存储路径）。保存之后，执行source .bashrc指令（此方式仅对当前登录用户有效）
# 4、在配置文件/etc/ld.so.conf中指定动态库搜索路径 但是每次编辑完该文件后，都必须运行命令ldconfig以达到刷新 /etc/ld.so.cache的效果，使修改后的配置生效
# 注：ldconfig是一个动态链接库管理命令，为了让动态链接库为系统所共享,还需运行动态链接库的管理命令--ldconfig。 
# ldconfig 命令的用途,主要是在默认搜寻目录(/lib和/usr/lib)以及动态库配置文件/etc/ld.so.conf内所列的目录下,搜索出可共享的动态链接库(格式如前介绍,lib*.so*)，进而创建出动态装入程序(ld.so)所需的连接和缓存文件，缓存文件默认为 /etc/ld.so.cache，此文件保存已排好序的动态链接库名字列表。ldconfig做的这些东西都与运行程序时有关，跟编译时一点关系都没有。编译的时候还是该加-L就得加，不要混淆了；


 # C_INCLUDE_PATH编译 C 程序时使用该环境变量。该环境变量指定一个或多个目录名列表，查找头文件，就好像在命令行中指定 -isystem 选项一样。
 # 会首先查找 -isystem 指定的所有目录。

 # CPLUS_INCLUDE_PATH编译 C++ 程序时使用该环境变量。该环境变量指定一个或多个目录名列表，查找头文件，就好像在命令行中指定 -isystem 选项一样。
 # 会首先查找 -isystem 指定的所有目录