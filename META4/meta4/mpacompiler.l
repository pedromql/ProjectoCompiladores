%option case-insensitive
%option yylineno

 
exp		"e"[+-]?([0-9]+)
 
%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "y.tab.h"


int charcount=1;
int linecount=1;
int charAux = 1;
int lineAux = 1;
int aux_charcount=1;
int aux_linecount=1;
char buf[1024];

#define YY_USER_ACTION yylloc.first_line = yylloc.last_line = yylineno; yylloc.first_column = charAux; yylloc.last_column = charAux+yyleng-1; charAux += yyleng;

%}
 

REALLIT ([0-9]+)(("."[0-9]+{exp}?)|({exp}))
INTLIT [0-9]+
STRING "'"([^\n']|'')*"'"	
STRING1 "'"([^\n']|'')*""
ASSIGN (":=")
BEGIN_ (begin)
COLON (":")
COMMA (",")
AND (and)
OR (or)
DO (do)
DOT (".")
ELSE (else)
END (end)
FORWARD (forward)
FUNCTION (function)
IF (if)
LBRAC ("(")
NOT (not)
OUTPUT (output)
PARAMSTR (paramstr)
PROGRAM (program)
RBRAC (")")
REPEAT (repeat)
SEMIC (";")
THEN (then)
UNTIL (until)
VAL (val)
VAR (var)
WHILE (while)
WRITELN (writeln)
TIMES ("*")
DIVISION ("/") 
MOD ("mod")
DIV ("div")
PLUS ("+")
MINUS ("-")
LESS ("<")
GREATER (">")
EQUAL ("=")
DIFF ("<>")
LESSE ("<=")
GREATERE (">=")
RESERVED (abs)|(arctan)|(array)|(case)|(char)|(chr)|(const)|(cos)|(dispose)|(downto)|(eof)|(eoln)|(exp)|(file)|(for)|(get)|(goto)|(in)|(input)|(label)|(ln)|(maxint)|(new)|(nil)|(odd)|(of)|(ord)|(pack)|(packed)|(page)|(pred)|(procedure)|(put)|(read)|(readln)|(record)|(reset)|(rewrite)|(round)|(set)|(sin)|(sqr)|(sqrt)|(succ)|(text)|(to)|(trunc)|(type)|(unpack)|(with)|(write)
ID [a-z][a-z0-9]*
DELIM [ \t]
NEWLINE [\n]
  
 

%X TESTECOMMENT
 
 
%%
{REALLIT}	{ yylval.str=(char*)strdup(yytext);return REALLIT;}
{INTLIT} 	{ yylval.str=(char*)strdup(yytext);return INTLIT;}
{STRING} 	{ yylval.str=(char*)strdup(yytext);return STRING;}
{STRING1} 	{printf("Line %d, col %d: unterminated string\n",yylineno,charcount);return STRING1;}
{ASSIGN} 	{return ASSIGN;}
{BEGIN_} 	{return BEGIN_;}
{COLON} 	{return COLON;}
{COMMA} 	{return COMMA;}
{DO} 		{return DO;}
{DOT} 		{return DOT;}
{ELSE} 		{return ELSE;}
{END} 		{return END;}
{FORWARD} 	{return FORWARD;}
{FUNCTION} 	{return FUNCTION;}
{IF} 		{return IF;}
{LBRAC} 	{return LBRAC;}
{NOT} 		{return NOT;}
{AND} 		{return AND;}
{OR} 		{return OR;} 
{OUTPUT} 	{return OUTPUT;}
{PARAMSTR} 	{return PARAMSTR;}
{PROGRAM} 	{return PROGRAM;}
{RBRAC} 	{return RBRAC;}
{REPEAT} 	{return REPEAT;}
{SEMIC} 	{return SEMIC;}
{THEN} 		{return THEN;}
{UNTIL} 	{return UNTIL;}
{VAL} 		{return VAL;}
{VAR} 		{return VAR;}
{WHILE} 	{return WHILE;}
{WRITELN} 	{return WRITELN;}
{RESERVED} 	{return RESERVED;}
{DELIM} 	{}
{TIMES} 	{return TIMES;}
{DIVISION} 	{return DIVISION;}
{MOD} 		{return MOD;}
{DIV} 		{return DIV;}
{ID} 		{yylval.str=(char*)strdup(yytext);return ID;}
{PLUS} 		{return PLUS;}
{MINUS} 	{return MINUS;}
{LESS} 		{return LESS;}
{GREATER} 	{return GREATER;}
{EQUAL} 	{return EQUAL;}
{DIFF} 		{return DIFF;}
{LESSE} 	{return LESSE;}
{GREATERE} 	{return GREATERE;}
{NEWLINE} 	{charAux = 1;}

 

("(*") {aux_linecount = yylineno;charAux = charcount; aux_charcount = charcount; charcount+=2; BEGIN TESTECOMMENT;}
("{") {aux_linecount = yylineno;charAux = charcount; aux_charcount = charcount; charcount++; BEGIN TESTECOMMENT;}
<TESTECOMMENT>("*)") {BEGIN 0;charAux = charcount; charcount+=2;}
<TESTECOMMENT>("}") {BEGIN 0;charAux = charcount; charcount++;}
<TESTECOMMENT>. {charAux = charcount;charcount++;};
<TESTECOMMENT>\n {lineAux = linecount;linecount++;charcount=1;};
<TESTECOMMENT><<EOF>> {printf("Line %d, col %d: unterminated comment\n",aux_linecount,aux_charcount);lineAux = linecount;charAux = charcount; return 0;}
 
 
. {printf("Line %d, col %d: illegal character ('%s')\n",yylineno,charcount,yytext);charAux = charcount;charcount++;}
%%
void yyerror (char *s){
        printf ("Line %d, col %lu: %s: %s\n", yylineno,charcount-strlen(yytext),s,yytext);
	exit(0);
}

int yywrap()
{
return 1;
}
