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
<<<<<<< HEAD
Node * root;
char * aux;
=======
Node * tmp2;
Node * root;
char * aux;
char * aux2;
>>>>>>> d4e194aaae7dd52a57207ef083c7000fdaf137ec


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


<<<<<<< HEAD
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
=======
Program   			: ProgHeading  ';'  ProgBlock  '.' 		{root=make_node("Program",$1,NULL); addBrother($1,$3);};

ProgHeading			: PROGRAM ID '(' OUTPUT ')'				{aux = (char*)malloc(5+strlen($2)*sizeof(char)); sprintf(aux,"Id(%s)",$2); $$ = make_node(aux,NULL,NULL);};

ProgBlock			: VarPart FuncPart StatPart				{$$ = $1; tmp = make_node("FuncPart",$2,NULL); addBrother(tmp,$3); addBrother($1,tmp);};

VarPart 			: VAR VarDeclaration ';' VarPart2		{$$ = make_node("VarPart",$2,NULL); addBrother($2,$4);};
					|										{$$ = make_node("VarPart",NULL,NULL);};

VarPart2 			: VarDeclaration ';' VarPart2			{$$ = $1; addBrother($1,$3);};
					| 										{$$ = NULL;};

VarDeclaration 		: IDList ':' ID 						{aux = (char*)malloc(5+strlen($3)*sizeof(char)); sprintf(aux,"Id(%s)",$3); addBrother($1,make_node(aux,NULL,NULL)); $$ = make_node("VarDecl",$1,NULL);};

IDList 				: ID IDList2							{aux = (char*)malloc(5+strlen($1)*sizeof(char)); sprintf(aux,"Id(%s)",$1); $$ = make_node(aux,NULL,$2);};

IDList2 			: ',' ID IDList2						{aux = (char*)malloc(5+strlen($2)*sizeof(char)); sprintf(aux,"Id(%s)",$2); $$ = make_node(aux,NULL,$3);};
					| 										{$$ = NULL;};

FuncPart 			: FuncDeclaration ';' FuncPart 			{addBrother($1,$3); $$ = $1;};
					|										{$$ = NULL;};	

FuncDeclaration 	: FuncHeading ';' FORWARD 				{$$ = make_node("FuncDecl",$1,NULL);};
					| FuncIdent ';' FuncBlock 				{addBrother($1,$3); $$ = make_node("FuncDef2",$1,NULL);};
					| FuncHeading ';' FuncBlock				{addBrother($1,$3); $$ = make_node("FuncDef",$1,NULL);};

FuncHeading 		: FUNCTION ID ':' ID 					{aux = (char*)malloc(5+strlen($2)*sizeof(char)); sprintf(aux,"Id(%s)",$2); aux2 = (char*)malloc(5+strlen($4)*sizeof(char)); sprintf(aux2,"Id(%s)",$4); tmp = make_node(aux,NULL,make_node("FuncParams",NULL,NULL)); addBrother(tmp,make_node(aux2,NULL,NULL)); $$ = tmp;};
					| FUNCTION ID FormalParamList ':' ID 	{aux = (char*)malloc(5+strlen($2)*sizeof(char)); sprintf(aux,"Id(%s)",$2); aux2 = (char*)malloc(5+strlen($5)*sizeof(char)); sprintf(aux2,"Id(%s)",$5); tmp = make_node(aux,NULL,NULL); if ($3 == NULL) {$3=make_node("FuncParams",NULL,NULL);} addBrother(tmp,$3); addBrother($3,make_node(aux2,NULL,NULL)); $$ = tmp;};

FuncIdent 			: FUNCTION ID 							{aux = (char*)malloc(5+strlen($2)*sizeof(char)); sprintf(aux,"Id(%s)",$2); $$ = make_node(aux,NULL,NULL);};

FormalParamList 	: '(' FormalParams FormalParamListaux ')' {addBrother($2,$3); $$ = make_node("FuncParams",$2,NULL);};

FormalParamListaux 	: ';' FormalParams FormalParamListaux 	{addBrother($2,$3); $$ = $2;};
					|										{$$ = NULL;};

FormalParams 		: IDList ':' ID 						{aux = (char*)malloc(5+strlen($3)*sizeof(char)); sprintf(aux,"Id(%s)",$3); tmp = make_node(aux,NULL,NULL); addBrother($1,tmp); $$ = make_node("Params",$1,NULL);};
					| VAR IDList ':' ID 					{aux = (char*)malloc(5+strlen($4)*sizeof(char)); sprintf(aux,"Id(%s)",$4); tmp = make_node(aux,NULL,NULL); addBrother($2,tmp); $$ = make_node("VarParams",$2,NULL);};

FuncBlock 			: VarPart StatPart 						{addBrother($1,$2); $$ = $1;};

StatPart 			: CompStat								{$$ = check_statlist($1);};

CompStat 			: BEG StatList END						{$$ = check_statlist2($2);};

StatList 			: Stat Stat2							{addBrother($1,$2); $$ = $1;};

Stat2 				: ';' Stat Stat2						{addBrother($2,$3); $$ = $2;};
					|										{$$ = NULL;};

