#include <stdlib.h>
#include "structures.h"



//-------------------------------- tabelas
//typedef struct _table0 outer_tables;
typedef struct _table1 symbol_tables;

//tabela externa
typedef struct _table0{
    
    char *t0_name;
	//outer_tables * next;
    symbol_tables * root;    
    
};

//tabelas especifocas de simbolos
typedef struct _table1{
    char * name;
    char * type;
    char * flag;
    char * value;
    _table1 *next;

};

Table0 *Header_table;



char *tables_name[] = {"===== Outer Symbol Table =====", "===== Function Symbol Table =====", "===== Program Symbol Table ====="};
char *type[] = {"_type_", "_boolean_", "_function_", "_program_", "_integer_", "_real_"};
char *flag[] = {"return", "param", "varparam", "constant"};
char *value[] = {"_boolean_", "_integer_", "_real_", "_true_", "_false_"};
char *symbols[] = {"boolean", "integer", "real", "false", "true", "paramcount", "program"};
