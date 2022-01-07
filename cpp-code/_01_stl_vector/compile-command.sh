gcc _01_vector.cpp -xc++ -lstdc++ -shared-libgcc -o _01_stl_vector_gcc
# 等价于 g++ _01_vector.cpp -o _01_stl_vector_gcc.out
# -E(大写) 预处理执行的源文件，不进行编译 C语言预处理后的文件后缀名默认.i gcc -xc++ -lstdc++ -E -C _01_vector.cpp -o _01_vector.i
# -S(大写) 编译指定的源文件，不进行汇编(词法分析、语法分析、语义分析以及优化,加工为当前机器支持的汇编代码)   C语言编译不汇编后的问题后缀为.s gcc -xc++ -lstdc++ -S _01_vector.i -o _01_vector.s
  #  -fverbose-asm 可以提高文件内汇编代码的可读性,GCC编译器会自行为汇编代码添加必要的注释
# -c 编译、汇编指定的源文件, 不进行链接 (生成目标文件,汇编其实就是将汇编代码转换成可以执行的机器指令) gcc -c _01_vector.s -o _01_vector.o 
# -c 编译多个文件时,不能指定-o 会报错的 gcc -c demo1.c demo2.c 会生成 demo1.o demo2.o
# 链接 gcc 会根据所给文件的后缀名.o,自行判断出此类文件为目标文件,仅需要进行链接操作 gcc _01_vector.o -o _01_vector.out -lstdc++
# gcc 多个文件生成可执行文件 gcc myfunc.c main.c -o main.out
# 默认gcc会自动在标准库目录中搜索文件 /usr/lib 或 /lib 或者 /usr/lib/gcc/x86_84-linux-gnu/9/
# -o 指定生成文件的文件名
# -C 阻止GCC删除源文件和头文件中的注释
# -l 适用于 "" 和 <> 导入的头文件,当搜索头文件失败时，会自动去-l指定的目录中去查找。建议用-iquote 代替
    # 前缀lib和后缀.a是标准的 stdc++是基本名称,gcc 会在 -l 选项后紧跟着基本名称的基础上自动添加这些前缀、后缀
    # math.h 头文件的数学库名称是 libm.a 链接时 ep: gcc main.c -o main.out -lm
# -L 链接其他目录中的库 使用-L选项，为 GCC 增加另一个搜索链接库的目录, 可以使用多个-L选项,或者在一个-L选项内使用冒号分割路径列表
# library 表示要搜索的库文件的名称 -llibrary (-llibrary) 建议-l和库文件之间不使用空格,如-lstdc++
