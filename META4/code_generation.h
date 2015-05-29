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

	printf("temp-next=%s\n",temp->value);

	strcpy(temp->value, string);

}

void find_strings(Node * node, Strings * saved_strings){

    if (node == NULL) return;
    
    //printf("node value=%s tipo=%s \n",node->id, node->type);
    
    if(strcmp(node->type,"String")==0)
    {
    	printf("node value=%s\n",node->value );
    	printf("@.str.%d = private unnamed_addr constant [%lu x i8] c\"%s\"\n\n",str_count,strlen(raiz->valor),raiz->valor);
		
    	save_string(saved_strings, node->value);
    	
    }

    find_strings(node->son, saved_strings);
    find_strings(node->brother, saved_strings);
}

void imprime_strings(Strings * saved_strings) {
	
	Strings * temp = saved_strings;

	while (temp->next != NULL) {
		printf("%s\n", temp->value);
		temp = temp->next;
	}
}







