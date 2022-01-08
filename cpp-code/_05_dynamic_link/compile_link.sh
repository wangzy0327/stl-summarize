# 可以先编译目标文件
gcc -xc++ -c main.cpp
# 直接执行如下命令，即可完成链接操作 -fpic 强制GCC使用动态链接库
gcc -fpic main.o libarithmetic.so liblogic.so -lstdc++ -o main.out

# 默认采用动态链接库的方式链接
gcc  main.o -larithmetic -llogic -lstdc++ -o main.out

# 运行由动态链接库生成的可执行文件时，必须确保程序在运行时可以找到这个动态链接库。常用的解决方案有如下几种
# 1、将链接库文件移动到标准库目录下（例如 /usr/lib、/usr/lib64、/lib、/lib64）
# 2、在终端输入export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:xxx，其中 xxx 为动态链接库文件的绝对存储路径（此方式仅在当前终端有效，关闭终端后无效）；
# 3、修改~/.bashrc 或~/.bash_profile 文件，即在文件最后一行添加export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:xxx（xxx 为动态库文件的绝对存储路径）。保存之后，执行source .bashrc指令（此方式仅对当前登录用户有效）

