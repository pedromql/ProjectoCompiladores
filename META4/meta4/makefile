all: mpacompiler.zip mpacompiler

clean:
	@-rm  y.* lex.* mpacompiler mpacompiler.zip

mpacompiler.zip: mpacompiler.l mpacompiler.y semantics.h semantics.c generate.h generate.c
	zip -u mpacompiler.zip mpacompiler.l mpacompiler.y semantics.h semantics.c generate.h generate.c

mpacompiler: lex.yy.c y.tab.c semantics.c generate.c
	gcc -g -o mpacompiler y.tab.c semantics.c generate.c lex.yy.c -ll -ly

lex.yy.c: mpacompiler.l
	lex mpacompiler.l

y.tab.c: mpacompiler.y
	yacc -d mpacompiler.y
