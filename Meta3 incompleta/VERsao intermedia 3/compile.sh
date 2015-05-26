lex mpasemantic.l 
yacc -v -d mpasemantic.y 
cc -Wall -Wextra -g *.c *.h -ll -ly -g
zip mpasemantic.zip mpasemantic.l mpasemantic.y structures.h thirdfase.h 