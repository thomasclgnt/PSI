#include <stdio.h>
#include <stdlib.h>
#include "tablasm.h"

int tab[1024][4] ;
int index_asm = 0;

void ajout_exp_arith(int pcode, int addr_res, int addr_op1, int addr_op2){
    
    tab[index_asm][0] = pcode;
    tab[index_asm][1] = addr_res;
    tab[index_asm][2] = addr_op1;
    tab[index_asm][3] = addr_op2;
    index_asm++;

}

void ajout_copy(int addr_res, int addr_op) {
    tab[index_asm][0] = 5;
    tab[index_asm][1] = addr_res;
    tab[index_asm][2] = addr_op;
    index_asm++;
}

void ajout_afc(int addr_res, int val) {
    tab[index_asm][0] = 6;
    tab[index_asm][1] = addr_res;
    tab[index_asm][2] = val;
    index_asm++;
}