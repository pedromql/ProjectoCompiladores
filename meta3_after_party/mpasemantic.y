%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "structures.h"
#include "thirdfase.h"

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


Program   			: ProgHeading  ';'  ProgBlock  '.' 		{root=make_node("Program","Program",NULL,$1,NULL,line,col-(int)strlen(yytext) -1); addBrother($1,$3);};

ProgHeading			: PROGRAM ID '(' OUTPUT ')'				{name_var=(char*)malloc(strlen($2)*sizeof(char));   strcpy(name_var,$2); aux = (char*)malloc(5+strlen($2)*sizeof(char)); sprintf(aux,"Id(%s)",$2); $$ = make_node(aux,"Id",name_var,NULL,NULL,@2.first_line,@2.first_column);};

ProgBlock			: VarPart FuncPart StatPart				{$$ = $1; tmp = make_node("FuncPart","FuncPart",NULL,$2,NULL,line,col-(int)strlen(yytext)); addBrother(tmp,$3); addBrother($1,tmp);};

VarPart 			: VAR VarDeclaration ';' VarPart2		{$$ = make_node("VarPart","VarPart",NULL,$2,NULL,line,col-(int)strlen(yytext)); addBrother($2,$4);};
					|										{$$ = make_node("VarPart","VarPart",NULL,NULL,NULL,line,col-(int)strlen(yytext));};

VarPart2 			: VarDeclaration ';' VarPart2			{$$ = $1; addBrother($1,$3);};
					| 										{$$ = NULL;};

VarDeclaration 		: IDList ':' ID 						{name_var=(char*)malloc(strlen($3)*sizeof(char));   strcpy(name_var,$3);   aux = (char*)malloc(5+strlen($3)*sizeof(char)); sprintf(aux,"Id(%s)",$3); addBrother($1,make_node(aux,"Id",name_var,NULL,NULL,@3.first_line,@3.first_column)); $$ = make_node("VarDecl","VarDecl",NULL,$1,NULL,line,col-(int)strlen(yytext));};

IDList 				: ID IDList2							{name_var=(char*)malloc(strlen($1)*sizeof(char));   strcpy(name_var,$1);   aux = (char*)malloc(5+strlen($1)*sizeof(char)); sprintf(aux,"Id(%s)",$1); $$ = make_node(aux,"Id",name_var,NULL,$2,@1.first_line,@1.first_column);};

IDList2 			: ',' ID IDList2						{name_var=(char*)malloc(strlen($2)*sizeof(char));   strcpy(name_var,$2);   aux = (char*)malloc(5+strlen($2)*sizeof(char)); sprintf(aux,"Id(%s)",$2); $$ = make_node(aux,"Id",name_var,NULL,$3,@2.first_line,@2.first_column);};
					| 										{$$ = NULL;};

FuncPart 			: FuncDeclaration ';' FuncPart 			{addBrother($1,$3); $$ = $1;};
					|										{$$ = NULL;};	

FuncDeclaration 	: FuncHeading ';' FORWARD 				{$$ = make_node("FuncDecl","FuncDecl",NULL,$1,NULL,line,col-(int)strlen(yytext));};
					| FuncIdent ';' FuncBlock 				{addBrother($1,$3); $$ = make_node("FuncDef2","FuncDef2",NULL,$1,NULL,line,col-(int)strlen(yytext));};
					| FuncHeading ';' FuncBlock				{addBrother($1,$3); $$ = make_node("FuncDef","FuncDef",NULL,$1,NULL,line,col-(int)strlen(yytext));};

