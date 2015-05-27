#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include "thirdfase.h"

void codeGeneration(arvore no,tabela_simbolos ts){
	arvore temp;
	if(no!=NULL){
		//TODO
		if(strcmp(no->tipo,"Program")==0){
			printf("define \n");
		}
		
		
		else if(strcmp(no->tipo,"VarDecl")==0){
			temp = no->filho;
			while(temp!=NULL){
				char* tipo = checkType(temp,ts);
				printf("@%s = %s \n", );
			}
		}

	}

	
}

char* checkType(arvore no,tabela_simbolos ts){
	tabela_simbolos tab_temp;
	tabela_elementos elem_temp = tab_temp->elemento;
	char* integer = "i32";
	char* real = "double";
	char* boolean = "i1";

	while(elem_temp!=NULL){
		if(strcmp(elem_temp->nome,no->tipo)==0){
			if(strcmp(elem_temp->tipo,"integer")==0){
				return integer;
			}
			if(strcmp(elem_temp->tipo,"real")){
				return real;
			}
			if(strcmp(elem_temp->tipo,"boolean")==0){
				return boolean;
			}
		}
	}
}