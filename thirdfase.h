#include <stdlib.h>
#include <stdio.h>
#include "structures.h"



//-------------------------------- tabelas
typedef struct _tablestructure 	Table_structure;
typedef struct _tablelines 		Table_lines;

//dados especificos da tabela
typedef struct _tablestructure{
	//proxima tabela
    Table_structure * next;
  
    char *table_name;
    //linhas da tabela
    Table_lines * data;
    
};

//campo generico das tabelas, corresponde a uma linha
typedef struct _tablelines{
    char * name;
    char * type;
    char * value;
    char * flag;
    Table_lines *next; // proxima linha da tabela
};

//mais simplificado
char *tables_name[] = {"===== Outer Symbol Table =====", "===== Function Symbol Table =====", "===== Program Symbol Table ====="};
char *name[] = {"boolean", "integer", "real", "false", "true", "paramcount", "program"};
char *type[] = {"_type_", "_boolean_", "_function_", "_program_", "_integer_", "_real_"};
char *flag[] = {"return", "param", "varparam", "constant"};
char *value[] = {"_boolean_", "_integer_", "_real_", "_true_", "_false_"};


//enumerar as tabelas a cima para referencias
enum{
	//indices tabelas
	outer_table=0;
	function_table=1;
	program_table=2;

	//nomes
	name_boolean=0;
	name_integer=1;
	name_real=2;
	name_false=3;
	name_true=4;
	name_paramcount=5;
	name_program=6;

	//indice tipos
	type_type=0;
	type_boolean=1;
	type_function=2;
	type_program=3;
	type_integer=4;
	type_real=5;

	//flags
	flag_return=0;
	flag_param=1;
	flag_varparam=2;
	flag_constant=3;

	//valores
	value_boolean=0;
	value_integer=1;
	value_real=2;
	value_true=3;
	value_false=4;
};

void create_tables(Node * node){

	//criar espaço para base
	Table_structure * tabelaexterior;
	tabelaexterior=(Table_structure*)calloc(1,sizeof(Table_structure));
	tabelaexterior->table_name=tables_name[outer_table];

	//criar a primeira outer table
	tabelaexterior->data=generic_outer_table();
	insert_data(tabelaexterior->data, )
}

Table_lines* generic_outer_table(){

	Table_lines * aux=(Table_lines*)calloc(1,sizeof());

	aux->name = name[name_boolean];
	aux->type = type[type_type];
	aux->value = flag[flag_constant];
	aux->value = value[value_boolean];

	return aux;
}

void insert_data(Table_lines *line,char *name, char *type, char *flag, char *value){

	Table_lines * aux=(Table_lines*)calloc(1,sizeof(Table_lines));

	//vai percorrendo as linhas
	while(line->next != NULL)	line=line->next;

	aux->name=name;
	aux->type=type;
	aux->flag=flag;
	aux->value=value;
	line->next=aux;

}

/*
* Adds a new line after the last one
* Sets new line contents to be equal to the arguments
*/
Table_lines * first_line(Table_lines *line, char *name, char *type, char *flag, char *value){
	Table_lines * new = (Table_lines *)malloc(sizeof(Table_lines));

	new->name = name;
	new->type = type;
	new->flag = flag;
	new->value = value;
	new->next = NULL;

	return new;
}





