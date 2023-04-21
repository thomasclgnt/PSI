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
} 

// get qui retourne l'adresse de l'élément en argument
int get(char * name) {
    bool vide = false ;
    bool res = false ;
    int val_retour = -1 ;
    struct Symbol * stack_aux = stack ;
    
    // printf("** true while ? : %d\n", (!vide && !res)) ;

    while (!vide && !res){

        // printf("** true if stack not vide ? : %d\n", (stack != NULL)) ;
        if (stack->precedent != NULL){
            // // printf("%s, p = %d, add = %d\n", stack->id, stack->profondeur, stack->adresse) ;
            // printf("** id : %s\n", stack->id);
            // printf("** name : %s\n", name) ;

            // printf("** true if name ? : %d\n", (name == stack->id)) ;
            // printf("** true if name strcmp ? : %d\n", (strcmp(name, stack->id))) ;
            if (strcmp(name, stack->id) == 0) {
                res = true ;
                val_retour = stack->adresse ;
                // printf("** COPY SUCCESSFULL\n");
            }

            stack = stack->precedent ;
            // printf("** id prec : %s\n", stack->id);

        } else if (strcmp(name, stack->id) == 0) {
            // printf("** id : %s\n", stack->id);
            // printf("** name : %s\n", name) ;
            res = true ;
            val_retour = stack->adresse ;
            // printf("** COPY SUCCESSFULL\n");
        }else {
            // printf("%s, p = %d, add = %d\n", stack->id, stack->profondeur, stack->adresse) ;
            vide = true ;
        }
  }

  stack = stack_aux ;
  return val_retour ;
}

void print_stack(){
    bool vide = false ;
    while (!vide){
        if (stack->precedent != NULL){
            printf("%s, p = %d, add = %d\n", stack->id, stack->profondeur, stack->adresse) ;
            stack = stack->precedent ;
        } else {
            printf("%s, p = %d, add = %d\n", stack->id, stack->profondeur, stack->adresse) ;
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