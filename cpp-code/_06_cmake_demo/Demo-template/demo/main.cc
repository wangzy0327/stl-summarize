#include <iostream>
#include "test.h"

using namespace std;

int main(){
    int m,n;
    cout<<"input two numbers"<<endl;
    cin>>m>>n;
    cout<<m<<"+"<<n<<"="<<add(m,n)<<endl;
    cout<<m<<"-"<<n<<"="<<sub(m,n)<<endl;
    return 0;
}