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

void ajout_copy(int addr_res, int addr_op) {
    tab[index_asm][0] = 5;
    tab[index_asm][1] = addr_res;

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


// GEQ, SEQ ?

void ajout_jump(int num_instr){
    tab[index_asm][0] = 7;
    tab[index_asm][1] = num_instr;
    index_asm++;
    printf("JMP @cible:%d \n", num_instr) ;
}

void ajout_jumpf(int addr_test, int num_instr){
    tab[index_asm][0] = 8;
    tab[index_asm][1] = addr_test;
    tab[index_asm][2] = num_instr;
    index_asm++;
    // À FAIRE : gérer selon le retour du test, 0 ou 1, où est-ce qu'on saute
    printf("JMF @test:%d @cible:%d \n", addr_test, num_instr) ;
}

void patch_jmf(int index){
    tab[index][2] = index_asm ;
    printf("je patch [%d]JMF\n", index) ;
}

int get_index() {
    int res = index_asm -1 ;
    return res ;
}

void print_tab(){
    int row = 100 ;
    int col = 4 ;
    int leave = 1 ;
    int i = 0;

    while (leave && i<row) {
        if (tab[i][0] != 0) {
            for (int j = 0; j < col; j++) {
                printf("%d ", tab[i][j]);
            }
            printf("\n");
        } else {
            leave = 0 ;
        }
        i++ ;
    }
}

/*
int main() {
ajout_afc(0, 5) ;
ajout_afc(4, 5) ;
ajout_afc(8, 5) ;
ajout_afc(12, 5) ;
print_tab() ;

}
*/