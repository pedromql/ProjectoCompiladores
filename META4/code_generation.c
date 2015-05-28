#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include "thirdfase.h"

void generator(Node *node,Table_structure *first_table){
	
	Node * aux_tree=node;
	Table_structure *aux_table=first_table;
	Table_lines *aux_data;


	if(aux_table != NULL){

		aux_table=aux_table->next->next;//esta na program symbol table 
		aux_data= aux_table->data;

		while(aux_data->type != '_function_')
		{

			printType(aux_data);
			aux_data=aux_data->next;






		}

		
		
	}


	
}






void printType(Table_lines * data){

	
	char* integer = "i32";
	char* real = "double";
	char* boolean = "i1";

	if(strcmp(data->type,"_integer_")==0){
		printf("@%s = global %s \n",data->name,integer);
	}
	

   	









}

/*char* checkType(arvore no,tabela_simbolos ts){
	
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
}*/














