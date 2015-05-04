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
void varDecl_funtion(Node * , Table_structure *, Table_structure *);
void funcPart_function(Node * , Table_structure  *);
void funcDef_function(Node * , Table_structure * );
void funcDecl_function(Node * , Table_structure * );
void funcDef2_function(Node * , Table_structure * );
void check_for_duplicates(Table_structure *, char * ,int ,int);
void error_symbolalareadydefined(char * ,int,int );
void check_symbol_not_defined(Node * ,Table_structure *, Table_structure *, char * );
int  error_typeidentifierexpected(int , int );



Table_structure * create_tables(Node * node){
    
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
    
    ast(node, tabelaexterior, lastTable);
    
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

void ast(Node * root, Table_structure * first_table, Table_structure * last_table) {
    if (root != NULL) {
        if (strcmp(root->type, "VarDecl") == 0) {
            varDecl_funtion(root,first_table, last_table);//falta
        }
        else if (strcmp(root->type, "FuncPart") == 0) {
            funcPart_function(root,last_table);
            
            ast(root->son,first_table,last_table);
            
        }
        else if (strcmp(root->type, "FuncDef") == 0) {
            funcDef_function(root, first_table);//falta
            
        }
        else if (strcmp(root->type, "FuncDecl") == 0) {
            funcDecl_function(root,first_table);
            
        }
        else if (strcmp(root->type, "FuncDef2") == 0) {
            funcDef2_function(root,first_table);
            
        }
        else { //if there is nothing to be done it continues to the son
            ast(root->son,first_table,last_table);
        }
        ast(root->brother,first_table,last_table); //iterate through the brothers
    }
}

void varDecl_funtion(Node * parent, Table_structure *first_table,Table_structure *last_table) {
    Node * temp = parent->son; //node temp is the first occurrence of a id
    Node * var_nodes = parent->son; //first variable
    int variable_type;
    char * compareduplicates;
    char * compareTypeValue;

    while(temp->brother != NULL)  {//get to last brother
        temp = temp->brother;
    }

    
    variable_type = check_var(temp->value); //get the variable type
    
	//saca o tipo da variavel sem meter os underscores
    compareTypeValue=(char *)calloc(1, sizeof(char));
    strcpy(compareTypeValue, temp->value);

    
    while(var_nodes->brother != NULL) { //iterate through all variables
        if (last_table->data == NULL) { //if last_table has no data yet, a first line is created
            last_table->data = first_line(lower_case(var_nodes->value), value[variable_type], NULL, NULL);
        }
        else { //the function called inserts the new var at the end of the table

        	compareduplicates = (char *)calloc(1, sizeof(char));//alocar para novo simbolo
			strcpy(compareduplicates, var_nodes->value);
			check_for_duplicates(last_table,lower_case(var_nodes->value),var_nodes->line, var_nodes->col);
			//se nao saiu é porque nao ha duplicados

			//ver symbol not defined
			Node *aux=parent;
			check_symbol_not_defined(aux,first_table,last_table,compareTypeValue);

            insert_data(last_table->data, lower_case(var_nodes->value), value[variable_type], NULL,NULL);
        }
        
        var_nodes = var_nodes->brother;
    }
}

void funcPart_function(Node * parent, Table_structure  *last_table) {
    Node * temp = parent->son;
    
    while(temp != NULL) { //iterate through all funcPart sons (funcdef, funcdef2, funcdecl) and add it's type to the program symbol table
        if (strcmp(temp->type,"FuncDef2") == 0);
        else if (last_table->data == NULL) { //first line of table case
            last_table->data = first_line(lower_case(temp->son->value), type[type_function], NULL, NULL);
        }
        else {
            insert_data(last_table->data, lower_case(temp->son->value), type[type_function], NULL, NULL);
        }
        
        temp = temp->brother;
    }
}

void funcDef_function(Node * parent, Table_structure * first_table) {
    
    Table_structure * new_table = create_generic_table(first_table, tables_name[function_table]);
    Node * temp;
    Node * too_many_params;
    char * compareduplicates;
    char * compareTypeValue;
    
    int variable_type = check_var(parent->son->brother->brother->value); //variable_type is the 3rd son of the funcDef
    
    new_table->data = first_line(lower_case(parent->son->value), value[variable_type], flag[flag_return], NULL); //first line has the return type of function and it's name (funcdef->son = id(name_of_function))
    
    if (parent->son->brother->son != NULL) {
        too_many_params = parent->son->brother->son;
        while(too_many_params != NULL) {
            
            if (too_many_params->son != NULL) { //if function has parameters
                temp = too_many_params->son; //temp equals first id funcdef->id->funcparams->params->ids....
                
                while (temp->brother != NULL) { //last brother has the variable type
                    temp = temp->brother;
                }
                
                variable_type = check_var(temp->value); //saves variable type

                //cenas para comparar os erros
                compareTypeValue=(char *)calloc(1, sizeof(char));
   				strcpy(compareTypeValue, temp->value);

                
                temp = too_many_params->son; //temp equals first id parameter again
                
                while(temp->brother != NULL){ //add all function parameters to the table with it's name and type
                    if (strcmp(too_many_params->type,"VarParams") == 0){ 
                    	
                    	//duplicados
                    	compareduplicates = (char *)calloc(1, sizeof(char));//alocar para novo simbolo
						strcpy(compareduplicates, temp->value);
						check_for_duplicates(new_table,lower_case(temp->value),temp->line, temp->col);
                    	//se nao saiu é porque nao ha duplicados
						///
                    	Node *aux=parent;
						check_symbol_not_defined(aux,first_table,new_table,compareTypeValue);
						///_____________________________________________________________________________________

                    	insert_data(new_table->data, lower_case(temp->value), value[variable_type], flag[flag_varparam], NULL);
                    }
                    else {
                    		//duplicados
							compareduplicates = (char *)calloc(1, sizeof(char));//alocar para novo simbolo
							strcpy(compareduplicates, temp->value);
							check_for_duplicates(new_table,lower_case(temp->value),temp->line, temp->col);
							//se nao saiu é porque nao ha duplicados
                    		
                    		//ver symbol not defined
                    		Node *aux=parent;
							check_symbol_not_defined(aux,first_table,new_table,compareTypeValue);
							///________________________________________________________________________________

                    		insert_data(new_table->data, lower_case(temp->value), value[variable_type], flag[flag_param], NULL);
                    }
                    temp = temp->brother;
                }
                
            }
            too_many_params = too_many_params->brother;
        }

    }
    if (parent->son->brother->brother->brother->son != NULL) { //checks if function has varPart->varDecl
        too_many_params = parent->son->brother->brother->brother->son;
        
        while (too_many_params != NULL) {
            temp = too_many_params->son; //temp is the first var
            
            while (temp->brother != NULL) { //gets to last id to get the var type
                temp = temp->brother;
            }
            
            variable_type = check_var(temp->value); //saves the variable type
            
            temp = too_many_params->son; //temp is the first var again
            
            while (temp->brother != NULL) { //add variables to the with it's name and type
                insert_data(new_table->data, lower_case(temp->value), value[variable_type], NULL, NULL);
                temp = temp->brother;
            }
            
            too_many_params = too_many_params->brother;
        }
        
    }
    
}

void funcDecl_function(Node * parent, Table_structure * first_table) {
    Table_structure * new_table = create_generic_table(first_table, tables_name[function_table]);
    
    Node * temp;
    Node * too_many_params;
    char * compareTypeValue;
    
    int variable_type = check_var(parent->son->brother->brother->value); //gets the function return type
    
    new_table->data = first_line(lower_case(parent->son->value), value[variable_type], flag[flag_return], NULL); //creates the first line with the function name (root->son->value) and it's return variable type
    
    if (parent->son->brother->son != NULL ) { //checks if function has params (funcdecl->id(max)->funcparams->params)
        too_many_params = parent->son->brother->son;

        while (too_many_params != NULL) {

        	temp = too_many_params->son; //sets temp as the first parameter
        	
        	while (temp->brother != NULL) { //goes to last brother that has the variables type
        	    temp = temp->brother;
        	}
        	
        	variable_type = check_var(temp->value); //saves the variables type

        	compareTypeValue=(char *)calloc(1, sizeof(char));
   			strcpy(compareTypeValue, temp->value);

                
        	
        	temp = too_many_params->son; //temp is the first paramenter again
        	
        	while (temp->brother != NULL) { //iterate through all the variables and add to the table
        	    if (strcmp(too_many_params->type,"VarParams") == 0) {

        	    	Node *aux=parent;
					check_symbol_not_defined(aux,first_table,new_table,compareTypeValue);


        	    	insert_data(new_table->data,lower_case(temp->value), value[variable_type], flag[flag_varparam], NULL);
        	    }
        	    else {

        	    	Node *aux=parent;
					check_symbol_not_defined(aux,first_table,new_table,compareTypeValue);

	        	    insert_data(new_table->data, lower_case(temp->value), value[variable_type], flag[flag_param], NULL); //adds the variable to the table with its name and type
	        	    temp = temp->brother;
        		}
        	}


        	too_many_params = too_many_params->brother;
        }

        
    }
}

void funcDef2_function(Node * parent, Table_structure * first_table) { //Falta verificar se a funcao já existe em tabela
    Table_structure * find_table = first_table->next->next->next;
    
    Node * temp = parent->son;
    Node * var_nodes;
    
    int variable_type;
    
    while (find_table != NULL && strcmp(lower_case(temp->value),find_table->data->name) != 0) { //iterates until table matches the funcdef2 function
        find_table = find_table->next;
    }
    if (find_table == NULL) return;
    
    temp = temp->brother->son; //sets temp as the first vardecl
    
    while (temp != NULL) {
        var_nodes = temp->son; //sets var_nodes as the first variable
        
        while (var_nodes->brother != NULL) { //iterates until last node that has the type
            var_nodes = var_nodes->brother;
        }
        variable_type = check_var(var_nodes->value); //gets the variable type
        
        var_nodes = temp->son; //sets var_nodes as the first var again
        
        while (var_nodes->brother != NULL) { //iterates through all variables and adds them to the the function table
            insert_data(find_table->data, lower_case(var_nodes->value), value[variable_type], NULL,NULL);
            var_nodes = var_nodes->brother;
        }
        
        temp = temp->brother;
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
    
    return value_boolean;
}

char *lower_case(char * string){
    int i;
    for(i = 0; string[i] != '\0'; i++){
        string[i] = tolower(string[i]);
    }
    
    return string;
}

void print_tables(Table_structure *first_table){
    Table_structure * temp = first_table;
    
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
		
void check_for_duplicates(Table_structure *last, char * s,int line,int col){
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
		error_symbolalareadydefined(s,line,col);	
		exit(0);
	}
}

void check_symbol_not_defined(Node * parent,Table_structure *first_table, Table_structure *last_table, char * type){

	int global=1;
	//percorrer a tabela actual e ver se existe uma variavel com o nome igual a type
	// 1-> SE existir vêse o tipo dessa variavel é type
			//1.1-> se for type insere
			//1.2-> se não Id expected
	// 	2-> se não existir em nenhuma é type identifier expected

	//se não passo para a program table
	//se nao passo para a outer table
 	Table_lines * tabelaexterior=first_table->data;						//tabela exterior
 	Table_lines * program_table=first_table->next->next->data;			//tabela do program
 	Table_lines * current_line = last_table->data;						//tabela da funcao

 	//percorre a function table, vê se existe alguma variavel com o nome=tipo
	while( current_line != NULL){	
		
		if(strcmp(type,current_line->name)==0){
			//type identifier expected
			if(strcmp("_type_",current_line->type)==0){
				global=0;
				break;

			}
			else{
				error_typeidentifierexpected(10,10);
				exit(0);
				break;

			}
		}
		current_line=current_line->next;
	}

	//percorre a program table
	while( program_table != NULL){	
		if(strcmp(type,program_table->name)==0){
			
			if(strcmp("_type_",program_table->type)==0){//verifica se o que foi definido é um _type_
				global=0;
				break;
			}
			else{
				error_typeidentifierexpected(10,10);
				exit(0);
				break;
			}
		}
		
		program_table=program_table->next;
	}
	//outer table
	while( tabelaexterior != NULL){	
		if(strcmp(type,tabelaexterior->name)==0){//se o nome for igual ao tipo tem de ver se esse nome é do tipo _type_
			
			if(strcmp("_type_",tabelaexterior->type)==0){//Pode inserir 
				global=0;
				break;
			}
			else if(strcmp("_type_",tabelaexterior->type)!=0){//se não for dá erro de id expected
				error_typeidentifierexpected(10,10);
				exit(0);
				break;
			}
			
		}
		tabelaexterior=tabelaexterior->next;
	}

	if(global){
		//error_typeidentifierexpected(10,10);
		error_symbolnotdefined(type,10,10);	
		//exit(0);
	}
}

//Symbol <token> already defined
void error_symbolalareadydefined(char * symbol,int line, int col){
	printf("Line %d, col %lu: Symbol %s already defined\n", line, col-strlen(symbol),symbol);
}
//Symn> not defined
int  error_symbolnotdefined(char * symbol,line,col){
	printf("Line %d, col %d: Symbol %s not defined\n", line,(int) col,symbol);
	return 0;
}

//Type identifier expected
int  error_typeidentifierexpected(int line, int col){
	printf("Line %d, col %d: Type identifier expected\n", line,col);
	return 0;
}


