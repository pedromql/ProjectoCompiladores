%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "structures.h"

extern int line;
extern unsigned long col;
extern char* yytext;
void yyerror (char *s);

Node * tmp;
Node * root;
char * aux;


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
	struct _node * node;
}

%type <node> Program ProgHeading ProgBlock VarPart VarPart2 VarDeclaration IDList IDList2 FuncPart FuncDeclaration FuncHeading FuncIdent FormalParamList FormalParamListaux FormalParams FuncBlock StatPart CompStat StatList Stat2 Stat optStat2 WritelnPList optWritelnPList WritelnPList2 Expr SimpleExpression Term Factor ParamList repParamList
%%


Program   			: ProgHeading  ';'  ProgBlock  '.' 		{root=make_node("Program",NULL,$1); $1->brother=$3;};							
ProgHeading			: PROGRAM ID '(' OUTPUT ')'				{aux = (char*)malloc(5+strlen($2)*sizeof(char)); sprintf(aux,"Id(%s)",$2); $$ = make_node(aux,NULL,NULL);};
ProgBlock			: VarPart FuncPart StatPart				{$$ = $1; $1->brother = $2; $2->brother = $3;};
VarPart 			: VAR VarDeclaration ';' VarPart2		{$$ = make_node("VarPart",NULL,$2); $2->brother = $4;};
					|										{$$ = make_node("VarPart",NULL,NULL);};
VarPart2 			: VarDeclaration ';' VarPart2			{$$ = $1; $1->brother = $3;};
					| 										{$$ = NULL;};
VarDeclaration 		: IDList ':' ID 						{$$ = make_node("VarDecl",NULL,NULL); aux = (char*)malloc(5+strlen($3)*sizeof(char)); sprintf(aux,"Id(%s)",$3); addBrother($1,make_node(aux,NULL,NULL)); addChild($$,$1);};
IDList 				: ID IDList2							{aux = (char*)malloc(5+strlen($1)*sizeof(char)); sprintf(aux,"Id(%s)",$1); $$ = make_node(aux,NULL,NULL); addBrother($$,$2);};
IDList2 			: ',' ID IDList2						{aux = (char*)malloc(5+strlen($2)*sizeof(char)); sprintf(aux,"Id(%s)",$2); $$ = make_node(aux,NULL,NULL); addBrother($$,$3);};
					| 										{ $$ = NULL;};		
FuncPart 			: FuncPart FuncDeclaration ';' 
					|										{ $$ = NULL;};		
FuncDeclaration 	: FuncHeading ';' FORWARD 				{ $$ = NULL;};
					| FuncIdent ';' FuncBlock 				{ $$ = NULL;};
					| FuncHeading ';' FuncBlock				{ $$ = NULL;};
FuncHeading 		: FUNCTION ID  ':' ID 					{ $$ = NULL;};
					| FUNCTION ID FormalParamList ':' ID 	{ $$ = NULL;};
FuncIdent 			: FUNCTION ID 							{ $$ = NULL;};
FormalParamList 	: '(' FormalParams FormalParamListaux ')' { $$ = NULL;};
FormalParamListaux 	: ';' FormalParams FormalParamListaux 	{ $$ = NULL;};
					|										{ $$ = NULL;};		
FormalParams 		: IDList ':' ID 						{ $$ = NULL;};
					| VAR IDList ':' ID 					{ $$ = NULL;};
FuncBlock 			: VarPart StatPart 						{ $$ = NULL;};
StatPart 			: CompStat								{ $$ = NULL;};
CompStat 			: BEG StatList END						{ $$ = NULL;};
StatList 			: Stat Stat2							{ $$ = NULL;};
Stat2 				: ';' Stat Stat2						{ $$ = NULL;};
					|										{ $$ = NULL;};		

Stat  				: CompStat 											{ $$ = $1;};
					| IF Expr THEN Stat 								{ $$ = NULL;};
					| IF Expr THEN Stat ELSE Stat 						{ $$ = NULL;};
					| WHILE Expr DO Stat 								{ $$ = NULL;};
					| REPEAT StatList UNTIL Expr 						{ $$ = NULL;};
					| VAL '(' PARAMSTR '(' Expr ')' ',' ID ')' 			{ $$ = NULL;};




					| optStat2 								{ $$ = $1;};
					| WRITELN 								{ $$ = make_node("WriteLn",NULL,NULL);};
					| WRITELN WritelnPList 					{ $$ = make_node("WriteLn",$2,NULL); };

