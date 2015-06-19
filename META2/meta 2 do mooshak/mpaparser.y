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
Node * tmp2;
Node * root;
char * aux;
char * aux2;

//falta alocar espaço para as variáveis
char * name_var;
char * name_var2;


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
	int u_line,u_col;
	struct _node * node;
}

%type <node> Program ProgHeading ProgBlock VarPart VarPart2 VarDeclaration IDList IDList2 FuncPart FuncDeclaration FuncHeading FuncIdent FormalParamList FormalParamListaux FormalParams FuncBlock StatPart CompStat StatList Stat2 Stat optStat2 WritelnPList optWritelnPList WritelnPList2 Expr SimpleExpression Term Factor ParamList repParamList
%%


Program   			: ProgHeading  ';'  ProgBlock  '.' 		{root=make_node("Program",NULL,NULL,$1,NULL); addBrother($1,$3);};

ProgHeading			: PROGRAM ID '(' OUTPUT ')'				{name_var=(char*)malloc(strlen($2)*sizeof(char));   strcpy(name_var,$2); aux = (char*)malloc(5+strlen($2)*sizeof(char)); sprintf(aux,"Id(%s)",$2); $$ = make_node(aux,"Id",name_var,NULL,NULL);};

ProgBlock			: VarPart FuncPart StatPart				{$$ = $1; tmp = make_node("FuncPart",NULL,NULL,$2,NULL); addBrother(tmp,$3); addBrother($1,tmp);};

VarPart 			: VAR VarDeclaration ';' VarPart2		{$$ = make_node("VarPart",NULL,NULL,$2,NULL); addBrother($2,$4);};
					|										{$$ = make_node("VarPart",NULL,NULL,NULL,NULL);};

VarPart2 			: VarDeclaration ';' VarPart2			{$$ = $1; addBrother($1,$3);};
					| 										{$$ = NULL;};

VarDeclaration 		: IDList ':' ID 						{name_var=(char*)malloc(strlen($3)*sizeof(char));   strcpy(name_var,$3);   aux = (char*)malloc(5+strlen($3)*sizeof(char)); sprintf(aux,"Id(%s)",$3); addBrother($1,make_node(aux,"Id",name_var,NULL,NULL)); $$ = make_node("VarDecl",NULL,NULL,$1,NULL);};

IDList 				: ID IDList2							{name_var=(char*)malloc(strlen($1)*sizeof(char));   strcpy(name_var,$1);   aux = (char*)malloc(5+strlen($1)*sizeof(char)); sprintf(aux,"Id(%s)",$1); $$ = make_node(aux,"Id",name_var,NULL,$2);};

IDList2 			: ',' ID IDList2						{name_var=(char*)malloc(strlen($2)*sizeof(char));   strcpy(name_var,$2);   aux = (char*)malloc(5+strlen($2)*sizeof(char)); sprintf(aux,"Id(%s)",$2); $$ = make_node(aux,"Id",name_var,NULL,$3);};
					| 										{$$ = NULL;};

FuncPart 			: FuncDeclaration ';' FuncPart 			{addBrother($1,$3); $$ = $1;};
					|										{$$ = NULL;};	

FuncDeclaration 	: FuncHeading ';' FORWARD 				{$$ = make_node("FuncDecl",NULL,NULL,$1,NULL);};
					| FuncIdent ';' FuncBlock 				{addBrother($1,$3); $$ = make_node("FuncDef2",NULL,NULL,$1,NULL);};
					| FuncHeading ';' FuncBlock				{addBrother($1,$3); $$ = make_node("FuncDef",NULL,NULL,$1,NULL);};

FuncHeading 		: FUNCTION ID ':' ID 					{name_var=(char*)malloc(strlen($2)*sizeof(char));   strcpy(name_var,$2);   name_var2=(char*)malloc(strlen($4)*sizeof(char));   strcpy(name_var2,$4);   aux = (char*)malloc(5+strlen($2)*sizeof(char)); sprintf(aux,"Id(%s)",$2); aux2 = (char*)malloc(5+strlen($4)*sizeof(char)); sprintf(aux2,"Id(%s)",$4); tmp = make_node(aux,"Id",name_var,NULL,make_node("FuncParams",NULL,NULL,NULL,NULL)); addBrother(tmp,make_node(aux2,"Id",name_var2,NULL,NULL)); $$ = tmp;};
					| FUNCTION ID FormalParamList ':' ID 	{name_var=(char*)malloc(strlen($2)*sizeof(char));   strcpy(name_var,$2);   name_var2=(char*)malloc(strlen($5)*sizeof(char));   strcpy(name_var2,$5);  aux = (char*)malloc(5+strlen($2)*sizeof(char)); sprintf(aux,"Id(%s)",$2); aux2 = (char*)malloc(5+strlen($5)*sizeof(char)); sprintf(aux2,"Id(%s)",$5); tmp = make_node(aux,"Id",name_var,NULL,NULL); if ($3 == NULL) {$3=make_node("FuncParams",NULL,NULL,NULL,NULL);} addBrother(tmp,$3); addBrother($3,make_node(aux2,"Id",name_var2,NULL,NULL)); $$ = tmp;};

