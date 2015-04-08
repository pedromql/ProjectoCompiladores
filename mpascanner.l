%option case-insensitive
letra				[a-z]
num 				[0-9]+
reserved			"abs"|"arctan"|"array"|"case"|"char"|"chr"|"const"|"cos"|"dispose"|"downto"|"eof"|"eoln"|"exp"|"file"|"for"|"get"|"goto"|"in"|"input"|"label"|"ln"|"maxint"|"new"|"nil"|"odd"|"of"|"ord"|"pack"|"packed"|"page"|"pred"|"procedure"|"put"|"read"|"readln"|"record"|"reset"|"rewrite"|"round"|"set"|"sin"|"sqr"|"sqrt"|"succ"|"text"|"to"|"trunc"|"type"|"unpack"|"with"|"write"

      
%X TESTECOMENT


%{
	#include "y.tab.h"
	unsigned long col = 1;
	unsigned long col_aux = 1;
	int line = 1;
	int line_aux = 1;
%}

%%
("(*")							{line_aux = line; col_aux = col; col+=2; BEGIN TESTECOMENT;}
("{")							{line_aux = line; col_aux = col; col++; BEGIN TESTECOMENT;}
<TESTECOMENT>("*)")				{BEGIN 0; col+=2;}
<TESTECOMENT>("}")				{BEGIN 0; col++;}
<TESTECOMENT>.					{col++;};
<TESTECOMENT>\n					{line++; col=1;};
<TESTECOMENT><<EOF>>			{/*printf("Line %d, col %lu: unterminated comment\n",line_aux,col_aux);*/ return 0;};
"'"([^\n']|'')*(("''")|[<<EOF>>])*		{/*printf("Line %d, col %lu: unterminated string\n",line,col);*/ col+=yyleng;}
":="							{col+=yyleng; return ASSIGN;}
"begin"							{col+=yyleng; return BEGIN;}
":"								{col+=yyleng; return COLON;}
","								{col+=yyleng; return COMMA;}
"do"							{col+=yyleng; return DO;}
"."								{col+=yyleng; return DOT;}
"else"							{col+=yyleng; return ELSE;}
"end"							{col+=yyleng; return END;}
"forward"						{col+=yyleng; return FORWARD;}
"function"						{col+=yyleng; return FUNCTION;}
"if"							{col+=yyleng; return IF;}
"("								{col+=yyleng; return LBRAC;}
"not"							{col+=yyleng; return NOT;}
"output"						{col+=yyleng; return OUTPUT;}
"paramstr"						{col+=yyleng; return PARAMSTR;}
"program"						{col+=yyleng; return PROGRAM;}
")"								{col+=yyleng; return RBRAC;}
"repeat"						{col+=yyleng; return REPEAT;}
";"								{col+=yyleng; return SEMIC;}
"then"							{col+=yyleng; return THEN;}
"until"							{col+=yyleng; return UNTIL;} 
"val"							{col+=yyleng; return VAL;}
"var"							{col+=yyleng; return VAR;}
"while"							{col+=yyleng; return WHILE;}
"writeln"						{col+=yyleng; return WRITELN;}
"and"							{col+=yyleng; return AND;}
"or"							{col+=yyleng; return OR;}
"<"|">"|"="|"+"|"-"				{col+=yyleng; return *yytext;}
"<="							{col+=yyleng; return LESSEQ;} /*less or equal*/
">="							{col+=yyleng; return GREATEQ;}
"<>"							{col+=yyleng; return LESSREAT;}
"*"|"/"|"mod"|"div"				{col+=yyleng; return yytext;}
[a-z][a-z0-9]*						{col+=yyleng; yylval.id=(char*)strdup(yytext);  return ID;}
{num}								{col+=yyleng; yylval.value=atoi(yytext); return INTLIT;}
{num}("."{num})?(e[-+]?{num})?		{col+=yyleng; yylval.id=(char*)strdup(yytext); return REALLIT;}
"'"([^\n']|'')*"'"					{col+=yyleng; yylval.id=(char*)strdup(yytext); return STRING;}
{reserved}							{col+=yyleng;  }
" "|"\t"							{col+=yyleng;}	
.									{/*printf("Line %d, col %lu: illegal character ('%s')\n",line,col,yytext);*/ col+=yyleng;};
\n 		{col = 1; line++;};
%%

int main()
{
	yylex();
	return 0;

}

int yywrap()
{
	return 1;
}

