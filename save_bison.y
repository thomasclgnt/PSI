%{
#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
#include <string.h>
#include "symboles.h"
#include "tablasm.h"
#include "tablfunctions.h"
#include "interpreteur.h"
#include "cross-assembleur.h"

extern FILE* yyin ;
FILE* input_file ;
%}

%code provides {
  int yylex (void);
  void yyerror (const char *);
}
 
%union { 
  int num ;
  char *s ;
  int index ;
}

%type <index> index_jmf
%type <index> index_jmp
%type <index> tIF

%token tIF tELSE tWHILE tPRINT tRETURN tINT tVOID tCONST
%token tADD tSUB tMUL tDIV tLT tGT tNE tEQ tLE tGE tASSIGN tAND tOR tNOT 
%token tLBRACE tRBRACE tLPAR tRPAR tSEMI tCOMMA
%token tERROR
%token <s> tID
%token <num> tNB

%left tCOMMA
%left tADD tSUB
%left tMUL tDIV
%left tOR tAND tLT tGT tNE tEQ t tGE tLE

%start Init
 
%%
// REGLES DE GRAMMAIRE

Init : {init_instr();} Programme

Programme:
  %empty
  | Programme Function

Function:
  {printf ("VOID Function Start \n") ; } tVOID Declaration tLBRACE { printf("Profondeur : %d\n", profondeur_globale) ; } Statement {printf("\n 1 État de la pile : \n") ; print_stack() ; printf("\n") ; decrement_depth() ;} tRBRACE { 
                                                                      ajout_ret() ; decrement_depth(); printf ("VOID Function End \n") ;}
  |  {printf ("INT Function Start \n") ; } tINT Declaration tLBRACE { printf("Profondeur : %d\n", profondeur_globale) ; } Statement {printf("\n 1 État de la pile : \n") ; print_stack() ; printf("\n") ;} Return tSEMI  {decrement_depth() ;} tRBRACE { 
                                                                      decrement_depth() ; printf ("INT Function End \n") ;}                                 
;

Declaration:
  tID tLPAR {profondeur_globale += 1 ; printf("Profondeur : %d\n", profondeur_globale) ; printf("\n 1 État de la pile : \n") ; print_stack() ; printf("\n") ; printf("Nouvelle fonction : %s\n", $1) ;
            add_funct($1, get_index() + 1); // ajout de la fonction à la table
            push("?ADR", 1, profondeur_globale) ; // maj de la pile : ajout de la valeur et de l'addr de retour
            push("?VAL", 1, profondeur_globale) ;
            if (strcmp($1, "main") == 0){
                patch_jmp(0) ; // on patch le jump d'initialisation
            }                                       
            printf("Declaration \n") ;} Argument tRPAR { profondeur_globale += 1 ;}
;

Argument:
  %empty
  | tVOID                        {printf("Argument f Void \n") ;}
  | tINT tID                     {push($2, 1, profondeur_globale) ; printf("Argument f integer \n") ;}
  | tINT tID tCOMMA {push($2, 1, profondeur_globale) ;} Argument     {printf(",Argument f integer \n") ;}
;

Statement:
  %empty
  | tCONST tINT Initialisation tSEMI Statement                                                                {printf("Constant initialisation \n") ;}
  | tINT Initialisation tSEMI Statement        
  | Assignment tSEMI Statement                                                                        
  | Print Statement                                                        
  | While_l {printf("prof fin while = %d\n", profondeur_globale);}    Statement                          
  | If_condition {printf("prof fin if = %d\n", profondeur_globale);}  Statement
;

prof_p: %empty {profondeur_globale += 1 ; printf("prof if = %d\n", profondeur_globale); }

index_jmf: %empty {// midrule $$  
              // mettre instruction JMF @addr_cond -1(destinconnue ???) dans le tableau
              ajout_jumpf(addr -4, -2);
              // $$ = index
              $$ = get_index() ;
              // libérer dernière var temporaire
              pop() ;
              }
    

If_condition:
   prof_p tIF tLPAR Expression_Log tRPAR tLBRACE index_jmf Statement tRBRACE  { // patch la bonne addr_cible pour le JMF
                                                                                patch_jmf($7) ;
                                                                                printf("If \n") ; decrement_depth() ;}
  | prof_p  tIF tLPAR Expression_Log tRPAR tLBRACE index_jmf Statement tRBRACE { // jmp puis patch jmf ? 
                                                                                ajout_jump(-2) ;
                                                                                $2 = get_index() ; // on stocke l'index de l'instruction jump dans le tIF
                                                                                patch_jmf($7) ; } 
            tELSE tLBRACE Statement tRBRACE  { patch_jmp($2) ;
              printf("Bloc If Else \n") ; decrement_depth() ;} //a enlever si on implémente pas

;

index_jmp: %empty {$$ = get_index() ;}

While_l:

  {printf("while statement Start\n") ; profondeur_globale += 1 ;}
  tWHILE tLPAR Expression_Log tRPAR tLBRACE index_jmf index_jmp Statement {ajout_jump($8) ;} tRBRACE { patch_jmf($7) ; 
                                                                                                      decrement_depth() ; 
                                                                                                      printf("prof while = %d\n", profondeur_globale);
                                                                                                      printf("while statement End\n") ;} 
