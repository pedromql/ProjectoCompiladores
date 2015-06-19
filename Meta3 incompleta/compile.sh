lex mpacompiler.l 
yacc -v -d mpacompiler.y 
cc -Wall -Wextra -g *.c *.h -ll -ly -g
zip mpacompiler.zip mpacompiler.l mpacompiler.y structures.h thirdfase.h 