FuncHeading 		: FUNCTION ID ':' ID 					{name_var=(char*)malloc(strlen($2)*sizeof(char));   strcpy(name_var,$2);   name_var2=(char*)malloc(strlen($4)*sizeof(char));   strcpy(name_var2,$4);   aux = (char*)malloc(5+strlen($2)*sizeof(char)); sprintf(aux,"Id(%s)",$2); aux2 = (char*)malloc(5+strlen($4)*sizeof(char)); sprintf(aux2,"Id(%s)",$4); tmp = make_node(aux,"Id",name_var,NULL,make_node("FuncParams","FuncParams",NULL,NULL,NULL,@2.first_line,@2.first_column),line,col-(int)strlen(yytext)); addBrother(tmp,make_node(aux2,"Id",name_var2,NULL,NULL,@4.first_line,@4.first_column)); $$ = tmp;};
					| FUNCTION ID FormalParamList ':' ID 	{name_var=(char*)malloc(strlen($2)*sizeof(char));   strcpy(name_var,$2);   name_var2=(char*)malloc(strlen($5)*sizeof(char));   strcpy(name_var2,$5);  aux = (char*)malloc(5+strlen($2)*sizeof(char)); sprintf(aux,"Id(%s)",$2); aux2 = (char*)malloc(5+strlen($5)*sizeof(char)); sprintf(aux2,"Id(%s)",$5); tmp = make_node(aux,"Id",name_var,NULL,NULL,@2.first_line,@2.first_column); if ($3 == NULL) {$3=make_node("FuncParams","FuncParams",NULL,NULL,NULL,line,col-(int)strlen(yytext));} addBrother(tmp,$3); addBrother($3,make_node(aux2,"Id",name_var2,NULL,NULL,@5.first_line,@5.first_column)); $$ = tmp;};

FuncIdent 			: FUNCTION ID 							{name_var=(char*)malloc(strlen($2)*sizeof(char));   strcpy(name_var,$2); aux = (char*)malloc(5+strlen($2)*sizeof(char)); sprintf(aux,"Id(%s)",$2); $$ = make_node(aux,"Id",name_var,NULL,NULL,@2.first_line,@2.first_column);};

FormalParamList 	: '(' FormalParams FormalParamListaux ')' {addBrother($2,$3); $$ = make_node("FuncParams","FuncParams",NULL,$2,NULL,line,col-(int)strlen(yytext));};

FormalParamListaux 	: ';' FormalParams FormalParamListaux 	{addBrother($2,$3); $$ = $2;};
					|										{$$ = NULL;};

FormalParams 		: IDList ':' ID 						{name_var=(char*)malloc(strlen($3)*sizeof(char));   strcpy(name_var,$3);   aux = (char*)malloc(5+strlen($3)*sizeof(char)); sprintf(aux,"Id(%s)",$3); tmp = make_node(aux,"Id",name_var,NULL,NULL,@3.first_line,@3.first_column); addBrother($1,tmp); $$ = make_node("Params","Params",NULL,$1,NULL,line,col-(int)strlen(yytext));};
					| VAR IDList ':' ID 					{name_var=(char*)malloc(strlen($4)*sizeof(char));   strcpy(name_var,$4);   aux = (char*)malloc(5+strlen($4)*sizeof(char)); sprintf(aux,"Id(%s)",$4); tmp = make_node(aux,"Id",name_var,NULL,NULL,@4.first_line,@4.first_column); addBrother($2,tmp); $$ = make_node("VarParams","VarParams",NULL,$2,NULL,line,col-(int)strlen(yytext));};

FuncBlock 			: VarPart StatPart 						{addBrother($1,$2); $$ = $1;};

StatPart 			: CompStat								{$$ = check_statlist($1,line,col-(int)strlen(yytext));};

CompStat 			: BEG StatList END						{$$ = check_statlist2($2,line,col-(int)strlen(yytext));};

StatList 			: Stat Stat2							{addBrother($1,$2); if ($1 == NULL) $$ = $2; else $$ = $1;};

Stat2 				: ';' Stat Stat2						{addBrother($2,$3); if ($2 == NULL) $$ = $3; else $$ = $2;};
					|										{$$ = NULL;};

