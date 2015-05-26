#include <stdlib.h>
#include <stdio.h>
#include <ctype.h>

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
    char * flag;
    char * value;
    Table_lines *next; // proxima linha da tabela
};


Symbol <token> already defined: Identificador já está definido nas tabelas;
Symbol <token> not defined: Identificador usado como tipo, mas não é encontrado nas tabelas;
Type identifier expected: Identificador existe mas não é _type_;


//mais simplificado
char *tables_name[] = {"===== Outer Symbol Table =====", "===== Function Symbol Table =====", "===== Program Symbol Table ====="};
char *name[] = {"boolean", "integer", "real", "false", "true", "paramcount", "program"};
char *type[] = {"_type_", "_boolean_", "_function_", "_program_", "_integer_", "_real_"};
char *flag[] = {"return", "param", "varparam", "constant"};
char *value[] = {"_boolean_", "_integer_", "_real_", "_true_", "_false_"};


//enumerar as tabelas a cima para referencias
enum{
	//indices tabelas
	outer_table=0,
	function_table=1,
	program_table=2,

	//nomes
	name_boolean=0,
	name_integer=1,
	name_real=2,
	name_false=3,
	name_true=4,
	name_paramcount=5,
	name_program=6,

	//indice tipos
	type_type=0,
	type_boolean=1,
	type_function=2,
	type_program=3,
	type_integer=4,
	type_real=5,

	//flags
	flag_return=0,
	flag_param=1,
	flag_varparam=2,
	flag_constant=3,

	//valores
	value_boolean=0,
	value_integer=1,
	value_real=2,
	value_true=3,
	value_false=4
};




Table_lines* generic_lines_table(void);
void insert_data(Table_lines *,char *, char *, char *, char *);
void create_base_structure_table(Table_structure * );
void iterate_ast(Node *, Table_structure *, Table_structure *);
void print_semantic(Table_structure *);
Table_structure* create_generic_table(Table_structure *, char* );
char *lower_case(char * );
void print_semantic(Table_structure *);



Table_structure *  create_tables(Node * node){

	//criar espaço para base
	Table_structure * tabelaexterior;
	tabelaexterior=(Table_structure*)calloc(1,sizeof(Table_structure));
	tabelaexterior->table_name=tables_name[outer_table];

	//criar a primeira outer table
	tabelaexterior->data=generic_lines_table();
	insert_data(tabelaexterior->data,name[name_integer],type[type_type],flag[flag_constant],value[value_integer]);
	insert_data(tabelaexterior->data,name[name_real],type[type_type],flag[flag_constant],value[value_real]);
	insert_data(tabelaexterior->data,name[name_false],type[type_boolean],flag[flag_constant],value[value_false]);
	insert_data(tabelaexterior->data,name[name_true],type[type_boolean],flag[flag_constant],value[value_true]);
	insert_data(tabelaexterior->data,name[name_paramcount],type[type_function],NULL,NULL);
	insert_data(tabelaexterior->data,name[name_program],type[type_program],NULL,NULL);


	//criar function symbol table
	create_base_structure_table(tabelaexterior);

	//achar proxima posicao livre para inserir tabela program
	Table_structure *lastTable=create_generic_table(tabelaexterior,tables_name[program_table]);
	
	iterate_ast(node, tabelaexterior, lastTable);

	return tabelaexterior;

}

