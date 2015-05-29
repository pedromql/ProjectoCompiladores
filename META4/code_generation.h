#include <stdlib.h>
#include <stdio.h>
#include <string.h>

typedef struct _strings {
	char * value;
	struct _stringss * next;
} Strings;


void generator(Node *node,Table_structure *first_table){
	
	Node * aux_tree=node;
	Table_structure *aux_table=first_table;
	Table_lines *aux_data;
	aux_table=aux_table->next->next;//esta na program symbol table 

	Strings * saved_strings = (Strings *)malloc(sizeof(Strings));

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

			find_strings(aux, saved_strings);
			imprime_strings(saved_strings);

		}

	}
	
}

void save_string(Strings * saved_strings, char * string) { //saves the latest found string in the last position
	Strings * temp = saved_strings;

	while (temp->next != NULL) { //iterate until last saved string
		temp = temp->next;
	}

	temp->next = (Strings *)malloc(sizeof(Strings));

	temp = temp->next;

	strcpy(temp->value, string);

}

void find_strings(Node * node, Strings * saved_strings){

    if (node == NULL) return;
    
    
    printf("%s\n",node->id);
    if(strcmp(node->type,"String")==0)
    {
    	save_string(saved_strings, node->value);

    }

    find_strings(node->son, saved_strings);
    find_strings(node->brother, saved_strings);
}

void imprime_strings(Strings * saved_strings) {
	Strings * temp = saved_strings;

	while (temp->next != NULL) {
		printf("%s\n", temp);
		temp = temp->next;
	}
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














