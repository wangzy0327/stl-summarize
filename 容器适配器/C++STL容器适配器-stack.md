

# C++ 容器适配器

## C++ stack容器适配器

stack 栈适配器是一种单端开口的容器（如图 1 所示），实际上该容器模拟的就是栈存储结构，即无论是向里存数据还是从中取数据，都只能从这一个开口实现操作。

![../imgs/stack-struct.jpg](../imgs/stack-struct.jpg)

<center>图 1 stack 适配器示意图</center>

如图 1 所示，stack 适配器的开头端通常称为栈顶。由于数据的存和取只能从栈顶处进行操作，因此对于存取数据，stack 适配器有这样的特性，即每次只能访问适配器中位于最顶端的元素，也只有移除 stack 顶部的元素之后，才能访问位于栈中的元素。

> 栈中存储的元素满足“后进先出（简称LIFO）”的准则，stack 适配器也同样遵循这一准则。

#### stack容器适配器的创建

由于 stack 适配器以模板类 stack<T,Container=deque<T>>（其中 T 为存储元素的类型，Container 表示底层容器的类型）的形式位于<stack>头文件中，并定义在 std 命名空间里。因此，在创建该容器之前，程序中应包含以下 2 行代码：

```c++
#include <stack>
using namespace std;
```

> std 命名空间也可以在使用 stack 适配器时额外注明。

创建 stack 适配器，大致分为如下几种方式。

1) 创建一个不包含任何元素的 stack 适配器，并采用默认的 deque 基础容器：

```c++
std::stack<int> values;
```

上面这行代码，就成功创建了一个可存储 int 类型元素，底层采用 deque 基础容器的 stack 适配器。

2) 上面提到，stack<T,Container=deque<T>> 模板类提供了 2 个参数，通过指定第二个模板类型参数，我们可以使用出 deque 容器外的其它序列式容器，只要该容器支持 empty()、size()、back()、push_back()、pop_back() 这 5 个成员函数即可。

在介绍适配器时提到，序列式容器中同时包含这 5 个成员函数的，有 vector、deque 和 list 这 3 个容器。因此，stack 适配器的基础容器可以是它们 3 个中任何一个。例如，下面展示了如何定义一个使用 list 基础容器的 stack 适配器：

```c++
std::stack<std::string, std::list<int>> values;
```

3) 可以用一个基础容器来初始化 stack 适配器，只要该容器的类型和 stack 底层使用的基础容器类型相同即可。例如：

```c++
std::list<int> values {1, 2, 3};
std::stack<int,std::list<int>> my_stack (values);
```

注意，初始化后的 my_stack 适配器中，栈顶元素为 3，而不是 1。另外在第 2 行代码中，stack 第 2 个模板参数必须显式指定为 list<int>（必须为 int 类型，和存储类型保持一致），否则 stack 底层将默认使用 deque 容器，也就无法用 lsit 容器的内容来初始化 stack 适配器。

4) 还可以用一个 stack 适配器来初始化另一个 stack 适配器，只要它们存储的元素类型以及底层采用的基础容器类型相同即可。例如：

```C++
std::list<int> values{ 1, 2, 3 };
std::stack<int, std::list<int>> my_stack1(values);
std::stack<int, std::list<int>> my_stack=my_stack1;
//std::stack<int, std::list<int>> my_stack(my_stack1);
```

可以看到，和使用基础容器不同，使用 stack 适配器给另一个 stack 进行初始化时，有 2 种方式，使用哪一种都可以。

> 注意，第 3、4 种初始化方法中，my_stack 适配器的数据是经过拷贝得来的，也就是说，操作 my_stack 适配器，并不会对 values 容器以及 my_stack1 适配器有任何影响；反过来也是如此。

#### stack容器适配器支持的成员函数

和其他序列容器相比，stack 是一类存储机制简单、提供成员函数较少的容器。表 1 列出了 stack 容器支持的全部成员函数。

<center>表 1 stack容器适配器支持的成员函数</center>

| 函数成员                     | 函数功能                                                     |
| ---------------------------- | ------------------------------------------------------------ |
| empty()                      | 判断stack 栈中是否有元素，若无元素，则返回 true；反之，返回 false。 |
| size()                       | 返回stack 栈中存储元素的个数。                               |
| top()                        | 返回一个栈顶元素的引用，类型为 T&。如果栈为空，程序会报错。  |
| push(const T& val)           | 先复制 val，再将 val 副本压入栈顶。这是通过调用底层容器的 push_back() 函数完成的。 |
| push(T&& obj)                | 以移动元素的方式将其压入栈顶。这是通过调用底层容器的有右值引用参数的 push_back() 函数完成的。 |
| pop()                        | 弹出栈顶元素。                                               |
| emplace(arg...)              | arg... 可以是一个参数，也可以是多个参数，但它们都只用于构造一个对象，并在栈顶直接生成该对象，作为新的栈顶元素。 |
| swap(stack<T> & other_stack) | 将两个 stack 适配器中的元素进行互换，需要注意的是，进行互换的 2 个 stack 适配器中存储的元素类型以及底层采用的基础容器类型，都必须相同。 |
下面这个例子中演示了表 1 中部分成员函数的用法：

```c++
#include <iostream>
#include <stack>
#include <list>
using namespace std;
int main()
{
    //构建 stack 容器适配器
    list<int> values{ 1, 2, 3 };
    stack<int, list<int>> my_stack(values);
    //查看 my_stack 存储元素的个数
    cout << "size of my_stack: " << my_stack.size() << endl;
    //将 my_stack 中存储的元素依次弹栈，直到其为空
    while (!my_stack.empty())
    {  
        cout << my_stack.top() << endl;
        //将栈顶元素弹栈
        my_stack.pop();
    }
    return 0;
}
```

运行结果为：

size of my_stack: 3
3
2
1

> 表 1 中其它成员函数的用法也非常简单，这里不再给出具体示例，后续章节用法会做具体介绍。