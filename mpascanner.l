%option case-insensitive
letra				[a-z]+
num 				[0-9]+


%{
	
%}

%%

{letra}								{printf("ID(%s)\n",yytext);}
{num}								{printf("INTLIT(%s)\n",yytext);}
{num}"."{num}(e[-/+]+{num})?		{printf("REALLIT(%s)\n",yytext);}
"'"[^\n]*("'")+						{printf("STRING(%s)\n",yytext);}
":="								{printf("ASSIGN\n",yytext);}
"begin"								{printf("BEGIN\n",yytext);}
":"									{printf("COLON\n",yytext);}
","									{printf("COMMA\n",yytext);}
"do"								{printf("DO\n",yytext);}
"."									{printf("DOT\n",yytext);}
"else"								{printf("ELSE\n",yytext);}
"end"								{printf("END\n",yytext);}
"forward"							{printf("FORWARD\n",yytext);}
"function"							{printf("FUNCTION\n",yytext);}
"if"								{printf("IF\n",yytext);}
"("									{printf("LBRAC\n",yytext);}
"not"								{printf("NOT\n",yytext);}
"output"							{printf("OUTPUT\n",yytext);}
"paramstr"							{printf("PARAMSTR\n",yytext);}
"program"							{printf("PROGRAM\n",yytext);}
")"									{printf("RBRAC\n",yytext);}
"repeat"							{printf("REPEAT\n",yytext);}
";"									{printf("SEMIC\n",yytext);}
"then"								{printf("THEN\n",yytext);}
"until"								{printf("UNTIL\n",yytext);}
"val"								{printf("VAL\n",yytext);}
"var"								{printf("VAR\n",yytext);}
"while"								{printf("WHILE\n",yytext);}
"writeln"							{printf("WRITELN\n",yytext);}




["and" | "or"]									{printf("OP1\n",yytext);}
["<" | ">" | "=" | "<>" | "<=" | ">="]			{printf("OP2\n",yytext);}
["+" | "-"]										{printf("OP3\n",yytext);}
["*" | "/" | "mod" | "div" ]					{printf("OP4\n",yytext);}








.		;
\n 		;
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

