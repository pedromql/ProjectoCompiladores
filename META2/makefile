all: mpaparser.zip mpaparser

mpaparser.zip: mpaparser.y mpaparser.l structures.h
	zip mpaparser.zip mpaparser.y mpaparser.l structures.h

mpaparser: lex.yy.c y.tab.c structures.h
	gcc -g -o mpaparser y.tab.c lex.yy.c -ll -ly

y.tab.c: mpaparser.y
	yacc -v -o y.tab.c -d mpaparser.y

lex.yy.c: mpaparser.l
	lex -o lex.yy.c mpaparser.l
