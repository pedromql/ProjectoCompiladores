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
    char * flag;
    char * value;
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
	tabelaexterior->data=generic_lines_table();
	insert_data(tabelaexterior->data,name[name_integer],type[type_type],flag[flag_constant],value_integer[value_integer]);
	insert_data(tabelaexterior->data,name[name_real],type[type_type],flag[flag_constant],value_integer[value_real]);
	insert_data(tabelaexterior->data,name[name_false],type[type_boolean],flag[flag_constant],value_integer[value_real]);
	insert_data(tabelaexterior->data,name[name_true],type[type_boolean],flag[flag_constant],value_integer[value_true]);
	insert_data(tabelaexterior->data,name[name_paramcount],type[type_function],NULL,NULL);
	insert_data(tabelaexterior->data,name[name_program],type[type_program],NULL,NULL);


	//criar function symbol table
	create_base_structure_table(tabelaexterior);

	//achar proxima posicao livre para inserir tabela program
	Table_structure *lastTable=create_generic_table(tabelaexterior,tables_name[program_table]);
	

}

//cria estrutura base e devolve ponteiro
Table_lines* generic_lines_table(){

	Table_lines * aux=(Table_lines*)calloc(1,sizeof(Table_lines));

	aux->name = name[name_boolean];
	aux->type = type[type_type];
	aux->flag = flag[flag_constant];
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






























