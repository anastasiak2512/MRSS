//
// Created by AK on 15/07/15.
// Copyright (c) 2015 JetBrains. All rights reserved.
//

#ifndef MOBIUSRSS_HUMAN_H
#define MOBIUSRSS_HUMAN_H

class Mammal {
    virtual void measure() = 0;
};

class Human : public Mammal {
private:
    float weight;
    float height;
    int age;

public:
    Human (int weight, int height) : weight(weight), height(height) {
    }

    virtual void measure () override {

    }
};


#endif //MOBIUSRSS_HUMAN_H














