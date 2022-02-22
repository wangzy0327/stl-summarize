#include <iostream>
#include "mymath.hpp"

const int SIZE = 64;

int main(int argc,char* argv[]){
    int a = 10,b = 20;
    int res_add = mymath::add(a,b);
    int res_mul = mymath::mul(a,b);
    std::cout<<"add in mymath result is : "<<res_add<<std::endl;
    std::cout<<"mul in mymath result is : "<<res_mul<<std::endl;
    return 0;
}