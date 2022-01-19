#include <iostream>
#include "mymath.hpp"

int main(){
    int a = 10,b = 10;
    int res_add = mymath::add(a,b);
    int res_mul = mymath::mul(a,b);
    std::cout<<"add in mymath result is : "<<res_add<<std::endl;
    std::cout<<"mul in mymath result is : "<<res_mul<<std::endl;
}