Stat  				: CompStat 								{$$ = $1;};
					| IF Expr THEN Stat 					{tmp = check_statlist($4); addBrother($2,tmp); addBrother(tmp,make_node("StatList",NULL,NULL)); $$ = make_node("IfElse",$2,NULL);};
					| IF Expr THEN Stat ELSE Stat 			{tmp = check_statlist($4); tmp2 = check_statlist($6); addBrother(tmp,tmp2); addBrother($2,tmp); $$ = make_node("IfElse",$2,NULL);};
					| WHILE Expr DO Stat 					{tmp = check_statlist($4); addBrother($2,tmp); $$ = make_node("While",$2,NULL);};
					| REPEAT StatList UNTIL Expr 			{tmp = check_statlist($2); addBrother(tmp,$4); $$ = make_node("Repeat",tmp,NULL);};
					| VAL '(' PARAMSTR '(' Expr ')' ',' ID ')' {aux = (char*)malloc(5+strlen($8)*sizeof(char)); sprintf(aux,"Id(%s)",$8); addBrother($5,make_node(aux,NULL,NULL)); $$ = make_node("ValParam",$5,NULL);};
					| optStat2 								{$$ = $1;};
					| WRITELN 								{$$ = make_node("WriteLn",NULL,NULL);};
					| WRITELN WritelnPList 					{$$ = make_node("WriteLn",$2,NULL); };

optStat2 			: ID ASSIGN Expr 						{aux = (char*)malloc(5+strlen($1)*sizeof(char)); sprintf(aux,"Id(%s)",$1); tmp = make_node(aux,NULL,$3); $$ = make_node("Assign",tmp,NULL);};
					|										{$$ = NULL;};

WritelnPList 		: '(' optWritelnPList WritelnPList2 ')' {$$ = $2; addBrother($2,$3);};

optWritelnPList 	: Expr 									{$$ = $1;};
					| STRING 								{aux = (char*)malloc(9+strlen($1)*sizeof(char)); sprintf(aux,"String(%s)",$1); $$ = make_node(aux,NULL,NULL);};

WritelnPList2 		: ',' optWritelnPList WritelnPList2 	{$$ = $2; addBrother($2,$3);};
					|										{$$ = NULL;};

Expr  				: SimpleExpression 						{$$ = $1;};
					| SimpleExpression '=' SimpleExpression {$$ = make_node("Eq",$1,NULL); addBrother($1,$3);};
					| SimpleExpression '>' SimpleExpression {$$ = make_node("Gt",$1,NULL); addBrother($1,$3);};
					| SimpleExpression '<' SimpleExpression {$$ = make_node("Lt",$1,NULL); addBrother($1,$3);};
					| SimpleExpression LEQ SimpleExpression {$$ = make_node("Leq",$1,NULL); addBrother($1,$3);};
					| SimpleExpression NEQ SimpleExpression {$$ = make_node("Neq",$1,NULL); addBrother($1,$3);};
					| SimpleExpression GEQ SimpleExpression	{$$ = make_node("Geq",$1,NULL); addBrother($1,$3);};

SimpleExpression 	: '+' Term 								{$$ = make_node("Plus",$2,NULL);};
					| '-' Term 								{$$ = make_node("Minus",$2,NULL);};
					| Term 									{$$ = $1;};
					| SimpleExpression '+' Term 			{$$ = make_node("Add",$1,NULL); addBrother($1,$3);};
					| SimpleExpression '-' Term 			{$$ = make_node("Sub",$1,NULL); addBrother($1,$3);};
					| SimpleExpression OR Term 				{$$ = make_node("Or",$1,NULL); addBrother($1,$3);};

Term				: Term AND Factor 						{$$ = make_node("And",$1,NULL); addBrother($1,$3);};
					| Term MOD Factor 						{$$ = make_node("Mod",$1,NULL); addBrother($1,$3);};
					| Term DIV Factor 						{$$ = make_node("Div",$1,NULL); addBrother($1,$3);};
					| Term '*' Factor 						{$$ = make_node("Mul",$1,NULL); addBrother($1,$3);};
					| Term '/' Factor 						{$$ = make_node("RealDiv",$1,NULL); addBrother($1,$3);};
					| Factor 								{$$ = $1;};

Factor				: NOT Factor 							{$$ = make_node("Not", $2,NULL);};
					| '(' Expr ')' 							{$$ = $2;};
					| INTLIT 								{aux = (char*)malloc(9+strlen($1)*sizeof(char)); sprintf(aux,"IntLit(%s)",$1); $$ = make_node(aux,NULL,NULL);};
					| REALLIT 								{aux = (char*)malloc(10+strlen($1)*sizeof(char)); sprintf(aux,"RealLit(%s)",$1); $$ = make_node(aux,NULL,NULL);};
					| ID ParamList 							{aux = (char*)malloc(5+strlen($1)*sizeof(char)); sprintf(aux,"Id(%s)",$1); $$ = make_node("Call",make_node(aux,NULL,$2),NULL);};
					| ID 									{aux = (char*)malloc(5+strlen($1)*sizeof(char)); sprintf(aux,"Id(%s)",$1); $$ = make_node(aux,NULL,NULL);};

ParamList        	: '(' Expr repParamList ')'				{addBrother($2,$3); $$ = $2;};

repParamList 		: ',' Expr repParamList 				{addBrother($2,$3); $$ = $2;};
					|										{$$ = NULL;};
>>>>>>> d4e194aaae7dd52a57207ef083c7000fdaf137ec




%%

void yyerror (char *s) {
	 printf ("Line %d, col %d: %s: %s\n", line, (int)(col)-(int)strlen(yytext), s, yytext);
}

<<<<<<< HEAD
int main()
{
    printf("txua");
	yyparse();
	printAll(root);
=======
int main(int argc, char * argv[]) {
	yyparse();
	if ( argc > 1 && strcmp(argv[1],"-t") == 0) printAll(root,0); 
>>>>>>> d4e194aaae7dd52a57207ef083c7000fdaf137ec
	return 0;
}











//final