void iterate_ast(Node *root, Table_structure *table_struct, Table_structure *last_position){
	Table_structure *aux;
	Node *temp;
	int value;

	if(root != NULL){
		if(strcmp(root->type, "VarDecl") == 0){
			temp = root->son;

			while(temp->brother != NULL){ //go to last brother
				temp = temp->brother;
			}

			value = check_var(temp->value); //get value type

			while(root->son->brother != NULL){
				if(last_position->data == NULL){ //if there is no line yet
					last_position->data = first_line(lower_case(root->son->value), type[value], NULL, NULL);
				}

				else{ //insert last position
					insert_data(last_position->data, lower_case(root->son->value), type[value], NULL, NULL);
				}

				root->son = root->son->brother;
			}
		}

		else if(strcmp(root->type, "FuncPart") == 0){
			temp = root->son;

			while(temp != NULL){
				if(last_position->data == NULL){
					last_position->data = first_line(lower_case(temp->son->value), type[type_function], NULL, NULL);
				}

				else{
					insert_data(last_position->data, lower_case(temp->son->value), type[type_function], NULL, NULL);
				}

				temp = temp->brother;
			}

			iterate_ast(root->son, table_struct, last_position);
		}

		else if(strcmp(root->type, "FuncDef") == 0){
			aux = create_generic_table(table_struct, tables_name[function_table]);

			value = check_var(root->son->brother->brother->value);

			aux->data = first_line(lower_case(root->son->value), type[value], flag[flag_return], NULL);

			if(root->son->brother->son != NULL){
				temp = root->son->brother->son->son;

				while(temp->brother != NULL){
					temp = temp->brother;
				}			

				value = check_var(temp->value);

				temp = root->son->brother->son->son;

				while(temp->brother != NULL){
					insert_data(aux->data, lower_case(temp->value), type[value], flag[flag_param], NULL);
					temp = temp->brother;
				}
			}

			if(root->son->brother->brother->brother->son != NULL){
				temp = root->son->brother->brother->brother->son->son;

				while(temp->brother != NULL){
					temp = temp->brother;
				}			

				value = check_var(temp->value);

				temp = root->son->brother->brother->brother->son->son;

				while(temp->brother != NULL){
					insert_data(aux->data, lower_case(temp->value), type[value], flag[flag_varparam], NULL);
					temp = temp->brother;
				}
			}
		}

		else if(strcmp(root->type, "FuncDecl") == 0){
			aux = create_generic_table(table_struct, table_name[function_table]);

			value = check_var(root->son->brother->brother->value);

			aux->data = first_line(lower_case(root->son->value), type[value], flag[flag_return], NULL);

			if(root->son->brother->son != NULL){
				temp = root->son->brother->son->son;

				while(temp->brother != NULL){
					temp = temp->brother;
				}			

				value = check_var(temp->value);

				temp = root->son->brother->son->son;

				while(temp->brother != NULL){
					insert_data(aux->data, lower_case(temp->value), type[value], flag[flag_param], NULL);
					temp = temp->brother;
				}
			}
		}

		/*else if(strcmp(root->type, "FuncDef2") == 0){
			aux = declaration_table(table_struct, table_name[FunctionSymbolTable]);

			aux->data = first_line(lower_case(root->son->value), type[_type_], flag[Return], NULL);

			if(root->son->brother->son != NULL){
				temp = root->son->brother->son->son;

				while(temp->brother != NULL){
					temp = temp->brother;
				}			

				value = check_var(temp->value);

				temp = root->son->brother->son->son;

				while(temp->brother != NULL){
					insert_data(aux->data, lower_case(temp->value), type[value], flag[VarParam], NULL);
					temp = temp->brother;
				}
			}

			if(root->son->brother->brother->brother->son != NULL){
				temp = root->son->brother->brother->brother->son->son;

				while(temp->brother != NULL){
					temp = temp->brother;
				}			

				value = check_var(temp->value);

				temp = root->son->brother->brother->brother->son->son;

				while(temp->brother != NULL){
					insert_data(aux->data, lower_case(temp->value), type[value], flag[VarParam], NULL);
					temp = temp->brother;
				}
			}
		}*/

		else{
			iterate_ast(root->son, table_struct, last_position);
		}

		iterate_ast(root->brother, table_struct, last_position);
	}
}


int check_var(char * value) {
	if(strcmp(lower_case(value), "boolean") == 0){
		return value_boolean;
	}

	else if(strcmp(lower_case(value), "integer") == 0){
		return value_integer;
	}

	else if(strcmp(lower_case(value), "real") == 0){
		return value_real;
	}

	return -1;
}

char *lower_case(char * string){
    
    for(int i = 0; string[i] != '\0'; i++){
        string[i] = tolower(string[i]);
    }
    
    return string;
}
