//cria estrutura base e devolve ponteiro
Table_lines* generic_lines_table(void){

	Table_lines * aux=(Table_lines*)calloc(1,sizeof(Table_lines));

	aux->name = name[name_boolean];
	aux->type = type[type_type];
	aux->flag = flag[flag_constant];
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

//cria 2 tabela generica a symbol table
void create_base_structure_table(Table_structure * temp){

	Table_structure * aux;
	aux = (Table_structure*)calloc(1,sizeof(Table_structure));
	aux->table_name = tables_name[function_table];

	//dados em si
	aux->data=(Table_lines*)calloc(1,sizeof(Table_lines));
	aux->data->name = name[name_paramcount];
	aux->data->type = type[type_integer];
	aux->data->flag = flag[flag_return];
	aux->data->value = NULL;
	temp->next=aux;

}

//cria nova tabela "mãe" e adiciona no fim, retorna ponteiro para a ultima
Table_structure* create_generic_table(Table_structure *temp, char* nome){
	Table_structure * aux;
	aux=(Table_structure*)calloc(1,sizeof(Table_structure));
	aux->table_name=nome;
	
	while(temp->next != NULL)   temp=temp->next;
	
	temp->next=aux;
	return temp->next;
}
/*
* Adds a new line after the last one
* Sets new line contents to be equal to the arguments
*/
Table_lines * first_line(char *name, char *type, char *flag, char *value){
	Table_lines * new = (Table_lines *)malloc(sizeof(Table_lines));

	new->name = name;
	new->type = type;
	new->flag = flag;
	new->value = value;
	new->next = NULL;

	return new;
}

void check_for_duplicates(Table_structure *last, char * s){
	Table_lines * new = last->data;//é preciso copiar para nao perder o contexto dos ponteiros
	int global=0;
	while( new != NULL){
		
		if(strcmp(s,new->name)==0){
			global=1;
			break;
		}
		new=new->next;
	}
	if(global){
		error_symbolalareadydefined(s);	
		exit(0);
	}
}




void iterate_ast(Node *root, Table_structure *table_struct, Table_structure *last_position){
	Table_structure *aux;
	Node *temp;
	int value_type;
	char *compareduplicates;

	//funcdef e tudo dentro
	//funcdef2
	//func declaration
	if(root != NULL){

		if(strcmp(root->type, "VarDecl") == 0){
			temp = root->son;//já é um ID

			while(temp->brother != NULL){ //go to last  brother to check type
				temp = temp->brother;
			} 

			value_type = check_var(temp->value); //get value type

			while(root->son->brother != NULL){

				//ver se o nó já existe
				//printf("====%s\n",root->son->value );

				if(last_position->data == NULL){ //if there is no line yet add another

					last_position->data = first_line(lower_case(root->son->value), value[value_type], NULL, NULL);
				}

				else{ //insert last position but teste if its equal to last line
					
					compareduplicates = (char *)calloc(1, sizeof(char));//alocar para novo simbolo
					strcpy(compareduplicates, root->son->value);
					check_for_duplicates(last_position,lower_case(root->son->value));
					//se nao saiu é porque nao ha duplicados
					insert_data(last_position->data, lower_case(root->son->value), value[value_type], NULL, NULL);
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

			value_type = check_var(root->son->brother->brother->value);

			aux->data = first_line(lower_case(root->son->value), value[value_type], flag[flag_return], NULL);

			if(root->son->brother->son != NULL){
				temp = root->son->brother->son->son;

				while(temp->brother != NULL){
					temp = temp->brother;
				}			

				value_type = check_var(temp->value);

				temp = root->son->brother->son->son;

				while(temp->brother != NULL){
					insert_data(aux->data, lower_case(temp->value), value[value_type], flag[flag_param], NULL);
					temp = temp->brother;
				}
			}

			if(root->son->brother->brother->brother->son != NULL){
				temp = root->son->brother->brother->brother->son->son;

				while(temp->brother != NULL){
					temp = temp->brother;
				}			

				value_type = check_var(temp->value);

				temp = root->son->brother->brother->brother->son->son;

				while(temp->brother != NULL){
					insert_data(aux->data, lower_case(temp->value), value[value_type], flag[flag_varparam], NULL);
					temp = temp->brother;
				}
			}
		}

		//aqui

		else{
			iterate_ast(root->son, table_struct, last_position);
		}

		iterate_ast(root->brother, table_struct, last_position);
	}
}


int check_var(char * string) {
	
	if(strcmp(lower_case(string), "boolean") == 0){
		return value_boolean;
	}

	else if(strcmp(lower_case(string), "integer") == 0){
		return value_integer;
	}

	else if(strcmp(lower_case(string), "real") == 0){
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

void print_semantic(Table_structure *temp){
	while(temp != NULL){
		printf("%s\n", temp->table_name);

		while(temp->data != NULL){
			printf("%s\t%s", temp->data->name, temp->data->type);

			if(temp->data->flag != NULL){
				printf("\t%s", temp->data->flag);

				if(temp->data->value != NULL){
					printf("\t%s", temp->data->value);
				}
			} 

			printf("\n");
			temp->data = temp->data->next;
		}
		
		temp = temp->next;

		if(temp != NULL){
			printf("\n");
		}
	}
}




















