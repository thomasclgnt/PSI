#include <stdio.h>
#include <stdlib.h>
#include <string.h>

char tabfunct[1024][2][256];
int index_funct = 0;

void add_funct(char * id, int addr_asm){
    printf("I am adding a function\n") ;
    strcpy(tabfunct[index_funct][0], id);
    sprintf(tabfunct[index_funct][1], "%d", addr_asm);
    index_funct ++ ;
}

int get_addr_funct(char * id) {
    
    for (int i = 0; i < index_funct; i++) {
        if (strcmp(tabfunct[i][0], id) == 0) {
            return atoi(tabfunct[i][1]);
        }
    }
    return -1; // Return -1 if the function is not found
}

void print_tabfunct(){
    for (int i = 0; i < index_funct; i++) {
        printf("%s %s\n", tabfunct[i][0], tabfunct[i][1]);
    }
}