Stat  				: CompStat 								{$$ = $1;};
					| IF Expr THEN Stat 					{tmp = check_statlist($4,line,col-(int)strlen(yytext)); addBrother($2,tmp); addBrother(tmp,make_node("StatList","StatList",NULL,NULL,NULL,line,col-(int)strlen(yytext))); $$ = make_node("IfElse","IfElse",NULL,$2,NULL,line,col-(int)strlen(yytext));};
					| IF Expr THEN Stat ELSE Stat 			{tmp = check_statlist($4,line,col-(int)strlen(yytext)); tmp2 = check_statlist($6,line,col-(int)strlen(yytext)); addBrother(tmp,tmp2); addBrother($2,tmp); $$ = make_node("IfElse","IfElse",NULL,$2,NULL,line,col-(int)strlen(yytext));};
					| WHILE Expr DO Stat 					{tmp = check_statlist($4,line,col-(int)strlen(yytext)); addBrother($2,tmp); $$ = make_node("While","While",NULL,$2,NULL,line,col-(int)strlen(yytext));};
					| REPEAT StatList UNTIL Expr 			{tmp = check_statlist($2,line,col-(int)strlen(yytext)); addBrother(tmp,$4); $$ = make_node("Repeat","Repeat",NULL,tmp,NULL,line,col-(int)strlen(yytext));};
					| VAL '(' PARAMSTR '(' Expr ')' ',' ID ')' { strcpy(name_var,$8);   aux = (char*)malloc(5+strlen($8)*sizeof(char)); sprintf(aux,"Id(%s)",$8); addBrother($5,make_node(aux,"Id",name_var,NULL,NULL,@8.first_line,@8.first_column)); $$ = make_node("ValParam","ValParam",NULL,$5,NULL,line,col-(int)strlen(yytext));};
					| optStat2 								{$$ = $1;};
					| WRITELN 								{$$ = make_node("WriteLn","WriteLn",NULL,NULL,NULL,line,col-(int)strlen(yytext));};
					| WRITELN WritelnPList 					{$$ = make_node("WriteLn","WriteLn",NULL,$2,NULL,line,col-(int)strlen(yytext)); };

optStat2 			: ID ASSIGN Expr 						{name_var=(char*)malloc(strlen($1)*sizeof(char)); strcpy(name_var,$1);   aux = (char*)malloc(5+strlen($1)*sizeof(char)); sprintf(aux,"Id(%s)",$1); tmp = make_node(aux,"Id",name_var ,NULL,$3,@1.first_line,@1.first_column); $$ = make_node("Assign","Assign",NULL,tmp,NULL,line,col-(int)strlen(yytext));};
					|										{$$ = NULL;};

WritelnPList 		: '(' optWritelnPList WritelnPList2 ')' {$$ = $2; addBrother($2,$3);};

optWritelnPList 	: Expr 									{$$ = $1;};
					| STRING 								{name_var=(char*)malloc(strlen($1)*sizeof(char)); strcpy(name_var,$1);   aux = (char*)malloc(9+strlen($1)*sizeof(char)); sprintf(aux,"String(%s)",$1); $$ = make_node(aux,"String",name_var,NULL,NULL,@1.first_line,@1.first_column);};

WritelnPList2 		: ',' optWritelnPList WritelnPList2 	{$$ = $2; addBrother($2,$3);};
					|										{$$ = NULL;};

Expr  				: SimpleExpression 						{$$ = $1;};
					| SimpleExpression '=' SimpleExpression {$$ = make_node("Eq","Eq",NULL,$1,NULL,line,col-(int)strlen(yytext)); addBrother($1,$3);};
					| SimpleExpression '>' SimpleExpression {$$ = make_node("Gt","Gt",NULL,$1,NULL,line,col-(int)strlen(yytext)); addBrother($1,$3);};
					| SimpleExpression '<' SimpleExpression {$$ = make_node("Lt","Lt",NULL,$1,NULL,line,col-(int)strlen(yytext)); addBrother($1,$3);};
					| SimpleExpression LEQ SimpleExpression {$$ = make_node("Leq","Leq",NULL,$1,NULL,line,col-(int)strlen(yytext)); addBrother($1,$3);};
					| SimpleExpression NEQ SimpleExpression {$$ = make_node("Neq","Neq",NULL,$1,NULL,line,col-(int)strlen(yytext)); addBrother($1,$3);};
					| SimpleExpression GEQ SimpleExpression	{$$ = make_node("Geq","Geq",NULL,$1,NULL,line,col-(int)strlen(yytext)); addBrother($1,$3);};

