%option noyywrap
%option noinput
%option nounput

%{
#include <stdio.h>
#include "bison.tab.h"
%}

/* definitions : name definition */

IDENTIFIERS     [a-zA-Z][a-zA-Z0-9_]*
INTEGERS        ([0-9]+[eE]([0-9]+|-[0-9+]))|[0]|[0-9]+|0x[0-9a-fA-F]+
COMMENTS        "//".*|("/*"([^*]|"**"[^*/])*)"*/"

/*rules : pattern action */
%%

"if"               { return(tIF); }
"else"             { return(tELSE); }
"while"            { return(tWHILE); }
"printf"           { return(tPRINT); }
"return"           { return(tRETURN); }
"int"              { return(tINT); }
"const"            { return(tCONST); }
"void"             { return(tVOID); }
"+"                { return(tADD); }
"-"                { return(tSUB); }
"*"                { return(tMUL); }
"/"                { return(tDIV); }
"<"                { return(tLT); }
">"                { return(tGT); }
"!="               { return(tNE); }
"=="               { return(tEQ); }
">="               { return(tGE); }
"<="               { return(tLE); }
"="                { return(tASSIGN); } // tAFFECTATION unknown
"&&"               { return(tAND); }
"||"               { return(tOR); }
"!"                { return(tNOT); }
"{"                { return(tLBRACE); }
"}"                { return(tRBRACE); }
"("                { return(tLPAR); } // tLPAREN unknown
")"                { return(tRPAR); } // tRPAREN unknown
";"                { return(tSEMI); }
","                { return(tCOMMA); }
{IDENTIFIERS}      { yylval.s = strdup(yytext); return tID; }   // traiter return() et main() différent
{INTEGERS}         { yylval.num = strtol(yytext, NULL, 0); return tNB; } // ATTENTION : comment on fait si exa ou expo
{COMMENTS}         /* ignore comments */
[ \n\t]            /* ignore return */
.                  { return(tERROR); } 
%%

/* user code int main(int argc, char **argv) {
    if (argc < 2) {
        printf("Usage: %s input_file\n", argv[0]);
        return 1;
    }
     
    input_file = fopen(argv[1], "r");
    if (input_file == NULL) {
        printf("Unable to open input file %s\n", argv[1]);
        return 2;
    }
    
    yyin = input_file;
    yylex();
    fclose(input_file);
    return 0;
}*/


