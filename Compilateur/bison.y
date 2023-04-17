%{
#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
#include "symboles.h"
#include "tablasm.h"

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
}

%token tIF tELSE tWHILE tPRINT tRETURN tINT tVOID tCONST
%token tADD tSUB tMUL tDIV tLT tGT tNE tEQ tLE tGE tASSIGN tAND tOR tNOT 
%token tLBRACE tRBRACE tLPAR tRPAR tSEMI tCOMMA
%token tERROR
%token <s> tID
%token <num> tNB

%left tCOMMA
%left tOR tAND tLT tGT tNE tEQ t tGE tLE tADD tSUB tMUL tDIV


%start Programme
 
%%
// REGLES DE GRAMMAIRE

Programme:
  %empty
  | Programme Function

Function:
  {printf ("VOID Function Start \n") ;} tVOID Declaration tLBRACE Statement tRBRACE                           {printf ("VOID Function End \n") ;}
  |  {printf ("INT Function Start \n") ;} tINT Declaration tLBRACE Statement Return tSEMI tRBRACE             {printf ("INT Function End \n") ;}                                 
;

Declaration:
  tID tLPAR Argument tRPAR                                                                                    {printf("Declaration \n") ;}
;

Argument:
  tVOID                                                                                                       {printf("Argument f Void \n") ;}
  | tINT tID                                                                                                  {printf("Argument f integer \n") ;}
  | tINT tID tCOMMA Argument                                                                                  {printf(",Argument f integer \n") ;}
;

Statement:
  %empty
  | tCONST tINT Initialisation tSEMI Statement                                                                {printf("Constant initialisation \n") ;}
  | tINT Initialisation tSEMI Statement        
  | Assignment tSEMI Statement                                                                        
  | Print                                                         
  | While_l      {profondeur_globale -= 1 ; printf("prof fin while = %d\n", profondeur_globale);}                           
  | If_condition {profondeur_globale -= 1 ; printf("prof fin if = %d\n", profondeur_globale);}
;

prof_p: %empty {profondeur_globale += 1 ; printf("prof if = %d\n", profondeur_globale); }

If_condition:
   prof_p tIF tLPAR Expression_Log tRPAR tLBRACE Statement tRBRACE Statement  { printf("If \n") ;}
  | prof_p  tIF tLPAR Expression_Log tRPAR tLBRACE Statement tRBRACE tELSE tLBRACE Statement tRBRACE Statement        {printf("Bloc If Else \n") ;}
;

While_l:
  {printf("while statement Start\n") ;profondeur_globale += 1 ;} tWHILE tLPAR Expression_Log tRPAR tLBRACE Statement tRBRACE Statement { printf("prof while = %d\n", profondeur_globale);printf("while statement End\n") ;}
;

// fonction printf() ayant 1 seul paramètre : la variable dont la valeur doit être affichée
Print:
  tPRINT tLPAR tID tRPAR tSEMI Statement                                                               {printf("Print \n") ;}
;

// gérer la définition d'une constante

Assignment:
  tID tASSIGN Expression                                                                                      {printf("Assignement\n") ;} // mettre à jour la table des symboles
;

Initialisation:
  tID                        {push($1, 1, profondeur_globale) ; printf("Tête : %s\n", stack->id) ;}                                                                                 {printf("Initialisation \n") ;}
  | tID tASSIGN Expression   {push($1, 1, profondeur_globale) ; printf("Tête : %s\n", stack->id) ;}                                                                                {printf("Initialisation \n") ;}
  | Initialisation tCOMMA Initialisation                                                                  
;

Expression:
    tID   {push("", 1, profondeur_globale) ; //creer var tmp
          /* ajout_copy(last_addr_used,adresse de $1) (copier $1 dans cette var tm p ; */ }                                                                                                      {printf("id \n") ;}
  | tNB   { /* push("", 1, profondeur_globale) ; $$ creer var tmp  ; affect $2 dans cette var tmp ; ajout_afc(last_addr_used, $2) */ printf("nb \n") ;}
  | tID tLPAR Parameter tRPAR                                                                                 {printf("Appel fonction avec parametre\n") ;}
  | tID tLPAR tRPAR                                                                                           {printf("Appel fonction sans paramètre \n") ;}
  | Expression tADD Expression  { /* instructer ADD last_add_used-1 last_add_used-1 last_add_used ajout_exp_arith(1, last_addr_used_moins_1, last_addr_used, lat_addr_used_moins1); liberer dervniere var tmp pop()} */ printf("addition + \n") ;} 
  | Expression tSUB Expression                                                                                {printf("soustraction - \n") ;}
  | Expression tMUL Expression                                                                                {printf("multiplication * \n") ;}
  | Expression tDIV Expression                                                                                {printf("division / \n") ;}
  | Expression tLT Expression                                                                                 {printf("condition < \n") ;}
  | Expression tLE Expression                                                                                 {printf("condition <= \n") ;}  
  | Expression tGT Expression                                                                                 {printf("condition > \n") ;}
  | Expression tGE Expression                                                                                 {printf("condition >= \n") ;}
  | Expression tEQ Expression                                                                                 {printf("égalité == \n") ;}
  | Expression tNE Expression                                                                                 {printf("différence != \n") ;}    
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

Return:
  tRETURN tLPAR Expression tRPAR                                                                              {printf("Return\n") ;}
  | tRETURN Expression                                                                                        {printf("Return\n") ;}
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
  printf("État de la pile : \n") ;
  bool vide = false ;
  while (!vide){
    if (stack->precedent != NULL){
      printf("%s, p = %d\n", stack->id, stack->profondeur) ;
      stack = stack->precedent ;
    } else {
      printf("%s, p = %d\n", stack->id, stack->profondeur) ;
      vide = true ;
    }
  }
  
}