;

// fonction printf() ayant 1 seul paramètre : la variable dont la valeur doit être affichée
Print:
  tPRINT tLPAR tID tRPAR tSEMI { ajout_print(get($3)) ;}                                                               {printf("Print \n") ;}
;

// gérer la définition d'une constante


Assignment:
  tID tASSIGN Expression {ajout_copy(get($1), addr - 4) ; pop() ; printf("Assignement\n") ;} // mettre à jour la table des symboles
                              // afc ce qu'il y a à droite du égal, dans l'adresse de ID
;

Initialisation:
  tID                        {push($1, 1, profondeur_globale) ; printf("Tête : %s\n", stack->id) ; printf("Initialisation \n") ;}
  | tID                      {push($1, 1, profondeur_globale) ; printf("Tête : %s\n", stack->id) ;} tASSIGN Expression {ajout_copy(get($1), addr - 4) ; pop() ; 
                                                                                                    printf("Assignement\n") ;printf("Initialisation \n") ;}
  | Initialisation tCOMMA Initialisation                                                                  
;

Expression:
    tID   {printf("tempID is %s\n", $1) ; push("tempID", 1, profondeur_globale) ; //creer var tmp
          ajout_copy(addr - 4, get($1)) /* copier $1 dans cette var tm p ; 
          - addr = last adress used */ ; 
          printf("id \n") ;}
  | tNB   {printf("tempNB is %d\n", $1) ; push("tempNB", 1, profondeur_globale) ; //$$ creer var tmp  
          ajout_afc(addr - 4, $1) ; //ajout_affect $2 dans cette var tmp 
          }
  | tID tLPAR Parameter tRPAR                                                                                 {printf("Appel fonction avec parametre\n") ;}
  | tID tLPAR tRPAR                                                                                           {printf("Appel fonction sans paramètre \n") ;}
  | Expression tADD Expression  { /* instructer ADD last_add_used-1 last_add_used-1 last_add_used a
                                  jout_exp_arith(1, last_addr_used_moins_1, last_addr_used_moins_1, lat_addr_used); */ 
                                  ajout_exp_arith(1, addr - 8, addr - 8, addr - 4) ;
                                  pop() ; // liberer dervniere var tmp pop()}  printf("addition + \n") 
                                  printf("Tête : %s\n", stack->id) ;} 
  | Expression tSUB Expression  { ajout_exp_arith(3, addr - 8, addr - 8, addr - 4) ;
                                  pop() ; printf("soustraction - \n") ;}
  | Expression tMUL Expression  { ajout_exp_arith(2, addr - 8, addr - 8, addr - 4) ;
                                  pop() ; printf("multiplication * \n") ;}
  | Expression tDIV Expression  { ajout_exp_arith(4, addr - 8, addr - 8, addr - 4) ;
                                  pop() ; printf("division / \n") ;}
  | Expression tLT Expression   { ajout_exp_arith(9, addr - 8, addr - 8, addr - 4) ; pop() ; printf("condition < \n") ;}
  | Expression tLE Expression                                                                                 {pop() ; printf("condition <= \n") ;}  
  | Expression tGT Expression   { ajout_exp_arith(10, addr - 8, addr - 8, addr - 4) ; pop() ; printf("condition > \n") ;}
  | Expression tGE Expression                                                                                 {pop() ; printf("condition >= \n") ;}
  | Expression tEQ Expression   { ajout_exp_arith(11, addr - 8, addr - 8, addr - 4) ; pop() ; printf("égalité == \n") ;}
  | Expression tNE Expression                                                                                 {pop() ; printf("différence != \n") ;}    
;

Expression_Log:
  Expression                                                                                                  {printf("expression logique \n") ;}
  | Expression_Log tOR Expression_Log                                                                         {printf("or || \n") ;}
  | Expression_Log tAND Expression_Log                                                                        {printf("and && \n") ;}
;

Parameter:
  Expression                                                                                                  {printf("Parametre et valeur \n") ;}
  | Expression tCOMMA Parameter                                                                           
;

Return: // dans les deux cas, on copie le résultat de l'expression à l'emplacement réservé pour la valeur de return, on pop la variable tmp et on RET
  tRETURN tLPAR Expression tRPAR            { ajout_copy(get("?VAL"), addr - 4) ; pop () ; ajout_ret() ; printf("Return\n") ;} 
  | tRETURN Expression                      { ajout_copy(get("?VAL"), addr - 4) ; pop () ; ajout_ret() ; printf("Return\n") ;}
;

%%
/* EPILOGUE */
void yyerror(const char *msg) {
  fprintf(stderr, "**** ERROR ****: %s\n", msg);
  exit(1);
}

int main(void) {
  printf("---- MAIN ---- \n \n ");
  yyparse();
  printf("\n++++ SUCCESSFULLY PARSED ++++\n");

  printf("\n Fin : État de la pile : \n") ;
  print_stack() ;

  printf("\n Tableau d'instructions ASM : \n") ;
  print_tab() ;

  printf("\n Tableau des fonctions : \n") ;
  print_tabfunct();
  printf("\n") ;

  export_file() ;

  execute() ; // interpréteur

  execute_cross(); // cross-assembleur

}