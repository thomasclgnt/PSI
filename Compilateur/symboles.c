#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>

// *stack : le contenu de ce sur quoi il pointe
// stack : adresse du pointeur
// &var : l'adresse où on a var

struct Symbol{ // structure
    char * id ;
    int type ;
    int profondeur ;
    int adresse ;
    struct Symbol * precedent;
};


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
} 

// get

int main(){
    
    push("thomas", 1, 0) ;

    printf("haut de la pile : %s\n", stack->id);

    push("marie", 1, 2) ;

    printf("haut de la pile : %s\n", stack->id);

    push("dylan", 0, 1) ;

    printf("haut de la pile : %s\n", stack->id);

    pop() ; 

    printf("haut de la pile : %s\n", stack->id);

    
}


