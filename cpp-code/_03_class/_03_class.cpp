#include<iostream>
#include<cstring>
using namespace std;

class Person{
    //必须声明为public，否则子类不可访问父类构造方法
    public:
    Person(string name):name(name),age(-1){};
    Person(string name,int age):name(name),age(age) {};

    void printInfo(){
        cout<<"Person :  ( name : "<<this->name<<" , age : "<<this->age<<" )"<<endl;
    }

    string getName(){
        return this->name;
    }

    int getAge(){
        return this->age;
    }

    private:
    string name;
    int age;
};

//默认class是 私有继承 class中的变量也是私有的
class Student:public Person {
    public:
    Student(string name,int age,double score):Person(name,age){
        this->score = score;
    };

    void printInfo(){
        cout<<"Student :  ( name : "<<this->getName()<<" , age : "<<this->getAge()<<" , score : "<<this->score<<" )"<<endl;
    }

    private:
    double score;
};

int main(int argc, char* argv[]){
    Student s("小明",10,98);
    s.printInfo();
}

