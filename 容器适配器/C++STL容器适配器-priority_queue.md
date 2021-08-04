

# C++ 容器适配器

## C++ priority_queue容器适配器

priority_queue 容器适配器模拟的也是队列这种存储结构，即使用此容器适配器存储元素只能“从一端进（称为队尾），从另一端出（称为队头）”，且每次只能访问 priority_queue 中位于队头的元素。

但是，priority_queue 容器适配器中元素的存和取，遵循的并不是 “First in,First out”（先入先出）原则，而是“First in，Largest out”原则。直白的翻译，指的就是先进队列的元素并不一定先出队列，而是优先级最大的元素最先出队列。

> 注意，“First in，Largest out”原则是笔者为了总结 priority_queue 存取元素的特性自创的一种称谓，仅为了方便读者理解。

那么，priority_queue 容器适配器中存储的元素，优先级是如何评定的呢？很简单，每个 priority_queue 容器适配器在创建时，都制定了一种排序规则。根据此规则，该容器适配器中存储的元素就有了优先级高低之分。

举个例子，假设当前有一个 priority_queue 容器适配器，其制定的排序规则是按照元素值从大到小进行排序。根据此规则，自然是 priority_queue 中值最大的元素的优先级最高。

priority_queue 容器适配器为了保证每次从队头移除的都是当前优先级最高的元素，每当有新元素进入，它都会根据既定的排序规则找到优先级最高的元素，并将其移动到队列的队头；同样，当 priority_queue 从队头移除出一个元素之后，它也会再找到当前优先级最高的元素，并将其移动到队头。

基于 priority_queue 的这种特性，因此该容器适配器有被称为优先级队列。

> priority_queue 容器适配器“First in，Largest out”的特性，和它底层采用堆结构存储数据是分不开的。有关该容器适配器的底层实现，后续章节会进行深度剖析。

[STL](http://c.biancheng.net/stl/) 中，priority_queue 容器适配器的定义如下：

```c++
template <typename T,
        typename Container=std::vector<T>,
        typename Compare=std::less<T> >
class priority_queue{
    //......
}
```

可以看到，priority_queue 容器适配器模板类最多可以传入 3 个参数，它们各自的含义如下：

- typename T：指定存储元素的具体类型；

- typename Container：指定 priority_queue 底层使用的基础容器，默认使用 vector 容器。

  > 作为 priority_queue 容器适配器的底层容器，其必须包含 empty()、size()、front()、push_back()、pop_back() 这几个成员函数，[STL](http://c.biancheng.net/stl/) 序列式容器中只有 vector 和 deque 容器符合条件。

- typename Compare：指定容器中评定元素优先级所遵循的排序规则，默认使用

  ```c++
  std::less<T>
  ```

  按照元素值从大到小进行排序，还可以使用

  ```c++
  std::greater<T>
  ```

  按照元素值从小到大排序，但更多情况下是使用自定义的排序规则。

  > 其中，std::less<T> 和 std::greater<T> 都是以函数对象的方式定义在 <function> 头文件中。关于如何自定义排序规则，后续章节会做详细介绍。

#### 创建priority_queue的几种方式

由于 priority_queue 容器适配器模板位于`<queue>`头文件中，并定义在 std 命名空间里，因此在试图创建该类型容器之前，程序中需包含以下 2 行代码：

```c++
#include <queue>
using namespace std;
```

创建 priority_queue 容器适配器的方法，大致有以下几种。
1) 创建一个空的 priority_queue 容器适配器，第底层采用默认的 vector 容器，排序方式也采用默认的 std::less<T> 方法：

```c++
std::priority_queue<int> values;
```

2) 可以使用普通数组或其它容器中指定范围内的数据，对 priority_queue 容器适配器进行初始化：

```c++
//使用普通数组
int values[]{4,1,3,2};
std::priority_queue<int>copy_values(values,values+4);//{4,2,3,1}
//使用序列式容器
std::array<int,4>values{ 4,1,3,2 };
std::priority_queue<int>copy_values(values.begin(),values.end());//{4,2,3,1}
```

注意，以上 2 种方式必须保证数组或容器中存储的元素类型和 priority_queue 指定的存储类型相同。另外，用来初始化的数组或容器中的数据不需要有序，priority_queue 会自动对它们进行排序。

3) 还可以手动指定 priority_queue 使用的底层容器以及排序规则，比如：

