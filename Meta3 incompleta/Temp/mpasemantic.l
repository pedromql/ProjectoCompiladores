%option case-insensitive
%X TESTECOMENT

letra				[a-z]
num 				[0-9]+
reserved			"abs"|"arctan"|"array"|"case"|"char"|"chr"|"const"|"cos"|"dispose"|"downto"|"eof"|"eoln"|"exp"|"file"|"for"|"get"|"goto"|"in"|"input"|"label"|"ln"|"maxint"|"new"|"nil"|"odd"|"of"|"ord"|"pack"|"packed"|"page"|"pred"|"procedure"|"put"|"read"|"readln"|"record"|"reset"|"rewrite"|"round"|"set"|"sin"|"sqr"|"sqrt"|"succ"|"text"|"to"|"trunc"|"type"|"unpack"|"with"|"write"

%{
	
	#include "stdio.h"
	#include "y.tab.h"
	#include "string.h"
	unsigned long col = 1;
	unsigned long col_aux = 1;
	int line = 1;
	int line_aux = 1;
%}

%%
{reserved}							{col+=yyleng; return RESERVED; }
("(*")								{line_aux = line; col_aux = col; col+=2; BEGIN TESTECOMENT;}
("{")								{line_aux = line; col_aux = col; col++; BEGIN TESTECOMENT;}
<TESTECOMENT>("*)")					{BEGIN 0; col+=2;}
<TESTECOMENT>("}")					{BEGIN 0; col++;}
<TESTECOMENT>.						{col++;};
<TESTECOMENT>\n						{line++; col=1;};
<TESTECOMENT><<EOF>>				{printf("Line %d, col %lu: unterminated comment\n",line_aux,col_aux); return 0;};
"'"([^\n']|'')*(("''")|[<<EOF>>])*	{printf("Line %d, col %lu: unterminated string\n",line,col); col+=yyleng;}
":="								{col+=yyleng; 											return ASSIGN			;}
"begin"								{col+=yyleng; 											return BEG 				;}
"do"								{col+=yyleng; 											return DO 				;}
"else"								{col+=yyleng; 											return ELSE 			;}
"end"								{col+=yyleng; 											return END 				;}
"forward"							{col+=yyleng; 											return FORWARD 			;}
"function"							{col+=yyleng; 											return FUNCTION 		;}
"if"								{col+=yyleng; 											return IF 				;}
"not"								{col+=yyleng; 											return NOT 				;}
"output"							{col+=yyleng; 											return OUTPUT 			;}
"paramstr"							{col+=yyleng; 											return PARAMSTR 		;}
"program"							{col+=yyleng; 											return PROGRAM 			;}
"repeat"							{col+=yyleng; 											return REPEAT 			;}
"then"								{col+=yyleng; 											return THEN 			;}
"until"								{col+=yyleng; 											return UNTIL 			;} 
"val"								{col+=yyleng; 											return VAL 				;}
"var"								{col+=yyleng; 											return VAR 				;}
"while"								{col+=yyleng; 											return WHILE 			;}
"writeln"							{col+=yyleng; 											return WRITELN 			;}
";"|")"|"("|"."|","|":"				{col+=yyleng; 											return *yytext 			;}
"and"								{col+=yyleng; 											return AND 				;}
"or"								{col+=yyleng; 											return OR 				;}
"<="								{col+=yyleng; 											return LEQ 				;}
">="								{col+=yyleng; 											return GEQ 				;}
"<>"								{col+=yyleng; 											return NEQ 				;}
"="|"<"|">"							{col+=yyleng; 											return *yytext 				;}
"+"|"-"|"*"|"/"						{col+=yyleng; 											return *yytext 				;}							
"mod"								{col+=yyleng; 											return MOD				;}
"div"								{col+=yyleng; 											return DIV				;}
[a-z][a-z0-9]*						{col+=yyleng; yylval.str = (char*)strdup(yytext); 		return ID 				;}
{num}								{col+=yyleng; yylval.str = (char*)strdup(yytext); 		return INTLIT			;}
{num}("."{num})?(e[-+]?{num})?		{col+=yyleng; yylval.str = (char*)strdup(yytext); 		return REALLIT 			;}
"'"([^\n']|'')*"'"					{col+=yyleng; yylval.str = (char*)strdup(yytext); 		return STRING 			;}
" "|"\t"							{col+=yyleng; 																	 }	
.									{printf("Line %d, col %lu: illegal character ('%s')\n",line,col,yytext); col+=yyleng;};
\n 		{col = 1; line++;};
%%

int yywrap(){
	
	return 1;
}