SimpleExpression 	: '+' Term 								{$$ = make_node("Plus","Plus",NULL,$2,NULL,line,col-(int)strlen(yytext));};
					| '-' Term 								{$$ = make_node("Minus","Minus",NULL,$2,NULL,line,col-(int)strlen(yytext));};
					| Term 									{$$ = $1;};
					| SimpleExpression '+' Term 			{$$ = make_node("Add","Add",NULL,$1,NULL,line,col-(int)strlen(yytext)); addBrother($1,$3);};
					| SimpleExpression '-' Term 			{$$ = make_node("Sub","Sub",NULL,$1,NULL,line,col-(int)strlen(yytext)); addBrother($1,$3);};
					| SimpleExpression OR Term 				{$$ = make_node("Or","Or",NULL,$1,NULL,line,col-(int)strlen(yytext)); addBrother($1,$3);};

Term				: Term AND Factor 						{$$ = make_node("And","And",NULL,$1,NULL,line,col-(int)strlen(yytext)); addBrother($1,$3);};
					| Term MOD Factor 						{$$ = make_node("Mod","Mod",NULL,$1,NULL,line,col-(int)strlen(yytext)); addBrother($1,$3);};
					| Term DIV Factor 						{$$ = make_node("Div","Div",NULL,$1,NULL,line,col-(int)strlen(yytext)); addBrother($1,$3);};
					| Term '*' Factor 						{$$ = make_node("Mul","Mul",NULL,$1,NULL,line,col-(int)strlen(yytext)); addBrother($1,$3);};
					| Term '/' Factor 						{$$ = make_node("RealDiv","RealDiv",NULL,$1,NULL,line,col-(int)strlen(yytext)); addBrother($1,$3);};
					| Factor 								{$$ = $1;};

Factor				: NOT Factor 							{$$ = make_node("Not","Not",NULL,$2,NULL,line,col-(int)strlen(yytext));};
					| '(' Expr ')' 							{$$ = $2;};
					| INTLIT 								{name_var=(char*)malloc(strlen($1)*sizeof(char));   strcpy(name_var,$1);   aux = (char*)malloc(9+strlen($1)*sizeof(char)); sprintf(aux,"IntLit(%s)",$1); $$ = make_node(aux,"IntLit",name_var,NULL,NULL,@1.first_line,@1.first_column);};
					| REALLIT 								{name_var=(char*)malloc(strlen($1)*sizeof(char));   strcpy(name_var,$1);   aux = (char*)malloc(10+strlen($1)*sizeof(char)); sprintf(aux,"RealLit(%s)",$1); $$ = make_node(aux,"RealLit",name_var,NULL,NULL,@1.first_line,@1.first_column);};
					| ID ParamList 							{name_var=(char*)malloc(strlen($1)*sizeof(char));   strcpy(name_var,$1);   aux = (char*)malloc(5+strlen($1)*sizeof(char)); sprintf(aux,"Id(%s)",$1); $$ = make_node("Call","Call",NULL,make_node(aux,"Id",name_var,NULL,$2,@1.first_line,@1.first_column),NULL,line,col-(int)strlen(yytext));};
					| ID 									{/*printf("%lu %lu\n",line,col-(int)strlen(yytext));*/	name_var=(char*)malloc(strlen($1)*sizeof(char));   strcpy(name_var,$1);   aux = (char*)malloc(5+strlen($1)*sizeof(char)); sprintf(aux,"Id(%s)",$1); $$ = make_node(aux,"Id",name_var,NULL,NULL,@1.first_line,@1.first_column);};

