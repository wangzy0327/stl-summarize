#include<iostream>
#include<cstring>
using namespace std;

struct Person{
    Person(string name):name(name),age(-1){};
    Person(string name,int age):name(name),age(age) {};

    void printInfo(){
        cout<<"Person :  ( name : "<<this->name<<" , age : "<<this->age<<" )"<<endl;
    }

    string name;
    int age;
};

//默认struct是 公有继承 struct中的变量也是公有的
struct Student:Person {
    Student(string name,int age,double score):Person(name,age){
        this->score = score;
    };

    void printInfo(){
        cout<<"Student :  ( name : "<<this->name<<" , age : "<<this->age<<" , score : "<<this->score<<" )"<<endl;
    }

    double score;
};

int main(int argc, char* argv[]){
    Student s("小明",10,98);
    s.printInfo();
}

