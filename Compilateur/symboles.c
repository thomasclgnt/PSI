#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
#include <string.h>
#include "symboles.h"

// *stack : le contenu de ce sur quoi il pointe
// stack : adresse du pointeur
// &var : l'adresse où on a var

int addr = 0 ; 
int profondeur_globale = 0 ; // penser à faire fonction pour ajouter profondeur
struct Symbol * stack = NULL ; // on définit le pointeur stack vers notre structure Symbol


// insert
void push(char * id, int type, int profondeur){
    struct Symbol * new_symbol = malloc(sizeof* new_symbol);
    new_symbol->id = id ;
    new_symbol->type = type ;
    new_symbol->profondeur = profondeur ;
    new_symbol->adresse = addr ; // car on a que des int ici, 
    // sinon on adapte à la taille du type
    addr += 4 ;
    if (stack != NULL) {
        new_symbol->precedent = stack ;
        // faire bouger la stack ;
        stack = new_symbol ;
    } else {
        new_symbol->precedent = NULL ;
        // faire bouger la stack ;
        stack = new_symbol ;
    }

    // si le nom de variable existe déjà, 
    // il faut pas l'ajouter mais déclarer une erreur 

    printf("Je push : %s\n",new_symbol->id) ;

} 

// delete
void pop(){
    printf("Je pop : %s\n", stack->id) ;
    struct Symbol * depile = stack;
    stack = stack->precedent ;
    free(depile) ;
    addr -= 4 ;
    printf("Pop successful\n") ;
} 

void decrement_depth(){
    int prof_aux = stack->profondeur ;
    profondeur_globale -= 1 ;

    // pop dans la pile jusqu'à ce que prof du truc actuellement pointé soit = nouvelle profondeur
    while(prof_aux > profondeur_globale){
        pop() ;
        printf("Pop decrease\n") ;
        if (stack != NULL) {
            prof_aux = stack->profondeur;
            printf("stack ok\n") ;
        } else {
            printf("argh jsp\n") ;
            prof_aux = profondeur_globale ;
        }
    }
    
}

// get qui retourne l'adresse de l'élément en argument
int get(char * name) {
    bool vide = false ;
    bool res = false ;
    int val_retour = -1 ;
    struct Symbol * stack_aux = stack ;

    while (!vide && !res){
        if (stack->precedent != NULL){
            if (strcmp(name, stack->id) == 0) {
                res = true ;
                val_retour = stack->adresse ;
            }
            stack = stack->precedent ;
        } else if (strcmp(name, stack->id) == 0) {
            res = true ;
            val_retour = stack->adresse ;
        }else {
            vide = true ;
        }
    }

  stack = stack_aux ;
  return val_retour ;
}

void print_stack(){
    bool vide = false ;
    while (!vide){
        if (stack != NULL) {
            if (stack->precedent != NULL){
            printf("%s, p = %d, add = %d\n", stack->id, stack->profondeur, stack->adresse) ;
            stack = stack->precedent ;
            } else {
                printf("%s, p = %d, add = %d\n", stack->id, stack->profondeur, stack->adresse) ;
                vide = true ;
            }
        } else {
            printf("La pile est vide \n");
            vide = true ;
        }
        
    }
}


/*
int main(){
    
    push("thomas", 1, 0) ;

    printf("haut de la pile : %s\n", stack->id);
    
    push("marie", 1, 2) ;
    
    printf("haut de la pile : %s\n", stack->id);

    push("dylan", 0, 1) ;

    printf("haut de la pile : %s\n", stack->id);

    pop() ; 

    printf("haut de la pile : %s\n", stack->id);

    printf("0 addr get : %d\n", get("thomas")) ;    
    
    printf("4 addr get : %d\n", get("marie")) ;

    printf("-1 addr get : %d\n", get("dylan")) ;
}
*/