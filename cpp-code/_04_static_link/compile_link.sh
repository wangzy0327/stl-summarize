# 可以先编译目标文件
gcc -xc++ -c main.cpp
# 直接执行如下命令，即可完成链接操作 -static 强制GCC使用静态链接库
gcc -static main.o libarithmetic.a liblogic.a -lstdc++ -o main.out

# 如果提示GCC编译器无法找到libxxx.a ,还可以使用如下方式完成链接操作
# -L（大写的 L）选项用于向 GCC 编译器指明静态链接库的存储位置（可以借助 pwd 指令查看具体的存储位置）
# -l（小写的 L）选项用于指明所需静态链接库的名称，注意这里的名称指的是 xxx 部分，且建议将 -l 和 xxx 直接连用（即 -lxxx），中间不需有空格
gcc main.o -static -L /home/wzy/cpp-code/_04_static_link/ -larithmetic -llogic -lstdc++ -o main.out

# 一次性生成可执行的目标文件
gcc -xc++ main.cpp -static -L /home/wzy/cpp-code/_04_static_link/ -larithmetic -llogic -lstdc++ -o main.out