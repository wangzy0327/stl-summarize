#include<iostream>
#include<vector>

//加法
int add(int a,int b){
    return a+b;
}

int main(int argc,char* argv[]){
    std::cout<<"Hello vector!"<<std::endl;
    std::vector<int> v1{1,2,3};
    v1.push_back(5);
    int sum = 0;
    for(int ele:v1){
        std::cout<<ele<<std::endl;
        sum = add(sum,ele);
    }
}