#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>

// https://www.keil.com/support/man/docs/armcc/armcc_chr1359124983511.htm

// visibility -> default, hidden, internal, protected
// used -> static

// extern "C" int32_t* solve(int32_t* list, int32_t listSize);

typedef struct FixedNumber{
    int32_t value;
    bool isFixed;
} fixedNumber;

typedef struct Number{
    int32_t value;
    int count=0;
} number;

bool backTracking(fixedNumber* fixedNumbers, int32_t listSize, int32_t index);

extern "C" __attribute__((visibility("default"))) __attribute__((used))
int32_t* solve(int32_t* list, int32_t listSize) {

    fixedNumber* fixedNumbers = (fixedNumber*)malloc(sizeof(fixedNumber)*listSize);

    for(int i=0;i<listSize;i++){
        (fixedNumbers+i)->isFixed = *(list+i) != 0;
        (fixedNumbers+i)->value = *(list+i);
    }

    int32_t index = 0;

    backTracking(fixedNumbers, listSize, index);

    for(int i=0;i<81;i++){
        *(list+i) = (fixedNumbers+i)->value;
    }

    free(fixedNumbers);

    return list;
}

bool backTracking(fixedNumber* fixedNumbers, int32_t listSize, int32_t index){

    if(index > 80){
        return true;
    }

    if((fixedNumbers+index)->isFixed || (fixedNumbers+index)->value != 0){
        return backTracking(fixedNumbers, listSize, index+1);
    }

    number* numbers = (number*)malloc(sizeof(number)*9);

    for(int i=0;i<9;i++){
        (numbers+i)->value = i+1;
        (numbers+i)->count = 0;
    }

    int32_t col = index % 9;
    int32_t row = index / 9;

    for(int k=1;k<10;k++){
        for(int i=0;i<9;i++){
            if(k == (fixedNumbers+i*9+col)->value){
                if((i*9+col) != index){
                    (numbers+k-1)->count++;
                }
            }
        }
    }

    for(int k=1;k<10;k++){
        for(int i=0;i<9;i++){
            if(k == (fixedNumbers+9*row+i)->value){
                if((row*9+i) != index){
                    (numbers+k-1)->count++;
                }
            }
        }
    }

    int q = row / 3;
    int w = col / 3;

    for(int k=1;k<10;k++){
        for(int j=3*q;j<3*(q+1);j++){
            for(int i=3*w;i<3*(w+1);i++){
                if(k == (fixedNumbers+9*j+i)->value){
                    if((j*9+i) != index){
                        (numbers+k-1)->count++;
                    }
                }
            }
        }
    }

    for(int i=0;i<9;i++){
        if((numbers+i)->count == 0){
            (fixedNumbers+index)->value = (numbers+i)->value;
            if(backTracking(fixedNumbers, listSize, index+1)){
                free(numbers);
                return true;
            }
            (fixedNumbers+index)->value = 0;
        }
    }

    free(numbers);

    return false;
}