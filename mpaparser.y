%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
//#include "structures.h"

extern int line;
extern unsigned long col;
extern char* yytext;
void yyerror (char *s);

%}

%left OP2 
%left OP3 OR
%left OP4 AND
%left NOT

%token BEG  //equivalente a begin para evitar conflitos com o begin das macros
%token ASSIGN COLON COMMA DO  DOT END ELSE FORWARD FUNCTION IF LBRAC NOT OUTPUT PARAMSTR PROGRAM RBRAC
%token REPEAT SEMIC THEN UNTIL VAL VAR WHILE WRITELN AND OR OP2 OP3 OP4 RESERVED

%token <str> ID
%token <str> INTLIT 
%token <str> REALLIT 
%token <str> STRING 

%nonassoc THEN
%nonassoc ELSE

%union{
	char* str;
}
%%

Program   			: ProgHeading  ';'  ProgBlock  '.' 							
ProgHeading			: PROGRAM ID '(' OUTPUT ')'	
ProgBlock			: VarPart FuncPart StatPart
VarPart 			: VAR VarDeclaration ';' VarPart2
					|				
VarPart2 			: VarDeclaration ';' VarPart2
                    | 
VarDeclaration 		: IDList ':' ID
IDList 				: ID IDList2
IDList2 			: ',' ID IDList2
					|
FuncPart 			: FuncPart FuncDeclaration ';' 
					|			
FuncDeclaration 	: FuncHeading ';' FORWARD 
					| FuncIdent ';' FuncBlock 
					| FuncHeading ';' FuncBlock
FuncHeading 		: FUNCTION ID  ':' ID
					| FUNCTION ID FormalParamList ':' ID
FuncIdent 			: FUNCTION ID
FormalParamList 	: '(' FormalParams FormalParamListaux ')'
FormalParamListaux 	: ';' FormalParams FormalParamListaux
					|
FormalParams 		: IDList ':' ID
					| VAR IDList ':' ID
FuncBlock 			: VarPart StatPart
StatPart 			: CompStat
CompStat 			: BEG StatList END
StatList 			: Stat Stat2
Stat2 				: ';' Stat Stat2
					|
Stat  				: CompStat 
					| IF Expr THEN Stat 
					| IF Expr THEN Stat ELSE Stat
					| WHILE Expr DO Stat 
					| REPEAT StatList UNTIL Expr 
					| VAL '(' PARAMSTR '(' Expr ')' ',' ID ')' 
					| optStat2 
					| WRITELN 
					| WRITELN WritelnPList
optStat2 			: ID ASSIGN Expr
					|
WritelnPList 		: '(' optWritelnPList WritelnPList2 ')'
optWritelnPList 	: Expr
					| STRING
WritelnPList2 		: ',' optWritelnPList WritelnPList2
					|
Expr  				: Expr AND Expr
					| Expr OR Expr
					| Expr OP2 Expr
					| Expr OP3 Expr
					| Expr OP4 Expr
					| OP3 Expr
					| NOT Expr
					| '(' Expr ')' 
					| INTLIT
					| REALLIT
					| ID ParamList
					| ID
ParamList        	: '(' Expr repParamList ')'
repParamList 		: ',' Expr repParamList
					|




%%

void yyerror (char *s) {
     printf ("Line %d, col %d: %s: %s\n", line, (int)(col)-(int)strlen(yytext), s, yytext);

}

int main()
{
	yyparse();
	return 0;
}










