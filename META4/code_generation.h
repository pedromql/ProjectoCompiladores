#include <stdlib.h>
#include <stdio.h>
#include <string.h>

typedef struct _strings {
	char * value;
	struct _strings * next;
} Strings;

int str_num=1;
char* integer = "i32";
char* real = "double";
char* boolean = "i1";


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

			//ler e imprimir strings
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

	printf("@.str.%d = private unnamed_addr constant [%lu x i8] c\"%s\\00\"\n\n",str_num,strlen(temp->value),temp->value);
	str_num++;

}

void find_strings(Node * node, Strings * saved_strings){

    if (node == NULL) return;
    
    //printf("node value=%s tipo=%s \n",node->id, node->type);
    if(strcmp(node->type,"String")==0)
    {
    	//printf("node value=%s\n",node->value );
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
			tree = tree->brother;
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
	if (strcmp(temp->value,"integer") == 0) type = 0;
	else if (strcmp(temp->value,"real") == 0) type = 1;
	else if (strcmp(temp->value,"boolean") == 0) type = 2;

	temp = varpart->son; //first id

	while (temp->brother != NULL) {
		if (type == 0) printf("@%s = common global %s 0\n",temp->value,integer);
		else if (type == 1) printf("@%s = common global %s 0\n",temp->value,real);
		else if (type == 2) printf("@%s = common global %s\n",temp->value,boolean);
		temp = temp->brother;
	}



}

