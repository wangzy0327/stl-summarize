# C++ lambda表达式与函数对象

`lambda`表达式是`C++11`中引入的一项新技术，利用`lambda`表达式可以编写内嵌的匿名函数，用以替换独立函数或者函数对象，并且使代码更可读。但是从本质上来讲，`lambda`表达式只是一种语法糖，因为所有其能完成的工作都可以用其它稍微复杂的代码来实现。但是它简便的语法却给`C++`带来了深远的影响。如果从广义上说，`lamdba`表达式产生的是函数对象。在类中，可以重载函数调用运算符`()`，此时类的对象可以将具有类似函数的行为，我们称这些对象为函数对象（Function Object）或者仿函数（Functor）。相比`lambda`表达式，函数对象有自己独特的优势。

## C++ lambda表达式

Lambda 表达式是从类创建函数对象的精简方式。这里讲的类，它仅有的成员就是函数调用运算符。

Lambda 表达式取消了类声明，并且使用了精简的符号来表示函数调用运算符的逻辑。

 Lambda 表达式其实是函数的基础定义，但函数的名称和返回类型则使用 一对空白方括号[]来替代。Lambda 表达式经常釆用以下形式：

```
[ capture ] ( params ) opt -> ret { body; };
```

其中 capture 是捕获列表，params 是参数表，opt 是函数选项，ret 是返回值类型，body是函数体。

捕获从句是 Lambda 表达式作用域中的变量列表，可以从 Lambda 表达式的函数体访问。这与常规函数定义列出所有可以访问的全局变量相似。

定义一个可以输出字符串的`lambda`表达式，表达式一般都是从方括号`[]`开始，然后结束于花括号`{}`，花括号里面就像定义函数那样，包含了`lamdba`表达式体

```c++
// 定义简单的lambda表达式
auto basicLambda = [] { cout << "Hello, world!" << endl; };
// 调用
basicLambda();   // 输出：Hello, world!
```

上面是最简单的`lambda`表达式，没有参数。如果需要参数，那么就要像函数那样，放在圆括号里面，如果有返回值，返回类型要放在`->`后面，即拖尾返回类型，当然你也可以忽略返回类型，`lambda`会帮你自动推断出返回类型：

```c++
// 指明返回类型
auto add = [](int a, int b) -> int { return a + b; };
// 自动推断返回类型
auto multiply = [](int a, int b) { return a * b; };

int sum = add(2, 5);   // 输出：7
int product = multiply(2, 5);  // 输出：10
```

以下代码段将按降序对数组排序，它使用了 Lambda 表达式来代替函数对象作为排序函数的第 3 个参数：

```c++
double d_values[]{ 12.7, 45.9, 6.9};
//以降序排序数组
sort( begin(d_values), end(d_values),[](auto a, auto b) {return a > b;});
//打印数组
for (auto x : d_values)
{
    cout << x << " ";
}
```

因为 Lambda 表达式是函数对象，所以，可以将 Lambda 表达式赋值给一个类型适合的变量，并通过变量名来调用它。

例如，可以按如下方式给 Lambda 表达式分配一个名称：

```c++
auto compare = [](auto a, auto b) {return a > b;};
```

`lambda`表达式最前面的方括号的意义何在？其实这是`lambda`表达式一个很重要的功能，就是闭包。这里我们先讲一下`lambda`表达式的大致原理：每当你定义一个`lambda`表达式后，编译器会自动生成一个匿名类（这个类当然重载了`()`运算符），我们称为闭包类型（closure type）。那么在运行时，这个`lambda`表达式就会返回一个匿名的闭包实例，其实就是一个右值。所以，我们上面的`lambda`表达式的结果就是一个个闭包。闭包的一个强大之处是其可以通过传值或者引用的方式捕捉其封装作用域内的变量，前面的方括号就是用来定义捕捉模式以及变量，我们又将其称为`lambda`捕捉块。看下面的例子：

```C++
int main()
{
    int x = 10;
    
    auto add_x = [x](int a) { return a + x; };  // 复制捕捉x
    auto multiply_x = [&x](int a) { return a * x; };  // 引用捕捉x
    
    cout << add_x(10) << " " << multiply_x(10) << endl;
    // 输出：20 100
    return 0;
}
```

当`lambda`捕捉块为空时，表示没有捕捉任何变量。但是上面的`add_x`是以复制的形式捕捉变量`x`，而`multiply`是以引用的方式捕捉`x`。前面讲过，`lambda`表达式是产生一个闭包类，那么捕捉是回事？对于复制传值捕捉方式，类中会相应添加对应类型的非静态数据成员。在运行时，会用复制的值初始化这些成员变量，从而生成闭包。前面说过，闭包类也实现了函数调用运算符的重载，一般情况是：

```C++
class ClosureType
{
public:
    // ...
    ReturnType operator(params) const { body };
}
```

这意味着`lambda`表达式无法修改通过复制形式捕捉的变量，因为函数调用运算符的重载方法是`const`属性的。有时候，你想改动传值方式捕获的值，那么就要使用`mutable`，例子如下：