ParamList        	: '(' Expr repParamList ')'				{addBrother($2,$3); $$ = $2;};

repParamList 		: ',' Expr repParamList 				{addBrother($2,$3); $$ = $2;};
					|										{$$ = NULL;};




%%

void yyerror (char *s) {
	 printf ("Line %d, col %d: %s: %s\n", line, (int)(col)-(int)strlen(yytext), s, yytext);
	 exit(0);
}

int main(int argc, char * argv[]) {
	yyparse();
	//printAll(root,0);
	if ( argc == 2 && strcmp(argv[1],"-t") == 0) printAll(root,0);
	else if (argc == 2 && strcmp(argv[1],"-s") == 0) print_tables(create_tables(root));
	else if (argc == 3) {
		printAll(root,0);
		printf("\n");
		print_tables(create_tables(root));
	}

	return 0;
}


/*tratamento de erros, as funcoes retorna 1 se tiverem erros 
	
	1-> tipo de dados impresso como aparece na tabela
	2-> os tokens são impressos da mesma maneira que são lidos
	3-> NOS STATEMENTS (if, while, repeat-until e val-paramstr) DEVERAO ESTAR EM MINUSCULAS CARALHO!!!!!!!

*/
//Cannot write values of type <type>
int error_cannotwritevalues(char* type){
	printf("Line %d, col %d: Cannot write values of type %s\n", line, (int)(col)-(int)strlen(yytext), type);	
	return 0;
}	
//Function identifier expected
int error_unctionidentifierexpected(void){
	printf("Line %d, col %d: Function identifier expected\n", line, (int)(col)-(int)strlen(yytext));
	return 0;
}
//Incompatible type for argument <num> in call to function <token> (got <type>, expected <type>)
int error_incompatibletypeforargument(char *s, char * function_name, char *got, char *expected){
	printf("Line %d, col %d: Incompatible type for argument %s in call to function %s (got %s, expected %s)\n", line, (int)(col)-(int)strlen(yytext),s ,function_name,got,expected);
	return 0;
}
//Incompatible type in assigment to <token> (got <type>, expected <type>)
int  error_incompatibletypeassigment(char * token, char* got, char * expected){
	printf("Line %d, col %d: Incompatible type in assigment to %s (got %s, expected %s)\n", line, (int)(col)-(int)strlen(yytext),token,got,expected);
	return 0;
}
//Incompatible type in <statement> statement (got <type>, expected <type>)
int  error_incompatibletypestatement(char * token, char* got, char * expected){
	printf("Line %d, col %d: Incompatible type in %s statement (got %s, expected %s)\n", line, (int)(col)-(int)strlen(yytext),token,got,expected);
	return 0;
}
//Operator <token> cannot be applied to type <type>
int  error_operatornotappliedtotype(char * operator, char* type){
	printf("Line %d, col %d: Operator %s cannot be applied to type %s\n", line, (int)(col)-(int)strlen(yytext),operator,type);
	return 0;
}
//Operator <token> cannot be applied to types <type>, <type>			Parecido com o de cima, cuidado
int  error_operatornotappliedtotypes(char * operator, char * type1, char * type2){
	printf("Line %d, col %d: Operator %s cannot be applied to types %s, %s\n", line, (int)(col)-(int)strlen(yytext),operator,type1,type2);
	return 0;
}




//Variable identifier expected
int  error_variableidentifierexpected(void){
	printf("Line %d, col %d: Variable identifier expected\n", line, (int)(col)-(int)strlen(yytext));
	return 0;
}
//Wrong number of arguments in call to function <token> (got <type>, expected <type>)
int  error_wrongnumberofarguments(char * function_name, char* got, char * expected){
	printf("Line %d, col %d: Wrong number of arguments in call to function %s (got %s, expected %s)\n", line, (int)(col)-(int)strlen(yytext),function_name,got,expected);
	return 0;
}
//aljhsbdkjabsdohbaosdhb
/*as
da
sd
aszsjlszjkbdlahsdlahsdljh
d+7+*/
//final


