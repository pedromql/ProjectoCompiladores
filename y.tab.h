/* A Bison parser, made by GNU Bison 2.3.  */

/* Skeleton interface for Bison's Yacc-like parsers in C

   Copyright (C) 1984, 1989, 1990, 2000, 2001, 2002, 2003, 2004, 2005, 2006
   Free Software Foundation, Inc.

   This program is free software; you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation; either version 2, or (at your option)
   any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program; if not, write to the Free Software
   Foundation, Inc., 51 Franklin Street, Fifth Floor,
   Boston, MA 02110-1301, USA.  */

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

/* Tokens.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
   /* Put the tokens into the symbol table, so that GDB and other debuggers
      know about them.  */
   enum yytokentype {
     OR = 258,
     OP3 = 259,
     AND = 260,
     OP4 = 261,
     NOT = 262,
     BEG = 263,
     ASSIGN = 264,
     COLON = 265,
     COMMA = 266,
     DO = 267,
     DOT = 268,
     END = 269,
     ELSE = 270,
     FORWARD = 271,
     FUNCTION = 272,
     IF = 273,
     LBRAC = 274,
     OUTPUT = 275,
     PARAMSTR = 276,
     PROGRAM = 277,
     RBRAC = 278,
     REPEAT = 279,
     SEMIC = 280,
     THEN = 281,
     UNTIL = 282,
     VAL = 283,
     VAR = 284,
     WHILE = 285,
     WRITELN = 286,
     OP2 = 287,
     RESERVED = 288,
     ID = 289,
     INTLIT = 290,
     REALLIT = 291,
     STRING = 292
   };
#endif
/* Tokens.  */
#define OR 258
#define OP3 259
#define AND 260
#define OP4 261
#define NOT 262
#define BEG 263
#define ASSIGN 264
#define COLON 265
#define COMMA 266
#define DO 267
#define DOT 268
#define END 269
#define ELSE 270
#define FORWARD 271
#define FUNCTION 272
#define IF 273
#define LBRAC 274
#define OUTPUT 275
#define PARAMSTR 276
#define PROGRAM 277
#define RBRAC 278
#define REPEAT 279
#define SEMIC 280
#define THEN 281
#define UNTIL 282
#define VAL 283
#define VAR 284
#define WHILE 285
#define WRITELN 286
#define OP2 287
#define RESERVED 288
#define ID 289
#define INTLIT 290
#define REALLIT 291
#define STRING 292




#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
typedef union YYSTYPE
#line 33 "mpaparser.y"
{
	char* str;
}
/* Line 1529 of yacc.c.  */
#line 127 "y.tab.h"
	YYSTYPE;
# define yystype YYSTYPE /* obsolescent; will be withdrawn */
# define YYSTYPE_IS_DECLARED 1
# define YYSTYPE_IS_TRIVIAL 1
#endif

extern YYSTYPE yylval;

