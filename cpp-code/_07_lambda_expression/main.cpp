#include <vector>
#include <iostream>
#include <functional>

template <typename T>
T func_recur(std::vector<T> arr,std::function<T(T,T)> func){
    T res = T();
    if(arr.size() == 0 )
        return 0;
    else if(arr.size() == 1)
        return arr[arr.size() - 1];
    res = func(arr[0],arr[1]);
    for(int i = 2;i < arr.size() ;i++)
        res = func(res,arr[i]);
    return res;
}

int main(){
    int x = 10;
    //[capture](params) opt -> ret {body;};
    //表达式一般都是从[]开始 结束语{}
    auto basicLambda = [] {std::cout<<"Hello , World !"<<std::endl;};
    auto add_int = [](int a,int b)->int {return a + b;};
    auto add_x = [x](int a) { return a + x;};
    auto multi_x = [x](int a) {return a * x;};
    auto add_x_mutable = [x](int a) mutable {x *= 2; return x + a;};
    x = 10;
    auto add_x_mutable_refer = [&x](int a) mutable {x *= 2; return x + a;};

    //定义模板类 函数指针

    std::function<int(int,int)> func1 = [](int x,int y) {return x + y;};
    std::function<float(float,float)> func2 = [](float x,float y) {return x * y;};
    std::vector<int> vec1 = {1,2,3,4,5};
    std::vector<float> vec2 = {1.,2.,3.,4.,5.};


    std::cout<<"Lambda Expression : "<<std::endl;
    basicLambda();
    auto res_add_int = add_int(3,4);
    std::cout<<res_add_int<<std::endl;
    auto res_add = add_x(10);
    std::cout<<res_add<<std::endl;
    auto res_multi = multi_x(10);
    std::cout<<res_multi<<std::endl;
    auto res_add_mutable = add_x_mutable(10);
    std::cout<<res_add_mutable<<std::endl;
    std::cout<<x<<std::endl;

    auto res_add_mutable_refer = add_x_mutable_refer(10);
    std::cout<<res_add_mutable_refer<<std::endl;
    std::cout<<x<<std::endl;


    auto res_func_recur1 = func_recur(vec1,func1);
    auto res_func_recur2 = func_recur(vec2,func2);
    std::cout<<"func pointer res add : "<<res_func_recur1<<std::endl;
    std::cout<<"func pointer res multi : "<<res_func_recur2<<std::endl;

}