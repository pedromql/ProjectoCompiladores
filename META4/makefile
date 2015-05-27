all: mpacompiler.zip mpacompiler

clean:
	@-rm y.* lex.* mpacompiler mpacompiler.zip

mpacompiler.zip: mpacompiler.l mpacompiler.y structures.h thirdfase.h
	zip -u mpacompiler.zip mpacompiler.l mpacompiler.y structures.h thirdfase.h

mpacompiler: lex.yy.c y.tab.c structures.h thirdfase.h
	gcc -g -Wall -o mpacompiler y.tab.c lex.yy.c -ll -ly

lex.yy.c: mpacompiler.l
	lex mpacompiler.l

y.tab.c: mpacompiler.y
	yacc -d mpacompiler.y
