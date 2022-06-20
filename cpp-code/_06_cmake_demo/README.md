CMake-Demo
=====

cmake通常都是采用 out-of-source 外部构建，约定的构建目录是工程目录下的 build 目录

更通用的一般配置和编译命令采用如下方式：

创建一个cmake-build目录，并在其中进行cmake配置
cmake -B cmake-build

在cmake-build中进行编译(特别对于单元测试用例来说，采用这种构建命令方式)
cmake --build cmake-build

测试
GTEST_COLOR=TRUE ctest --output-on-failure

这里可以参考 [cmake模板](https://gitee.com/wangzy0327/cmake-template/blob/master/build.sh) 的代码


[CMake 入门实战](https://hahack.com/codes/cmake) 的源代码。

[示例模板](Demo-template/CMakeLists.txt)

[CMake引入本地Googletest示例](Demo-unittest/CMakeLists.txt)  [GoogleTest编译安装](https://blog.csdn.net/qq_32062657/article/details/125378651?spm=1001.2014.3001.5502)

