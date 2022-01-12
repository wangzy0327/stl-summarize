# 可以先编译目标文件
gcc -xc++ -c main.cpp
# 直接执行如下命令，即可完成链接操作 -fpic 强制GCC使用动态链接库
gcc -fpic main.o libarithmetic.so liblogic.so -lstdc++ -o main.out

# 默认采用动态链接库的方式链接 library
gcc  main.o -larithmetic -llogic -lstdc++ -o main.out

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


 # C_INCLUDE_PATH编译 C 程序时使用该环境变量。该环境变量指定一个或多个目录名列表，查找头文件，就好像在命令行中指定 -isystem 选项一样。
 # 会首先查找 -isystem 指定的所有目录。

 # CPLUS_INCLUDE_PATH编译 C++ 程序时使用该环境变量。该环境变量指定一个或多个目录名列表，查找头文件，就好像在命令行中指定 -isystem 选项一样。
 # 会首先查找 -isystem 指定的所有目录
