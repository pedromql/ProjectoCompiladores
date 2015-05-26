#include <stdlib.h>
#include <stdio.h>
#include <ctype.h>


typedef struct _node {
    
    char *id;
    struct _node *brother;
    struct _node *son;
    char * type;
    char * value;
    int line;
    int col;
    
}Node;


//-------------------------------- tabelas
typedef struct _tablestructure  Table_structure;
typedef struct _tablelines      Table_lines;

//dados especificos da tabela
typedef struct _tablestructure{
    //proxima tabela
    Table_structure * next;
    
    char *table_name;
    //linhas da tabela
    Table_lines * data;
    
}TableStructure;

//campo generico das tabelas, corresponde a uma linha
typedef struct _tablelines{
    char * name;
    char * type;
    char * flag;
    char * value;
    Table_lines *next; // proxima linha da tabela
}TableLines;





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
void ast(Node *, Table_structure *, Table_structure *);
void print_semantic(Table_structure *);
Table_structure* create_generic_table(Table_structure *, char* );
char *lower_case(char * );
void print_tables(Table_structure *);
int check_var(char * );


void varDecl_funtion(Node * , Table_structure *);
void funcPart_function(Node * , Table_structure  *);
void funcDef_function(Node * , Table_structure * );
void funcDecl_function(Node * , Table_structure * );
void funcDef2_function(Node * , Table_structure * );




//variaveis da meta 3
Node * make_node(char *,char *,char *,Node *,Node *, int , int );
void addBrother(Node *, Node * );
void addChild(Node * , Node * );
void printAll(Node * ,int );
Node * check_statlist(Node * , int , int ); 
Node * check_statlist2(Node * , int , int );


















