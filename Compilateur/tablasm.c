#include <stdio.h>
#include <stdlib.h>
#include "tablasm.h"
#include "symboles.h"

// actions : valeurs
/*
1 add
2 mul
3 sub
4 div
5 : copy
6 : AFC
7 : JUMP
8 : JUMPF
9 : inf
10 : sup
11 : equ
12 : pri
13 : load
14 : store
15 : GEQ
16 : SEQ
17 : RET
18 : PUSH
19 : CALL
20 : POP
21 : NEQ
*/

// GEQ, SEQ ? IF ELSE ?

int tab[1024][4] ;
int index_asm = 1 ;

void init_instr() {
    // on initialise la table d'instrcutions avec un jump à la fonction main
    tab[0][0] = 7;
    tab[0][1] = -2; // penser à patch ce jump
    tab[0][2] = -1;
    tab[0][3] = -1;
}

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
    tab[index_asm][2] = -1;
    tab[index_asm][3] = -1;

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
    tab[index_asm][3] = -1;
    index_asm++;
    printf("AFC @res:%d val:%d\n", addr_res, val) ;
}

void ajout_jump(int num_instr){
    tab[index_asm][0] = 7;
    tab[index_asm][1] = num_instr;
    tab[index_asm][2] = -1;
    tab[index_asm][3] = -1;
    index_asm++;
    printf("JMP @cible:%d \n", num_instr) ;
}

void ajout_jumpf(int addr_test, int num_instr){
    tab[index_asm][0] = 8;
    tab[index_asm][1] = addr_test;
    tab[index_asm][2] = num_instr;
    tab[index_asm][3] = -1;
    index_asm++;
    // À FAIRE : gérer selon le retour du test, 0 ou 1, où est-ce qu'on saute
    printf("JMF @test:%d @cible:%d \n", addr_test, num_instr) ;
}

void ajout_print(int addr_res){
    tab[index_asm][0] = 12;
    tab[index_asm][1] = addr_res;
    tab[index_asm][2] = -1;
    tab[index_asm][3] = -1;
    printf("PRI @var:%d \n", addr_res) ;
    index_asm++;
}

void ajout_ret(){
    tab[index_asm][0] = 17;
    tab[index_asm][1] = -1;
    tab[index_asm][2] = -1;
    tab[index_asm][3] = -1;
    printf("RET\n") ;
    index_asm++;
}

void ajout_push(int stack_size){
    tab[index_asm][0] = 18;
    tab[index_asm][1] = stack_size;
    tab[index_asm][2] = -1;
    tab[index_asm][3] = -1;
    printf("PUSH %d\n", stack_size) ;
    index_asm++;
}

void ajout_call(int addr_funct){
    tab[index_asm][0] = 19;
    tab[index_asm][1] = addr_funct;
    tab[index_asm][2] = -1;
    tab[index_asm][3] = -1;
    printf("CALL @%d\n", addr_funct) ;
    index_asm++;
}

void ajout_pop(int stack_size){
    tab[index_asm][0] = 20;
    tab[index_asm][1] = stack_size;
    tab[index_asm][2] = -1;
    tab[index_asm][3] = -1;
    printf("POP %d\n", stack_size) ;
    index_asm++;
}

void patch_jmf(int index){
    tab[index][2] = index_asm ;
    printf("je patch [%d]JMF\n", index) ;
}

void patch_jmp(int index){
    tab[index][1] = index_asm ;
    printf("je patch [%d]JMP\n", index) ;
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
            for (int j = 0; j < col; j++) {
                printf("%d ", tab[i][j]);
            }
            printf("\n");
            leave = 0 ;
        }
        i++ ;
    }
}

void export_file(){

    FILE * file ;
    file = fopen("instructions.txt", "w") ;
    int row = 1024 ;
    int col = 4 ;
    int leave = 1 ;
    int i = 0;
    
    // parcourir le tableau et rentrer chaque instruction dans le fichier

    while (leave && i<row) {
        if (tab[i][0] != 0) {
            for (int j = 0; j < col; j++) {
                fprintf(file, "%d ", tab[i][j]);
            }
            fprintf(file, "\n");
        } else {
            for (int j = 0; j < col; j++) {
                fprintf(file, "%d ", tab[i][j]);
            }
            fprintf(file, "\n");
            leave = 0 ;
        }
        i++ ;
    }

    fclose(file);

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