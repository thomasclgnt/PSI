/* A Bison parser, made by GNU Bison 3.5.1.  */

/* Bison interface for Yacc-like parsers in C

   Copyright (C) 1984, 1989-1990, 2000-2015, 2018-2020 Free Software Foundation,
   Inc.

   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <http://www.gnu.org/licenses/>.  */

/* As a special exception, you may create a larger work that contains
   part or all of the Bison parser skeleton and distribute that work
   under terms of your choice, so long as that work isn't itself a
   parser generator using the skeleton or a modified version thereof
   as a parser skeleton.  Alternatively, if you modify or redistribute
   the parser skeleton itself, you may (at your option) remove this
   special exception, which will cause the skeleton and the resulting
   Bison output files to be licensed under the GNU General Public
   License without this special exception.

   This special exception was added by the Free Software Foundation in
   version 2.2 of Bison.  */

/* Undocumented macros, especially those whose name start with YY_,
   are private implementation details.  Do not rely on them.  */

#ifndef YY_YY_BISON_TAB_H_INCLUDED
# define YY_YY_BISON_TAB_H_INCLUDED
/* Debug traces.  */
#ifndef YYDEBUG
# define YYDEBUG 1
#endif
#if YYDEBUG
extern int yydebug;
#endif

/* Token type.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
  enum yytokentype
  {
    tIF = 258,
    tELSE = 259,
    tWHILE = 260,
    tPRINT = 261,
    tRETURN = 262,
    tINT = 263,
    tVOID = 264,
    tCONST = 265,
    tADD = 266,
    tSUB = 267,
    tMUL = 268,
    tDIV = 269,
    tLT = 270,
    tGT = 271,
    tNE = 272,
    tEQ = 273,
    tLE = 274,
    tGE = 275,
    tASSIGN = 276,
    tAND = 277,
    tOR = 278,
    tNOT = 279,
    tLBRACE = 280,
    tRBRACE = 281,
    tLPAR = 282,
    tRPAR = 283,
    tSEMI = 284,
    tCOMMA = 285,
    tERROR = 286,
    tID = 287,
    tNB = 288,
    t = 289
  };
#endif

/* Value type.  */
#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
union YYSTYPE
{
#line 14 "bison.y"
 
  int num ;
  char *s ;

#line 97 "bison.tab.h"

};
typedef union YYSTYPE YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define YYSTYPE_IS_DECLARED 1
#endif


extern YYSTYPE yylval;

int yyparse (void);
/* "%code provides" blocks.  */
#line 9 "bison.y"

  int yylex (void);
  void yyerror (const char *);

#line 115 "bison.tab.h"

#endif /* !YY_YY_BISON_TAB_H_INCLUDED  */
