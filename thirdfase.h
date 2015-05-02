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

	Table_lines * aux=(Table_lines*)calloc(1,sizeof());

	//vai percorrendo as linhas
	while(line->next != NULL)	line=line->next;

	aux->name=name;
	aux->type=type;
	aux->flag=flag;
	aux->value=value;
	line->next=aux;

}


































