#include "arithmetic.h"
#include "logic.h"
#include <iostream>

int main(int argc,char* argv[]){
    int a = 10,b = 20;
    int res1 = add_op(a,b);
    int res2 = and_op(a,b);
    std::cout<<"and arithmetic op ("<<a<<" , "<<b<<") result is : "<<res1<<std::endl;
    std::cout<<"and logic op ("<<a<<" , "<<b<<") result is : "<<res2<<std::endl;
}