```c++
int values[]{ 4,1,2,3 };
std::priority_queue<int, std::deque<int>, std::greater<int> >copy_values(values, values+4);//{1,3,2,4}
```

事实上，std::less<T> 和 std::greater<T> 适用的场景是有限的，更多场景中我们会使用自定义的排序规则。

> 由于自定义排序规则的方式不只一种，因此这部分知识将在后续章节做详细介绍。

#### priority_queue提供的成员函数

priority_queue 容器适配器提供了表 2 所示的这些成员函数

<center>表 1 priority_queue 提供的成员函数</center>

| 函数成员                       | 函数功能                                                     |
| ------------------------------ | ------------------------------------------------------------ |
| empty()                        | 如果 priority_queue 为空的话，返回 true；反之，返回 false。  |
| size()                         | 返回 priority_queue 中存储元素的个数。                       |
| top()                          | 返回 priority_queue 中第一个元素的引用形式。                 |
| push(const T& obj)             | 根据既定的排序规则，将元素 obj 的副本存储到 priority_queue 中适当的位置。 |
| push(T&& obj)                  | 根据既定的排序规则，将元素 obj 移动存储到 priority_queue 中适当的位置。 |
| emplace(Args&&... args)        | Args&&... args 表示构造一个存储类型的元素所需要的数据（对于类对象来说，可能需要多个数据构造出一个对象）。此函数的功能是根据既定的排序规则，在容器适配器适当的位置直接生成该新元素。 |
| pop()                          | 移除 priority_queue 容器适配器中第一个元素。                 |
| swap(priority_queue<T>& other) | 将两个 priority_queue 容器适配器中的元素进行互换，需要注意的是，进行互换的 2 个 priority_queue 容器适配器中存储的元素类型以及底层采用的基础容器类型，都必须相同。 |
> 和 queue 一样，priority_queue 也没有迭代器，因此访问元素的唯一方式是遍历容器，通过不断移除访问过的元素，去访问下一个元素。

下面的程序演示了表 2 中部分成员函数的具体用法：

```c++
#include <iostream>
#include <queue>
#include <array>
#include <functional>
using namespace std;
int main()
{
    //创建一个空的priority_queue容器适配器
    std::priority_queue<int>values;
    //使用 push() 成员函数向适配器中添加元素
    values.push(3);//{3}
    values.push(1);//{3,1}
    values.push(4);//{4,1,3}
    values.push(2);//{4,2,3,1}
    //遍历整个容器适配器
    while (!values.empty())
    {
        //输出第一个元素并移除。
        std::cout << values.top()<<" ";
        values.pop();//移除队头元素的同时，将剩余元素中优先级最大的移至队头
    }
    return 0;
}
```

运行结果为：

4 3 2 1

> 表 2 中其它成员函数的用法也非常简单，这里不再给出具体示例，后续章节用法会做具体介绍。

#### priority_queue容器适配器实现自定义排序

前面讲解 priority_queue 容器适配器时，还遗留一个问题，即当 <function> 头文件提供的排序方式（std::less<T> 和 std::greater<T>）不再适用时，如何自定义一个满足需求的排序规则。

首先，无论 priority_queue 中存储的是基础数据类型（int、double 等），还是 string 类对象或者自定义的类对象，都可以使用函数对象的方式自定义排序规则。例如：

```c++
#include<iostream>
#include<queue>
using namespace std;
//函数对象类
template <typename T>
class cmp
{
public:
    //重载 () 运算符
    bool operator()(T a, T b)
    {
        return a > b;
    }
};
int main()
{
    int a[] = { 4,2,3,5,6 };
    priority_queue<int,vector<int>,cmp<int> > pq(a,a+5);
    while (!pq.empty())
    {
        cout << pq.top() << " ";
        pq.pop();
    }
    return 0;
}
```

运行结果为：

2 3 4 5 6

注意，C++ 中的 struct 和 class 非常类似，前者也可以包含成员变量和成员函数，因此上面程序中，函数对象类 cmp 也可以使用 struct 关键字创建：

```c++
struct cmp
{
    //重载 () 运算符
    bool operator()(T a, T b)
    {
        return a > b;
    }
};
```

可以看到，通过在 cmp 类（结构体）重载的 () 运算符中自定义排序规则，并将其实例化后作为 priority_queue 模板的第 3 个参数传入，即可实现为 priority_queue 容器适配器自定义比较函数。

