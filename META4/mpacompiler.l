
%option case-insensitive
%X TESTECOMENT

letra				[a-z]
num 				[0-9]+
reserved			"abs"|"arctan"|"array"|"case"|"char"|"chr"|"const"|"cos"|"dispose"|"downto"|"eof"|"eoln"|"exp"|"file"|"for"|"get"|"goto"|"in"|"input"|"label"|"ln"|"maxint"|"new"|"nil"|"odd"|"of"|"ord"|"pack"|"packed"|"page"|"pred"|"procedure"|"put"|"read"|"readln"|"record"|"reset"|"rewrite"|"round"|"set"|"sin"|"sqr"|"sqrt"|"succ"|"text"|"to"|"trunc"|"type"|"unpack"|"with"|"write"

%{
	
	#include "stdio.h"
	#include "y.tab.h"
	#include "string.h"

	#define YY_USER_ACTION yylloc.first_line = yylloc.last_line = line; yylloc.first_column = col; yylloc.last_column = col+yyleng-1; col += yyleng;


	unsigned long col = 1;
	unsigned long col_aux = 1;
	int line = 1;
	int line_aux = 1;
%}

%%
{reserved}							{ return RESERVED; }
("(*")								{line_aux = line; col_aux = col; BEGIN TESTECOMENT;}
("{")								{line_aux = line; col_aux = col; BEGIN TESTECOMENT;}
<TESTECOMENT>("*)")					{BEGIN 0; }
<TESTECOMENT>("}")					{BEGIN 0; }
<TESTECOMENT>.						{};
<TESTECOMENT>\n						{line++; col=1;};
<TESTECOMENT><<EOF>>				{printf("Line %d, col %lu: unterminated comment\n",line_aux,col_aux); return 0;};

"'"([^\n']|'')*(("''")|[<<EOF>>])*	{printf("Line %d, col %d: unterminated string\n",line,yylloc.first_column);}
":="								{ 											return ASSIGN			;}
"begin"								{ 											return BEG 				;}
"do"								{ 											return DO 				;}
"else"								{ 											return ELSE 			;}
"end"								{ 											return END 				;}
"forward"							{ 											return FORWARD 			;}
"function"							{ 											return FUNCTION 		;}
"if"								{ 											return IF 				;}
"not"								{ 											return NOT 				;}
"output"							{ 											return OUTPUT 			;}
"paramstr"							{ 											return PARAMSTR 		;}
"program"							{ 											return PROGRAM 			;}
"repeat"							{ 											return REPEAT 			;}
"then"								{ 											return THEN 			;}
"until"								{ 											return UNTIL 			;} 
"val"								{ 											return VAL 				;}
"var"								{ 											return VAR 				;}
"while"								{ 											return WHILE 			;}
"writeln"							{ 											return WRITELN 			;}
";"|")"|"("|"."|","|":"				{ 											return *yytext 			;}
"and"								{ 											return AND 				;}
"or"								{ 											return OR 				;}
"<="								{ 											return LEQ 				;}
">="								{ 											return GEQ 				;}
"<>"								{ 											return NEQ 				;}
"="|"<"|">"							{ 											return *yytext 			;}
"+"|"-"|"*"|"/"						{ 											return *yytext 			;}							
"mod"								{ 											return MOD				;}
"div"								{ 											return DIV				;}
[a-z][a-z0-9]*						{ yylval.u_col=col;  yylval.str = (char*)strdup(yytext); 		return ID 				;}
{num}								{ yylval.str = (char*)strdup(yytext); 		return INTLIT			;}
{num}("."{num})?(e[-+]?{num})?		{ yylval.str = (char*)strdup(yytext); 		return REALLIT 			;}
"'"([^\n']|'')*"'"					{ yylval.str = (char*)strdup(yytext); 		return STRING 			;}
" "|"\t"							{ 																	 }	
.									{printf("Line %d, col %d: illegal character ('%s')\n",line,yylloc.first_column,yytext); };
\n 		{col = 1; line++;};
%%

int yywrap(){
	
	return 1;
}
