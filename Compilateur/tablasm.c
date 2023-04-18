#include <stdio.h>
#include <stdlib.h>
#include "tablasm.h"
#include "symboles.h"

int tab[1024][4] ;
int index_asm = 0;

void ajout_exp_arith(int pcode, int addr_res, int addr_op1, int addr_op2){
    
    tab[index_asm][0] = pcode;
    tab[index_asm][1] = addr_res;
    tab[index_asm][2] = addr_op1;
    tab[index_asm][3] = addr_op2;
    index_asm++;

}

void ajout_copy(int addr_res, char * name) {
    tab[index_asm][0] = 5;
    tab[index_asm][1] = addr_res;
    // retrouver addr_op dans la pile
    int addr_op = get(name) ;
    printf("GET NAME OK\n") ;
    if (addr_op != -1) {
        tab[index_asm][2] = addr_op;
        index_asm++;
        printf("COP @res:%d @op:%d\n", addr_res, addr_op) ;
    } else {
        printf("ERREUR COPIE, L'élément n'est pas dans la pile\n") ;
    }
}

void ajout_afc(int addr_res, int val) {
    tab[index_asm][0] = 6;
    tab[index_asm][1] = addr_res;
    tab[index_asm][2] = val;
    index_asm++;
    printf("AFC @res:%d val:%d\n", addr_res, val) ;
}