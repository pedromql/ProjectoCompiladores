%{
	#include <stdio.h>
	#include <stdlib.h>
	#include <string.h>
	#include "semantics.h"
	#include "generate.h"


	
	extern int charcount;
	extern int linecount;
	extern char* yytext;
	extern int yyleng;
	int yylex();
	void yyerror(char *s);

arvore raiz;

arvore no_base(char *valor,char tipo[10],int l,int c){

	arvore parte;
	parte = (arvore) malloc(sizeof(No_arvore));
	
	
	if(valor!=NULL){
		parte->valor=strsep(&valor,"º");
		parte->linha=l;
		parte->coluna=c;
	}
	else{
		parte->valor = valor;
		parte->linha = 0;
		parte->coluna = 0;
	}

	

	strcpy(parte->tipo,tipo);
	parte->irmao = NULL;
	parte->filho = NULL;
	
	return parte;
}

void adicionar_irmao(arvore a,arvore b){
	if(a!=NULL){
		while(a->irmao!=NULL){
			a=a->irmao;
		}
		a->irmao = b;
	}
}

void imprimir_arvore(arvore a,int b){
	int i;
	if(a!=NULL){
		for(i=0;i<b;i++){
			printf(".");
		}
		if(strcmp("Id",a->tipo) == 0 || strcmp("RealLit",a->tipo)==0 || strcmp("IntLit",a->tipo)==0 || strcmp("String", a->tipo)==0){
			printf("%s(%s)\n",a->tipo,a->valor);
		
		}else{
			printf("%s\n",a->tipo);
		}
		imprimir_arvore(a->filho,b+2);
		imprimir_arvore(a->irmao,b);
	}
}

arvore temporaria;

%}

%locations

%union{
	char* str;
	struct node* tips;
	
}

%nonassoc LESS GREATER EQUAL DIFF LESSE GREATERE 
%left MINUS PLUS OR 
%left TIMES DIVISION MOD DIV AND
%left NOT


%type <tips> preFuncPart repExpr CompStat Expr FormalParamList FormalParams FuncBlock FuncDeclaration FuncHeading FuncIdent FuncPart IDList opWrite1 ParamList Prog ProgBlock ProgHeading repFormalParams repIDList repVarPart repWrite2 simpleExpr Stat StatList StatPart Term VarPart VarDeclaration WritelnPList



%token BEGIN_

%token <str> ASSIGN COLON COMMA DO  DOT END ELSE FORWARD FUNCTION IF LBRAC NOT OUTPUT PARAMSTR PROGRAM RBRAC

%token <str> REPEAT 
%token <str> SEMIC 
%token <str> THEN 
%token <str> UNTIL 
%token <str> VAL 
%token <str> VAR
%token <str> WHILE
%token <str> WRITELN
%token <str> AND
%token <str> OR

%token <str>LESS
%token <str>GREATER
%token EQUAL
%token DIFF
%token <str> LESSE
%token <str> GREATERE

%token PLUS
%token MINUS

%token <str> TIMES
%token <str> DIVISION
%token <str> MOD
%token <str> DIV

%token <str> RESERVED

%token <str> ID
%token <str> INTLIT
%token <str> REALLIT
%token STRING1
%token <str> STRING

%nonassoc THEN
%nonassoc ELSE



%%

Prog: ProgHeading SEMIC ProgBlock DOT 			{raiz = no_base(NULL,"Program",-1,-1);
												adicionar_irmao($1,$3);
												raiz->filho=$1;}
																						


ProgHeading: PROGRAM ID LBRAC OUTPUT RBRAC 		{$$=no_base($2,"Id",@2.first_line,@2.first_column);					
												} 


ProgBlock: VarPart preFuncPart StatPart 			{
													$$=no_base(NULL,"VarPart",-1,-1);
													$$->filho = $1;

													temporaria = no_base(NULL,"FuncPart",-1,-1);
													temporaria->filho = $2;
													adicionar_irmao($$,temporaria);
													
													if($3 != NULL){
														adicionar_irmao($$,$3);
													}
													else{
														adicionar_irmao($$,no_base(NULL,"StatList",-1,-1));
													}
												}

