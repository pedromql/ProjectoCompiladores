#include <stdlib.h>
#include <stdio.h>
#include <string.h>


void generator(Node *node,Table_structure *first_table){
	
	Node * aux_tree=node;
	Table_structure *aux_table=first_table;
	Table_lines *aux_data;
	aux_table=aux_table->next->next;//esta na program symbol table 

	if(aux_tree != NULL)
	{
		if(strcmp(aux_tree->id,"Program")==0)
		{
			printf("@.strNewLine = private unnamed_addr constant [2 x i8] c\"\\0A\\00\"\n"); 
			printf("@.strInt = private unnamed_addr constant [3 x i8] c\"%%d\\00\"\n"); 
			printf("@.strDouble = private unnamed_addr constant [6 x i8] c\"%%.12F\\00\"\n"); 
			printf("@.str = private unnamed_addr constant [3 x i8] c\"%%s\\00\"\n"); 
			printf("@.strTrue = private unnamed_addr constant [5 x i8] c\"TRUE\\00\"\n"); 
			printf("@.strFalse = private unnamed_addr constant [6 x i8] c\"FALSE\\00\"\n"); 
			printf("\n"); 
			printf("declare i32 @printf(i8*, ...)\n"); 
			printf("\n");''

			find_strings();

		}

	}
	
}

void find_strings(Node * node,int level){

    int i;
    if (node == NULL) return;
    for (i = 0; i < level; i++) {
        
    }
    
    printf("%s\n",node->id);
    if(strcmp(node->type,"String")==0)
    {






    }

    printAll(node->son,level+1);
    printAll(node->brother,level);
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














