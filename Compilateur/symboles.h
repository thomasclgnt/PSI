#ifndef SYMBOLES_H
#define SYMBOLES_H

struct Symbol{ // structure
    char * id ;
    int type ;
    int profondeur ;
    int adresse ;
    struct Symbol * precedent;
};

extern int addr ;
extern int profondeur_globale ;
extern struct Symbol *stack ;

void push(char * id, int type, int profondeur) ;

void pop() ;

int get(char * name) ;

void print_stack();

#endif