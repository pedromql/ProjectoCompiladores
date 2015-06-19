all: mpasemantic.zip mpasemantic

clean:
	@-rm y.* lex.* mpasemantic mpasemantic.zip

mpasemantic.zip: mpasemantic.l mpasemantic.y structures.h thirdfase.h
	zip -u mpasemantic.zip mpasemantic.l mpasemantic.y structures.h thirdfase.h

mpasemantic: lex.yy.c y.tab.c structures.h thirdfase.h
	gcc -g -Wall -o mpasemantic y.tab.c lex.yy.c -ll -ly

lex.yy.c: mpasemantic.l
	lex mpasemantic.l

y.tab.c: mpasemantic.y
	yacc -d mpasemantic.y