VarPart: VAR VarDeclaration SEMIC repVarPart 	{
													$$=no_base(	NULL,"VarDecl",-1,-1);
													$$->filho = $2;
													adicionar_irmao($$,$4);
												}
		| 										{$$=NULL;}
repVarPart:  VarDeclaration SEMIC repVarPart	{
													$$=no_base(NULL,"VarDecl",-1,-1);
													$$->filho = $1;
													adicionar_irmao($$,$3);
												}
			| 									{$$=NULL;}

VarDeclaration: IDList COLON ID 				{
													$$=$1;
													adicionar_irmao($$,no_base($3,"Id",@3.first_line,@3.first_column));
												}

IDList: ID repIDList 							{
													$$=no_base($1,"Id",@1.first_line,@1.first_column);
													adicionar_irmao($$,$2);
												}

repIDList: COMMA ID repIDList 					{
													$$=no_base($2,"Id",@2.first_line,@2.first_column);
													adicionar_irmao($$,$3);
												}
		| 										{$$=NULL;}

preFuncPart : FuncPart 							{$$=$1;}
			| 									{$$=NULL;}

FuncPart: FuncPart FuncDeclaration SEMIC 		{
													$$=$1;
													adicionar_irmao($$,$2);
												
												}
		| FuncDeclaration 	SEMIC				{$$=$1;}

FuncDeclaration: FuncHeading SEMIC FORWARD		{$$=no_base(NULL,"FuncDecl",-1,-1);$$->filho = $1;}							
				| FuncIdent SEMIC FuncBlock		{$$=no_base(NULL,"FuncDef2",-1,-1);adicionar_irmao($1,$3);$$->filho = $1;}						
				| FuncHeading SEMIC FuncBlock	{$$=no_base(NULL,"FuncDef",-1,-1);adicionar_irmao($1,$3);$$->filho = $1;}

FuncHeading: FUNCTION ID FormalParamList COLON ID 	{$$=no_base($2,"Id",@2.first_line,@2.first_column);temporaria=no_base(NULL,"FuncParams",-1,-1);temporaria->filho=$3;adicionar_irmao($$,temporaria);adicionar_irmao($$,no_base($5,"Id",@5.first_line,@5.first_column));}
			| FUNCTION ID COLON ID 					{$$=no_base($2,"Id",@2.first_line,@2.first_column);adicionar_irmao($$,no_base(NULL,"FuncParams",-1,-1));adicionar_irmao($$,no_base($4,"Id",@4.first_line,@4.first_column));}

FuncIdent: FUNCTION ID 								{$$=no_base($2,"Id",@2.first_line,@2.first_column);}

FormalParamList: LBRAC FormalParams repFormalParams RBRAC	{adicionar_irmao($2,$3);$$=$2;}	
								

FormalParams: VAR IDList COLON ID 		{$$=no_base(NULL,"VarParams",-1,-1);adicionar_irmao($2,no_base($4,"Id",@4.first_line,@4.first_column));$$->filho=$2;}		
			| IDList COLON ID 			{$$=no_base(NULL,"Params",-1,-1);adicionar_irmao($1,no_base($3,"Id",@3.first_line,@3.first_column));$$->filho=$1;}

repFormalParams: SEMIC FormalParams repFormalParams {adicionar_irmao($2,$3);$$=$2;}
				| {$$=NULL;}


FuncBlock: VarPart StatPart		{$$=no_base(NULL,"VarPart",-1,-1);$$->filho=$1;
								if($2!=NULL){
									adicionar_irmao($$,$2);
								}else{
									adicionar_irmao($$,no_base(NULL,"StatList",-1,-1));
								}
								}

								

StatPart: CompStat				{$$=$1;}

CompStat: BEGIN_ StatList END	{if($2!=NULL){
									if($2->irmao!=NULL){
										$$=no_base(NULL,"StatList",-1,-1);
										temporaria=$$;
										temporaria->filho=$2;
									}else{
										$$=$2;
									}
								}else{
									$$=NULL;
								}
								}

StatList: StatList SEMIC Stat	{if($1!=NULL){
									adicionar_irmao($1,$3);
									$$=$1;
								}else{
									$$=$3;
								}
								}
			| Stat {$$=$1;}

