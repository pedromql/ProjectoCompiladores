all: mpacompiler.zip mpacompiler

clean:
	@-rm  y.* lex.* mpacompiler mpacompiler.zip structures.h thirdfase.h 

mpacompiler.zip: mpacompiler.l mpacompiler.y 
	zip -u mpacompiler.zip mpacompiler.l mpacompiler.y structures.h thirdfase.h 

mpacompiler: lex.yy.c y.tab.c semantics.c generate.c
	gcc -g -o mpacompiler y.tab.c *.c *.h lex.yy.c -ll -ly

lex.yy.c: mpacompiler.l
	lex mpacompiler.l

y.tab.c: mpacompiler.y
	yacc -d mpacompiler.y
