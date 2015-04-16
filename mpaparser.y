%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
//#include "structures.h"

extern int line;
extern unsigned long col;
extern char* yytext;
void yyerror (char *s);

//Node root = malloc((Node)*sizeof(int))

%}

%left OR AND NOT

%token BEG  //equivalente a begin para evitar conflitos com o begin das macros
%token ASSIGN COLON COMMA DO  DOT END ELSE FORWARD FUNCTION IF LBRAC NOT OUTPUT PARAMSTR PROGRAM RBRAC
%token REPEAT SEMIC THEN UNTIL VAL VAR WHILE WRITELN AND OR  RESERVED 
%token LEQ GEQ NEQ MOD DIV

%token <str> ID
%token <str> INTLIT 
%token <str> REALLIT 
%token <str> STRING 

%nonassoc THEN
%nonassoc ELSE
%nonassoc '<' '>' '='
%nonassoc LEQ NEQ GEQ

%union{
	char* str;
}
%%

Program   			: ProgHeading  ';'  ProgBlock  '.' 		{root=make_node("Program",NULL,$1); $1->brother=$3;}								
ProgHeading			: PROGRAM ID '(' OUTPUT ')'				{$$=}
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
Expr  				: SimpleExpression
					| SimpleExpression '=' SimpleExpression
					| SimpleExpression '>' SimpleExpression
					| SimpleExpression '<' SimpleExpression
					| SimpleExpression LEQ	SimpleExpression
					| SimpleExpression NEQ SimpleExpression
					| SimpleExpression GEQ SimpleExpression				
SimpleExpression 	: '+' Term
					| '-' Term
					| Term
					| SimpleExpression '+' Term
					| SimpleExpression '-' Term
					| SimpleExpression OR Term
Term				: Term AND Factor
					| Term MOD Factor 
					| Term DIV Factor 
					| Term '*' Factor 
					| Term '/' Factor 
					| Factor
Factor				: NOT Factor
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









