%option case-insensitive
letra				[a-z]+
num 				[0-9]+


%{
	
%}

%%

{letra}								{printf("ID(%s)\n",yytext);}
{num}								{printf("INTLIT(%s)\n",yytext);}
{num}"."{num}(e[-/+]+{num})?		{printf("REALLIT(%s)\n",yytext);}
(("'")[^\n]*("'"))+					{printf("STRING(%s)\n",yytext);}




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

