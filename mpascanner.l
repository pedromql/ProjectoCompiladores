%option case-insensitive
letra				[a-z]
num 				[0-9]+


%{
	
%}

%%

{letra}{num}						{printf("ID(%s)\n",yytext);}
{num}								{printf("INTLIT(%s)\n",yytext);}
{num}"."{num}(e[-/+]+{num})?		{printf("REALLIT(%s)\n",yytext);}
"'"[^\n]*("'")+						{printf("STRING(%s)\n",yytext);}
":="								{printf("ASSIGN\n");}
"begin"								{printf("BEGIN\n");}
":"									{printf("COLON\n");}
","									{printf("COMMA\n");}
"do"								{printf("DO\n");}
"."									{printf("DOT\n");}
"else"								{printf("ELSE\n");}
"end"								{printf("END\n");}
"forward"							{printf("FORWARD\n");}
"function"							{printf("FUNCTION\n");}
"if"								{printf("IF\n");}
"("									{printf("LBRAC\n");}
"not"								{printf("NOT\n");}
"output"							{printf("OUTPUT\n");}
"paramstr"							{printf("PARAMSTR\n");}
"program"							{printf("PROGRAM\n");}
")"									{printf("RBRAC\n");}
"repeat"							{printf("REPEAT\n");}
";"									{printf("SEMIC\n");}
"then"								{printf("THEN\n");}
"until"								{printf("UNTIL\n");}
"val"								{printf("VAL\n");}
"var"								{printf("VAR\n");}
"while"								{printf("WHILE\n");}
"writeln"							{printf("WRITELN\n");}




["and" | "or"]									{printf("OP1\n");}
["<" | ">" | "=" | "<>" | "<=" | ">="]			{printf("OP2\n");}
["+" | "-"]										{printf("OP3\n");}
["*" | "/" | "mod" | "div" ]					{printf("OP4\n");}








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

