#include <stdio.h>
#include <stdlib.h>

char tabfunct[1024][2] ;
int index = 0;

void add_funct(char * id, int addr_asm){
    strcpy(tabfunct[index][0], id);
    sprintf(tabfunct[index][1], "%d", addr_asm);
    index ++ ;
}

int get_addr_funct(char * id) {
    for (int i = 0; i < index; i++) {
        if (strcmp(tabfunct[i][0], id) == 0) {
            return atoi(tabfunct[i][1]);
        }
    }
    return -1; // Return -1 if the function is not found
}

void print_tab(){
    for (int i = 0; i < index; i++) {
        printf("%s %s\n", tabfunct[i][0], tabfunct[i][1]);
    }
}