Stat: CompStat {$$=$1;}
	| IF Expr THEN Stat {$$=no_base(NULL,"IfElse",-1,-1);$$->filho=$2; //just in case
						if($4!=NULL){
							adicionar_irmao($2,$4);
							adicionar_irmao($2,no_base(NULL,"StatList",-1,-1));
						}else{
							adicionar_irmao($2,no_base(NULL,"StatList",-1,-1));
							adicionar_irmao($2,no_base(NULL,"StatList",-1,-1));
						}
							}
	| IF Expr THEN Stat ELSE Stat {$$=no_base(NULL,"IfElse",-1,-1);temporaria=$$;temporaria->filho = $2;
									if($4!=NULL && $6 != NULL){
										adicionar_irmao($2,$4);
										adicionar_irmao($2,$6);
									}else if($4!=NULL && $6 == NULL){
										adicionar_irmao($2,$4);
										adicionar_irmao($2,no_base(NULL,"StatList",-1,-1));
									}else if($4==NULL && $6!= NULL){
										adicionar_irmao($2,no_base(NULL,"StatList",-1,-1));
										adicionar_irmao($2,$6);

									}else{
										adicionar_irmao($2,no_base(NULL,"StatList",-1,-1));
										adicionar_irmao($2,no_base(NULL,"StatList",-1,-1));
									}
									}
	| WHILE Expr DO Stat {$$=no_base(NULL,"While",@1.first_line,@1.first_column);temporaria=$$;temporaria->filho=$2;
							if($4!=NULL){
								adicionar_irmao($2,$4);
							}else{
								adicionar_irmao($2,no_base(NULL,"StatList",-1,-1));
							}
							}
	| REPEAT StatList UNTIL Expr {$$=no_base(NULL,"Repeat",-1,-1);
									if($2!=NULL){
										if($2->irmao!=NULL){
											temporaria=no_base(NULL,"StatList",-1,-1);
											temporaria->filho=$2;
											adicionar_irmao(temporaria,$4);
											$$->filho = temporaria;
										}else{
											$$->filho = $2;
											adicionar_irmao($2,$4);
										}

									}else{
										temporaria=no_base(NULL,"StatList",-1,-1);
										$$->filho = temporaria;
										adicionar_irmao(temporaria,$4);
									}
								}
	| VAL LBRAC PARAMSTR LBRAC Expr RBRAC COMMA ID RBRAC {$$=no_base(NULL,"ValParam",-1,-1);adicionar_irmao($5,no_base($8,"Id",@8.first_line,@8.first_column));temporaria=$$;temporaria->filho = $5;}
	| ID ASSIGN Expr {$$=no_base(NULL,"Assign",@2.first_line,@2.first_column);temporaria = no_base($1,"Id",@1.first_line,@1.first_column);adicionar_irmao(temporaria,$3);$$->filho = temporaria;}
	| WRITELN {$$=no_base(NULL,"WriteLn",@1.first_line,@1.first_column);}
	| WRITELN WritelnPList {$$=no_base(NULL,"WriteLn",@1.first_line,@1.first_column);$$->filho=$2;}
	|											{$$=NULL;}

WritelnPList:LBRAC opWrite1 repWrite2 RBRAC {adicionar_irmao($2,$3);$$=$2;}

opWrite1: Expr {$$=$1;}
		| STRING {$$=no_base($1,"String",@1.first_line,@1.first_column);}

repWrite2	:COMMA opWrite1 repWrite2 {adicionar_irmao($2,$3);$$=$2;}
			| 									{$$=NULL;}


Expr: simpleExpr {$$=$1;}
	| simpleExpr EQUAL simpleExpr {$$=no_base(NULL,"Eq",@2.first_line,@2.first_column);temporaria=$$;temporaria->filho=$1;adicionar_irmao($1,$3);}
	| simpleExpr DIFF simpleExpr {$$=no_base(NULL,"Neq",@2.first_line,@2.first_column);temporaria=$$;temporaria->filho=$1;adicionar_irmao($1,$3);}
	| simpleExpr LESS simpleExpr {$$=no_base(NULL,"Lt",@2.first_line,@2.first_column);temporaria=$$;temporaria->filho=$1;adicionar_irmao($1,$3);}
	| simpleExpr GREATER simpleExpr {$$=no_base(NULL,"Gt",@2.first_line,@2.first_column);temporaria=$$;temporaria->filho=$1;adicionar_irmao($1,$3);}
	| simpleExpr LESSE simpleExpr {$$=no_base(NULL,"Leq",@2.first_line,@2.first_column);temporaria=$$;temporaria->filho=$1;adicionar_irmao($1,$3);}
	| simpleExpr GREATERE simpleExpr {$$=no_base(NULL,"Geq",@2.first_line,@2.first_column);temporaria=$$;temporaria->filho=$1;adicionar_irmao($1,$3);}