除此之外，当 priority_queue 容器适配器中存储的数据类型为结构体或者类对象（包括 string 类对象）时，还可以通过重载其 > 或者 < 运算符，间接实现自定义排序规则的目的。

> 注意，此方式仅适用于 priority_queue 容器中存储的为类对象或者结构体变量，也就是说，当存储类型为类的指针对象或者结构体指针变量时，此方式将不再适用，而只能使用函数对象的方式。

要想彻底理解这种方式的实现原理，首先要搞清楚 std::less<T> 和 std::greater<T> 各自的底层实现。实际上，<function> 头文件中的 std::less<T> 和 std::greater<T> ，各自底层实现采用的都是函数对象的方式。比如，std::less<T> 的底层实现代码为：

```c++
template <typename T>
struct less {
    //定义新的排序规则
    bool operator()(const T &_lhs, const T &_rhs) const {
        return _lhs < _rhs;
    }
};
```

std::greater<T> 的底层实现代码为：

```c++
template <typename T>
struct greater {
    bool operator()(const T &_lhs, const T &_rhs) const {
        return _lhs > _rhs;
    }
};
```

可以看到，std::less<T> 和 std::greater<T> 底层实现的唯一不同在于，前者使用 < 号实现从大到小排序，后者使用 > 号实现从小到大排序。

那么，是否可以通过重载 < 或者 > 运算符修改 std::less<T> 和 std::greater<T> 的排序规则，从而间接实现自定义排序呢？答案是肯定的，举个例子：

```c++
#include<queue>
#include<iostream>
using namespace std;
class node {
public:
    node(int x = 0, int y = 0) :x(x), y(y) {}
    int x, y;
};
//新的排序规则为：先按照 x 值排序，如果 x 相等，则按 y 的值排序
bool operator < (const node &a, const node &b) {
    if (a.x > b.x) return 1;
    else if (a.x == b.x)
        if (a.y >= b.y) return 1;
    return 0;
}
int main() {
    //创建一个 priority_queue 容器适配器，其使用默认的 vector 基础容器以及 less 排序规则。
    priority_queue<node> pq;
    pq.push(node(1, 2));
    pq.push(node(2, 2));
    pq.push(node(3, 4));
    pq.push(node(3, 3));
    pq.push(node(2, 3));
    cout << "x y" << endl;
    while (!pq.empty()) {
        cout << pq.top().x << " " << pq.top().y << endl;
        pq.pop();
    }
    return 0;
}
```

输出结果为：

x y
1 2
2 2
2 3
3 3
3 4

可以看到，通过重载 < 运算符，使得 std::less<T> 变得适用了。

> 读者还可以自行尝试，通过重载 > 运算符，赋予 std::greater<T> 和之前不同的排序方式。

当然，也可以以友元函数或者成员函数的方式重载 > 或者 < 运算符。需要注意的是，以成员函数的方式重载 > 或者 < 运算符时，该成员函数必须声明为 const 类型，且参数也必须为 const 类型，至于参数的传值方式是采用按引用传递还是按值传递，都可以（建议采用按引用传递，效率更高）。

例如，将上面程序改为以成员函数的方式重载 < 运算符：

```c++
class node {
public:
    node(int x = 0, int y = 0) :x(x), y(y) {}
    int x, y;
    bool operator < (const node &b) const{
        if ((*this).x > b.x) return 1;
        else if ((*this).x == b.x)
            if ((*this).y >= b.y) return 1;
        return 0;
    }
};
```

同样，在以友元函数的方式重载 < 或者 > 运算符时，要求参数必须使用 const 修饰。例如，将上面程序改为以友元函数的方式重载 < 运算符。例如：

```c++
class node {
public:
    node(int x = 0, int y = 0) :x(x), y(y) {}
    int x, y;
    friend bool operator < (const node &a, const node &b);
};
//新的排序规则为：先按照 x 值排序，如果 x 相等，则按 y 的值排序
bool operator < (const node &a, const node &b){
    if (a.x > b.x) return 1;
    else if (a.x == b.x)
        if (a.y >= b.y) return 1;
    return 0;
}
```

总的来说，以函数对象的方式自定义 priority_queue 的排序规则，适用于任何情况；而以重载 > 或者 < 运算符间接实现 priority_queue 自定义排序的方式，仅适用于 priority_queue 中存储的是结构体变量或者类对象（包括 string 类对象）。