FuncIdent 			: FUNCTION ID 							{name_var=(char*)malloc(strlen($2)*sizeof(char));   strcpy(name_var,$2); aux = (char*)malloc(5+strlen($2)*sizeof(char)); sprintf(aux,"Id(%s)",$2); $$ = make_node(aux,"Id",name_var,NULL,NULL);};

FormalParamList 	: '(' FormalParams FormalParamListaux ')' {addBrother($2,$3); $$ = make_node("FuncParams",NULL,NULL,$2,NULL);};

FormalParamListaux 	: ';' FormalParams FormalParamListaux 	{addBrother($2,$3); $$ = $2;};
					|										{$$ = NULL;};

FormalParams 		: IDList ':' ID 						{name_var=(char*)malloc(strlen($3)*sizeof(char));   strcpy(name_var,$3);   aux = (char*)malloc(5+strlen($3)*sizeof(char)); sprintf(aux,"Id(%s)",$3); tmp = make_node(aux,"Id",name_var,NULL,NULL); addBrother($1,tmp); $$ = make_node("Params",NULL,NULL,$1,NULL);};
					| VAR IDList ':' ID 					{name_var=(char*)malloc(strlen($4)*sizeof(char));   strcpy(name_var,$4);   aux = (char*)malloc(5+strlen($4)*sizeof(char)); sprintf(aux,"Id(%s)",$4); tmp = make_node(aux,"Id",name_var,NULL,NULL); addBrother($2,tmp); $$ = make_node("VarParams",NULL,NULL,$2,NULL);};

FuncBlock 			: VarPart StatPart 						{addBrother($1,$2); $$ = $1;};

StatPart 			: CompStat								{$$ = check_statlist($1);};

CompStat 			: BEG StatList END						{$$ = check_statlist2($2);};

StatList 			: Stat Stat2							{addBrother($1,$2); if ($1 == NULL) $$ = $2; else $$ = $1;};

Stat2 				: ';' Stat Stat2						{addBrother($2,$3); if ($2 == NULL) $$ = $3; else $$ = $2;};
					|										{$$ = NULL;};

Stat  				: CompStat 								{$$ = $1;};
					| IF Expr THEN Stat 					{tmp = check_statlist($4); addBrother($2,tmp); addBrother(tmp,make_node("StatList",NULL,NULL,NULL,NULL)); $$ = make_node("IfElse",NULL,NULL,$2,NULL);};
					| IF Expr THEN Stat ELSE Stat 			{tmp = check_statlist($4); tmp2 = check_statlist($6); addBrother(tmp,tmp2); addBrother($2,tmp); $$ = make_node("IfElse",NULL,NULL,$2,NULL);};
					| WHILE Expr DO Stat 					{tmp = check_statlist($4); addBrother($2,tmp); $$ = make_node("While",NULL,NULL,$2,NULL);};
					| REPEAT StatList UNTIL Expr 			{tmp = check_statlist($2); addBrother(tmp,$4); $$ = make_node("Repeat",NULL,NULL,tmp,NULL);};
					| VAL '(' PARAMSTR '(' Expr ')' ',' ID ')' { strcpy(name_var,$8);   aux = (char*)malloc(5+strlen($8)*sizeof(char)); sprintf(aux,"Id(%s)",$8); addBrother($5,make_node(aux,"Id",name_var,NULL,NULL)); $$ = make_node("ValParam",NULL,NULL,$5,NULL);};
					| optStat2 								{$$ = $1;};
					| WRITELN 								{$$ = make_node("WriteLn",NULL,NULL,NULL,NULL);};
					| WRITELN WritelnPList 					{$$ = make_node("WriteLn",NULL,NULL,$2,NULL); };

optStat2 			: ID ASSIGN Expr 						{name_var=(char*)malloc(strlen($1)*sizeof(char)); strcpy(name_var,$1);   aux = (char*)malloc(5+strlen($1)*sizeof(char)); sprintf(aux,"Id(%s)",$1); tmp = make_node(aux,"Id",name_var ,NULL,$3); $$ = make_node("Assign",NULL,NULL,tmp,NULL);};
					|										{$$ = NULL;};

WritelnPList 		: '(' optWritelnPList WritelnPList2 ')' {$$ = $2; addBrother($2,$3);};

optWritelnPList 	: Expr 									{$$ = $1;};
					| STRING 								{name_var=(char*)malloc(strlen($1)*sizeof(char)); strcpy(name_var,$1);   aux = (char*)malloc(9+strlen($1)*sizeof(char)); sprintf(aux,"String(%s)",$1); $$ = make_node(aux,"String",name_var,NULL,NULL);};