```C++
int main()
{
    int x = 10;
    
    auto add_x = [x](int a) mutable { x *= 2; return a + x; };  // 复制捕捉x
    
    cout << add_x(10) << endl; // 输出 30
    return 0;
}
```

这是为什么呢？因为你一旦将`lambda`表达式标记为`mutable`，那么实现了的函数调用运算符是非const属性的：

```C++
class ClosureType
{
public:
    // ...
    ReturnType operator(params) { body };
}
```

捕获的方式可以是引用也可以是复制，但是具体说来会有以下几种情况来捕获其所在作用域中的变量：

- []：默认不捕获任何变量；

- [=]：默认以值捕获所有变量；

- [&]：默认以引用捕获所有变量；

- [x]：仅以值捕获x，其它变量不捕获；

- [&x]：仅以引用捕获x，其它变量不捕获；

- [=, &x]：默认以值捕获所有变量，但是x是例外，通过引用捕获；

- [&, x]：默认以引用捕获所有变量，但是x是例外，通过值捕获；

- [this]：通过引用捕获当前对象（其实是复制指针）；

- [*this]：通过传值方式捕获当前对象；

  

`STL`定义在`<functional>`头文件提供了一个多态的函数对象封装`std::function`，其类似于函数指针。它可以绑定任何类函数对象，只要参数与返回类型相同。如下面的返回一个bool且接收两个int的函数包装器：

```C++
#include <functional>
std::function<bool(int, int)> wrapper = [](int x, int y) { return x < y; };
```



## C++ 函数对象

函数对象是一个广泛的概念，因为所有具有函数行为的对象都可以称为函数对象。这是一个高级抽象，我们不关心对象到底是什么，只要其具有函数行为。所谓的函数行为是指的是可以使用`()`调用并传递参数：

```c++
function(arg1, arg2, ...);   // 函数调用
```

这样来说，`lambda`表达式也是一个函数对象。但是这里我们所讲的是一种特殊的函数对象，这种函数对象实际上是一个类的实例，只不过这个类实现了函数调用符`()`：

```c++
class X
{
public:
    // 定义函数调用符
    ReturnType operator()(params) const;
    
    // ...
};
```

这样，我们可以使用这个类的对象，并把它当做函数来使用：

```c++
X f;
// ...
f(arg1, arg2); // 等价于 f.operator()(arg1, arg2);
```

还是例子说话，下面我们定义一个打印一个整数的函数对象：

```c++
#include <vector>
#include <algorithm>
// T需要支持输出流运算符
template <typename T>
class Print
{
public:
    void operator()(T elem) const
    {
        cout << elem << ' ' ;
    }
};


int main()
{
    vector<int> v(10);
    int init = 0;
    std::generate(v.begin(), v.end(), [&init] { return init++; });

    // 使用for_each输出各个元素（送入一个Print实例）
    std::for_each(v.begin(), v.end(), Print<int>{});
    // 利用lambda表达式：std::for_each(v.begin(), v.end(), [](int x){ cout << x << ' ';});
    // 输出：0, 1, 2, 3, 4, 5, 6, 7, 8, 9
    return 0;
}
```

可以看到`Print<int>`的实例可以传入`std::for_each`，其表现可以像函数一样，因此我们称这个实例为函数对象。大家可能会想，`for_each`为什么可以既接收`lambda`表达式，也可以接收函数对象，其实`STL`算法是泛型实现的，其不关心接收的对象到底是什么类型，但是必须要支持函数调用运算：

```c++
// for_each的类似实现
namespace std
{
    template <typename Iterator, typename Operation>
    Operation for_each(Iterator act, Iterator end, Operation op)
    {
        while (act != end)
        {
            op(*act);
            ++act;
        }
        return op;
    }
}
```

泛型提供了高级抽象，不论是`lambda`表达式、函数对象，还是函数指针，都可以传入`for_each`算法中。

本质上，函数对象是类对象，这也使得函数对象相比普通函数有自己的独特优势：

- **函数对象带有状态**：函数对象相对于普通函数是“智能函数”，这就如同智能指针相较于传统指针。因为函数对象除了提供函数调用符方法，还可以拥有其他方法和数据成员。所以函数对象有状态。即使同一个类实例化的不同的函数对象其状态也不相同，这是普通函数所无法做到的。而且函数对象是可以在运行时创建。

- **每个函数对象有自己的类型**：对于普通函数来说，只要签名一致，其类型就是相同的。但是这并不适用于函数对象，因为函数对象的类型是其类的类型。这样，函数对象有自己的类型，这意味着函数对象可以用于模板参数，这对泛型编程有很大提升。

- **函数对象一般快于普通函数**：因为函数对象一般用于模板参数，模板一般会在编译时会做一些优化。

  

  以上内容参考整理来源于 小白将的 [C++ lambda表达式与函数对象](https://www.jianshu.com/p/d686ad9de817)

  

  友情链接 [力扣](https://leetcode-cn.com/) 题库中使用lambda表达式与函数对象封装的题目 [考场就座](https://leetcode-cn.com/problems/exam-room/)