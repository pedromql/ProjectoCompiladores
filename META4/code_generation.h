#include <stdlib.h>
#include <stdio.h>
#include <string.h>

typedef struct _strings {
	char * value;
	struct _strings * next;
} Strings;


void imprime_strings(Strings * );
void generator(Node *,Table_structure *);
void save_string(Strings * , char * );
void find_strings(Node * , Strings * );
void iterate_tree(Node *);
void vardecl_funtion(Node *);


void generator(Node *node,Table_structure *first_table){
	
	Node * aux_tree=node;
	Table_structure *aux_table=first_table;
	Table_lines *aux_data;
	aux_table=aux_table->next->next;//esta na program symbol table 

	Strings * saved_strings = (Strings *)malloc(sizeof(Strings));
	printf("\n\n");

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
			printf("\n");

			find_strings(aux_tree, saved_strings);
			imprime_strings(saved_strings);

			iterate_tree(aux_tree);			

		}

	}
	
}

void save_string(Strings * saved_strings, char * string) { //saves the latest found string in the last position
	
	Strings * temp = saved_strings;


	while (temp->next != NULL) { //iterate until last saved string
		temp = temp->next;
	}

	if (temp->value != NULL) {
		temp->next = (Strings *)malloc(sizeof(Strings));

		temp = temp->next;
	}

	temp->value = (char *)malloc(strlen(string)*sizeof(char));

	strcpy(temp->value, string+sizeof(char));
	temp->value[strlen(temp->value)-1] = '\0';

}

void find_strings(Node * node, Strings * saved_strings){

    if (node == NULL) return;
    
    
    if(strcmp(node->type,"String")==0)
    {
    	save_string(saved_strings, node->value);

    }

    find_strings(node->son, saved_strings);
    find_strings(node->brother, saved_strings);
}

void imprime_strings(Strings * saved_strings) {
	
	Strings * temp = saved_strings;

	while (temp != NULL) {
		printf("%s\\00\n", temp->value);
		temp = temp->next;
	}
}


void iterate_tree(Node * root) {
	Node * tree = root;

	tree = tree->son->brother; //set to varpart

	if (tree->son != NULL) {
		tree = tree->son;
		while(tree != NULL) {
			vardecl_funtion(tree);
		}
		
	}


}

void vardecl_funtion(Node * varpart) {
	Node * temp = varpart;
	int type = 0;

	temp = temp->son; //first id

	while (temp->brother != NULL) { //get to last id
		temp = temp->brother;
	}
	if (strcmp(temp->type,"integer") == 0) type = 0;
	else if (strcmp(temp->type,"real") == 0) type = 1;
	else if (strcmp(temp->type,"boolean") == 0) type = 2;

	temp = varpart->son; //first id

	while (temp->brother != NULL) {
		
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














