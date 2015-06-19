#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include "structures.h"
#include "thirdfase.h"



void printType(Table_lines * data){

	Table_lines *aux=data;
	char* integer = "i32";
	char* real = "double";
	char* boolean = "i1";
	
	if(aux!=NULL)
	{


		if(strcmp(aux->type,"_integer_")==0){
			printf("@%s = global %s \n",aux->name,integer);

	}

	}
}


void generator(Node *node,Table_structure *first_table){
	
	Node * aux_tree=node;
	Table_structure *aux_table=first_table;
	Table_lines *aux_data;
	aux_table=aux_table->next->next;//esta na program symbol table 

	if(aux_table != NULL)
	{

		
		
		if(aux_data->next!=NULL)
			aux_data= aux_table->data;

		while(strcmp(aux_data->type,'_function_')!=0)
		{

			printType(aux_data);
			
			if(aux_data->next!=NULL)
				aux_data=aux_data->next;
			printf("oi\n");
		}
		
		if(strcmp(aux_data->type,'_function_') == 0)
			printf("oi\n");

		
		
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