optStat2 			: ID ASSIGN Expr 						{ aux = (char*)malloc(5+strlen($1)*sizeof(char)); sprintf(aux,"Id(%s)",$1); tmp = make_node(aux,NULL,$3); $$ = make_node("Assign",tmp,NULL);};
					|										{ $$ = NULL;};

WritelnPList 		: '(' optWritelnPList WritelnPList2 ')' { $$ = $2; $2->brother=$3;};

optWritelnPList 	: Expr 									{ $$ = $1;};
					| STRING 								{ aux = (char*)malloc(9+strlen($1)*sizeof(char)); sprintf(aux,"String(%s)",$1); tmp = make_node(aux,NULL,NULL); $$ = make_node("String",NULL,tmp);};

WritelnPList2 		: ',' optWritelnPList WritelnPList2 	{ $$ = $2; $2->brother=$3;};
					|										{ $$ = NULL;};

Expr  				: SimpleExpression 						{ $$ = $1;};
					| SimpleExpression '=' SimpleExpression { $$ = make_node("Eq",NULL,$1); addBrother($1,$3);};
					| SimpleExpression '>' SimpleExpression { $$ = make_node("Gt",NULL,$1); addBrother($1,$3);};
					| SimpleExpression '<' SimpleExpression { $$ = make_node("Lt",NULL,$1); addBrother($1,$3);};
					| SimpleExpression LEQ SimpleExpression { $$ = make_node("Leq",NULL,$1); addBrother($1,$3);};
					| SimpleExpression NEQ SimpleExpression { $$ = make_node("Neq",NULL,$1); addBrother($1,$3);};
					| SimpleExpression GEQ SimpleExpression	{ $$ = make_node("Geq",NULL,$1); addBrother($1,$3);};

SimpleExpression 	: '+' Term 								{ $$ = make_node("Plus",NULL,$2);};
					| '-' Term 								{ $$ = make_node("Minus",NULL,$2);};
					| Term 									{ $$ = $1;};
					| SimpleExpression '+' Term 			{ $$ = make_node("Add",NULL,$1); addBrother($1,$3);};
					| SimpleExpression '-' Term 			{ $$ = make_node("Sub",NULL,$1); addBrother($1,$3);};
					| SimpleExpression OR Term 				{ $$ = make_node("Or",NULL,$1); addBrother($1,$3);};

Term				: Term AND Factor 						{ $$ = make_node("And",NULL,$1); $1->brother=$3;};
					| Term MOD Factor 						{ $$ = make_node("Mod",NULL,$1); $1->brother=$3;};
					| Term DIV Factor 						{ $$ = make_node("Div",NULL,$1); $1->brother=$3;};
					| Term '*' Factor 						{ $$ = make_node("Mul",NULL,$1); $1->brother=$3;};
					| Term '/' Factor 						{ $$ = make_node("RealDiv",NULL,$1); $1->brother=$3;};
					| Factor 								{ $$ = $1;};

Factor				: NOT Factor 							{ $$ = make_node("Not", $2,NULL);};
					| '(' Expr ')' 							{ $$ = $2;};
					| INTLIT 								{ aux = (char*)malloc(9+strlen($1)*sizeof(char)); sprintf(aux,"IntLit(%s)",$1); tmp = make_node(aux,NULL,NULL); $$ = make_node("IntLit",NULL,tmp);};
					| REALLIT 								{ aux = (char*)malloc(10+strlen($1)*sizeof(char)); sprintf(aux,"RealLit(%s)",$1); tmp = make_node(aux,NULL,NULL); $$ = make_node("RealLit",NULL,tmp);};
					| ID ParamList 							{ aux = (char*)malloc(5+strlen($1)*sizeof(char)); sprintf(aux,"Id(%s)",$1); $$ = make_node(aux, NULL,$2);};
					| ID 									{ aux = (char*)malloc(5+strlen($1)*sizeof(char)); sprintf(aux,"Id(%s)",$1); tmp = make_node(aux,NULL,NULL); $$ = make_node("Id",NULL,tmp);};

ParamList        	: '(' Expr repParamList ')'				{ $2->brother = $3; $$ = $2;};

repParamList 		: ',' Expr repParamList 				{ $2->brother = $3; $$ = $2;};
					|										{ $$ = NULL;};




%%

void yyerror (char *s) {
	 printf ("Line %d, col %d: %s: %s\n", line, (int)(col)-(int)strlen(yytext), s, yytext);
}

int main()
{
    printf("txua");
	yyparse();
	printAll(root);
	return 0;
}