WritelnPList2 		: ',' optWritelnPList WritelnPList2 	{$$ = $2; addBrother($2,$3);};
					|										{$$ = NULL;};

Expr  				: SimpleExpression 						{$$ = $1;};
					| SimpleExpression '=' SimpleExpression {$$ = make_node("Eq",NULL,NULL,$1,NULL); addBrother($1,$3);};
					| SimpleExpression '>' SimpleExpression {$$ = make_node("Gt",NULL,NULL,$1,NULL); addBrother($1,$3);};
					| SimpleExpression '<' SimpleExpression {$$ = make_node("Lt",NULL,NULL,$1,NULL); addBrother($1,$3);};
					| SimpleExpression LEQ SimpleExpression {$$ = make_node("Leq",NULL,NULL,$1,NULL); addBrother($1,$3);};
					| SimpleExpression NEQ SimpleExpression {$$ = make_node("Neq",NULL,NULL,$1,NULL); addBrother($1,$3);};
					| SimpleExpression GEQ SimpleExpression	{$$ = make_node("Geq",NULL,NULL,$1,NULL); addBrother($1,$3);};

SimpleExpression 	: '+' Term 								{$$ = make_node("Plus",NULL,NULL,$2,NULL);};
					| '-' Term 								{$$ = make_node("Minus",NULL,NULL,$2,NULL);};
					| Term 									{$$ = $1;};
					| SimpleExpression '+' Term 			{$$ = make_node("Add",NULL,NULL,$1,NULL); addBrother($1,$3);};
					| SimpleExpression '-' Term 			{$$ = make_node("Sub",NULL,NULL,$1,NULL); addBrother($1,$3);};
					| SimpleExpression OR Term 				{$$ = make_node("Or",NULL,NULL,$1,NULL); addBrother($1,$3);};

Term				: Term AND Factor 						{$$ = make_node("And",NULL,NULL,$1,NULL); addBrother($1,$3);};
					| Term MOD Factor 						{$$ = make_node("Mod",NULL,NULL,$1,NULL); addBrother($1,$3);};
					| Term DIV Factor 						{$$ = make_node("Div",NULL,NULL,$1,NULL); addBrother($1,$3);};
					| Term '*' Factor 						{$$ = make_node("Mul",NULL,NULL,$1,NULL); addBrother($1,$3);};
					| Term '/' Factor 						{$$ = make_node("RealDiv",NULL,NULL,$1,NULL); addBrother($1,$3);};
					| Factor 								{$$ = $1;};

Factor				: NOT Factor 							{$$ = make_node("Not",NULL,NULL,$2,NULL);};
					| '(' Expr ')' 							{$$ = $2;};
					| INTLIT 								{name_var=(char*)malloc(strlen($1)*sizeof(char));   strcpy(name_var,$1);   aux = (char*)malloc(9+strlen($1)*sizeof(char)); sprintf(aux,"IntLit(%s)",$1); $$ = make_node(aux,"IntLit",name_var,NULL,NULL);};
					| REALLIT 								{name_var=(char*)malloc(strlen($1)*sizeof(char));   strcpy(name_var,$1);   aux = (char*)malloc(10+strlen($1)*sizeof(char)); sprintf(aux,"RealLit(%s)",$1); $$ = make_node(aux,"RealLit",name_var,NULL,NULL);};
					| ID ParamList 							{name_var=(char*)malloc(strlen($1)*sizeof(char));   strcpy(name_var,$1);   aux = (char*)malloc(5+strlen($1)*sizeof(char)); sprintf(aux,"Id(%s)",$1); $$ = make_node("Call",NULL,NULL,make_node(aux,"Id",name_var,NULL,$2),NULL);};
					| ID 									{/*printf("%lu %lu\n",line,col);*/	name_var=(char*)malloc(strlen($1)*sizeof(char));   strcpy(name_var,$1);   aux = (char*)malloc(5+strlen($1)*sizeof(char)); sprintf(aux,"Id(%s)",$1); $$ = make_node(aux,"Id",name_var,NULL,NULL);};

ParamList        	: '(' Expr repParamList ')'				{addBrother($2,$3); $$ = $2;};

repParamList 		: ',' Expr repParamList 				{addBrother($2,$3); $$ = $2;};
					|										{$$ = NULL;};




%%

void yyerror (char *s) {
	 printf ("Line %d, col %d: %s: %s\n", line, (int)(col)-(int)strlen(yytext), s, yytext);
}

int main(int argc, char * argv[]) {
	yyparse();
	if ( argc > 1 && strcmp(argv[1],"-t") == 0) printAll(root,0); 
	return 0;
}











//final


