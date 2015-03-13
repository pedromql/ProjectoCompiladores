%option case-insensitive
letra				[a-z]
num 				[0-9]+
reserved			"abs"|"arctan"|"array"|"case"|"char"|"chr"|"const"|"cos"|"dispose"|"downto"|"eof"|"eoln"|"exp"|"file"|"for"|"get"|"goto"|"in"|"input"|"label"|"ln"|"maxint"|"new"|"nil"|"odd"|"of"|"ord"|"pack"|"packed"|"page"|"pred"|"procedure"|"put"|"read"|"readln"|"record"|"reset"|"rewrite"|"round"|"set"|"sin"|"sqr"|"sqrt"|"succ"|"text"|"to"|"trunc"|"type"|"unpack"|"with"|"write"

      
%X TESTECOMENT

%%

(("(*"|"{")[^\n]+)			{BEGIN TESTECOMENT;}
<TESTECOMENT>("}"|"*)").     ;
<TESTECOMENT>0			{BEGIN 0; printf("cona");}

{num}								{printf("INTLIT(%s)\n",yytext);}
{num}("."{num})?(e[-/+]?{num})?		{printf("REALLIT(%s)\n",yytext);}
"'"([^\n|']|'')*"'"					{printf("STRING(%s)\n",yytext);}

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

{reserved}							{printf("RESERVED(%s)\n",yytext);}


"and"|"or"									{printf("OP1(%s)\n",yytext);}
"<"|">"|"="|"<>"|"<="|">="					{printf("OP2(%s)\n",yytext);}
"+"|"-"										{printf("OP3(%s)\n",yytext);}
"*"|"/"|"mod"|"div"							{printf("OP4(%s)\n",yytext);}


{letra}({letra}|{num})*					{printf("ID(%s)\n",yytext);}







.		;
\n 		;
%%



int main()
{
	yylex();
	return 0;
	/*<TESTECOMENT>[^\n]+")".				{BEGIN 0; printf("Line %d, col %d: unterminated string\n",yylineno,(int)yyleng); }
{ BEGIN TESTECOMENT; }    		
<TESTECOMENT>[^\n]+("}"|"*)")		; 
*/
}

int yywrap()
{
	return 1;
}