simpleExpr: PLUS Term {$$=no_base(NULL,"Plus",@1.first_line,@1.first_column);$$->filho=$2;}
			| MINUS Term {$$=no_base(NULL,"Minus",@1.first_line,@1.first_column);$$->filho=$2;;}
			| Term {$$=$1;}
			| simpleExpr PLUS Term {$$=no_base(NULL,"Add",@2.first_line,@2.first_column);temporaria=$$;temporaria->filho=$1;adicionar_irmao($1,$3);}
			| simpleExpr MINUS Term {$$=no_base(NULL,"Sub",@2.first_line,@2.first_column);temporaria=$$;temporaria->filho=$1;adicionar_irmao($1,$3);}
			| simpleExpr OR Term {$$=no_base(NULL,"Or",@2.first_line,@2.first_column);temporaria=$$;temporaria->filho=$1;adicionar_irmao($1,$3);}


Term: Term AND Term {$$=no_base(NULL,"And",@2.first_line,@2.first_column);temporaria=$$;temporaria->filho=$1;adicionar_irmao($1,$3);}
	| Term TIMES Term {$$=no_base(NULL,"Mul",@2.first_line,@2.first_column);temporaria=$$;temporaria->filho=$1;adicionar_irmao($1,$3);}
	| Term DIVISION Term {$$=no_base(NULL,"RealDiv",@2.first_line,@2.first_column);temporaria=$$;temporaria->filho=$1;adicionar_irmao($1,$3);}
	| Term MOD Term {$$=no_base(NULL,"Mod",@2.first_line,@2.first_column);temporaria=$$;temporaria->filho=$1;adicionar_irmao($1,$3);}
	| Term DIV Term {$$=no_base(NULL,"Div",@2.first_line,@2.first_column);temporaria=$$;temporaria->filho=$1;adicionar_irmao($1,$3);}
	| NOT Term {$$=no_base(NULL,"Not",@1.first_line,@1.first_column);temporaria=$$;temporaria->filho=$2;}
	| LBRAC Expr RBRAC {$$=$2;}
	| INTLIT {$$=no_base($1,"IntLit",@1.first_line,@1.first_column);}
	| REALLIT {$$=no_base($1,"RealLit",@1.first_line,@1.first_column);}
	| ID ParamList {$$=no_base(NULL,"Call",-1,-1);temporaria=no_base($1,"Id",@1.first_line,@1.first_column);adicionar_irmao(temporaria,$2);$$->filho = temporaria;}
	| ID {$$=no_base($1,"Id",@1.first_line,@1.first_column);}



ParamList: LBRAC Expr repExpr RBRAC {$$=$2;
									 adicionar_irmao($2,$3);}
repExpr: COMMA Expr repExpr {$$=$2;
							 adicionar_irmao($2,$3);}
		| 					{$$=NULL;}
%%

int main(int argc, char* argv[]){
	int t = 0, s = 0, i;

	for(i=1; i < argc;i++){
		if(strcmp(argv[i],"-t")==0)
			t = 1;
		if(strcmp(argv[i],"-s")==0)
			s = 1;
	}

	if(t==1 && s == 0){
		yyparse();
		imprimir_arvore(raiz,0);
	}
	if(t==1 && s== 1){
		yyparse();
		criar_tabelas(raiz);
		imprimir_arvore(raiz,0);
		printf("\n");
		display_symbols();
	}
	if(s==1 && t == 0){
		
		yyparse();
		criar_tabelas(raiz);
		display_symbols();
	}
	if(s==0&&t==0){
		
		yyparse();
		criar_tabelas(raiz);
		codeGeneration(raiz,tab);
	}
    
   

	return 0;
}









