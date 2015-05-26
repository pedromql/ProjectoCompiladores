all: mpasemantic.zip mpasemantic

mpasemantic.zip: mpasemantic.y mpasemantic.l structures.h thirdfase.h
	zip mpasemantic.zip mpasemantic.y mpasemantic.l structures.h thirdfase.h

mpasemantic: lex.yy.c y.tab.c structures.h thirdfase.h
	gcc -g -o mpasemantic y.tab.c lex.yy.c -ll -ly

y.tab.c: mpasemantic.y
	yacc -v -o y.tab.c -d mpasemantic.y

lex.yy.c: mpasemantic.l
	lex -o lex.yy.c mpasemantic.l
