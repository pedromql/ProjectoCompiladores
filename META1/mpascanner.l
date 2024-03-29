%option case-insensitive

letra				[a-z]
num 				[0-9]+
reserved			"abs"|"arctan"|"array"|"case"|"char"|"chr"|"const"|"cos"|"dispose"|"downto"|"eof"|"eoln"|"exp"|"file"|"for"|"get"|"goto"|"in"|"input"|"label"|"ln"|"maxint"|"new"|"nil"|"odd"|"of"|"ord"|"pack"|"packed"|"page"|"pred"|"procedure"|"put"|"read"|"readln"|"record"|"reset"|"rewrite"|"round"|"set"|"sin"|"sqr"|"sqrt"|"succ"|"text"|"to"|"trunc"|"type"|"unpack"|"with"|"write"

      
%X TESTECOMENT


%{
	unsigned long col = 1;
	unsigned long col_aux = 1;
	int line = 1;
	int line_aux = 1;
%}

%%
("(*")						{line_aux = line; col_aux = col; col+=2; BEGIN TESTECOMENT;}
("{")						{line_aux = line; col_aux = col; col++; BEGIN TESTECOMENT;}
<TESTECOMENT>("*)")			{BEGIN 0; col+=2;}
<TESTECOMENT>("}")			{BEGIN 0; col++;}
<TESTECOMENT>.				{col++;};
<TESTECOMENT>\n				{line++; col=1;};
<TESTECOMENT><<EOF>>		{printf("Line %d, col %lu: unterminated comment\n",line_aux,col_aux); return 0;};

{num}								{col+=yyleng; printf("INTLIT(%s)\n",yytext);}
{num}("."{num})?(e[-+]?{num})?		{col+=yyleng; printf("REALLIT(%s)\n",yytext);}
"'"([^\n']|'')*"'"					{col+=yyleng; printf("STRING(%s)\n",yytext);}
"'"([^\n']|'')*(("''")|[<<EOF>>])*				{printf("Line %d, col %lu: unterminated string\n",line,col); col+=yyleng;}
":="								{col+=yyleng; printf("ASSIGN\n");}
"begin"								{col+=yyleng; printf("BEGIN\n");}
":"									{col+=yyleng; printf("COLON\n");}
","									{col+=yyleng; printf("COMMA\n");}
"do"								{col+=yyleng; printf("DO\n");}
"."									{col+=yyleng; printf("DOT\n");}
"else"								{col+=yyleng; printf("ELSE\n");}
"end"								{col+=yyleng; printf("END\n");}
"forward"							{col+=yyleng; printf("FORWARD\n");}
"function"							{col+=yyleng; printf("FUNCTION\n");}
"if"								{col+=yyleng; printf("IF\n");}
"("									{col+=yyleng; printf("LBRAC\n");}
"not"								{col+=yyleng; printf("NOT\n");}
"output"							{col+=yyleng; printf("OUTPUT\n");}
"paramstr"							{col+=yyleng; printf("PARAMSTR\n");}
"program"							{col+=yyleng; printf("PROGRAM\n");}
")"									{col+=yyleng; printf("RBRAC\n");}
"repeat"							{col+=yyleng; printf("REPEAT\n");}
";"									{col+=yyleng; printf("SEMIC\n");}
"then"								{col+=yyleng; printf("THEN\n");}
"until"								{col+=yyleng; printf("UNTIL\n");}
"val"								{col+=yyleng; printf("VAL\n");}
"var"								{col+=yyleng; printf("VAR\n");}
"while"								{col+=yyleng; printf("WHILE\n");}
"writeln"							{col+=yyleng; printf("WRITELN\n");}

{reserved}							{col+=yyleng; printf("RESERVED(%s)\n",yytext);}


"and"|"or"									{col+=yyleng; printf("OP1(%s)\n",yytext);}
"<"|">"|"="|"<>"|"<="|">="					{col+=yyleng; printf("OP2(%s)\n",yytext);}
"+"|"-"										{col+=yyleng; printf("OP3(%s)\n",yytext);}
"*"|"/"|"mod"|"div"							{col+=yyleng; printf("OP4(%s)\n",yytext);}

[a-z][a-z0-9]*					{col+=yyleng; printf("ID(%s)\n",yytext);}


" "|"\t"		{col+=yyleng;}	
.		{printf("Line %d, col %lu: illegal character ('%s')\n",line,col,yytext); col+=yyleng;};
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

