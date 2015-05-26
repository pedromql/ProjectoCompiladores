


typedef struct ts* tabela_simbolos;

typedef struct te* tabela_elementos;

typedef struct node* arvore;

//----------------------------------------------------

typedef struct te{
	char* nome;
	char* tipo;
	char* flag;
	char* valor;
	tabela_elementos next;
}TE;

typedef struct ts{
    char* nome;
	tabela_elementos elemento;
	tabela_simbolos next; 
}TS;

typedef struct node{
        char tipo[10];
        char *valor;
        int linha,coluna;
        arvore filho;
        arvore irmao;
}No_arvore;

tabela_simbolos tab;

/*-----------------------------------------------------------------------------------------------------------------*/

void display_symbols();
struct te *search_element(char *str);
tabela_elementos insert_el(char* name,char* type, char* fl,char* value);
void criar_tabelas(arvore tree);
void is_program(arvore tree,tabela_elementos anterior,tabela_elementos anterior_programa, tabela_simbolos tabela_aux);
void *lower(char* palavra);
void is_funcdef(arvore iteraFun, tabela_elementos anterior,tabela_elementos anterior_programa, tabela_simbolos tabela_aux);
void is_funcdef2(arvore iteraFun,tabela_elementos anterior,tabela_elementos anterior_programa,tabela_simbolos tabela_aux);
void is_funcdecl(arvore iteraFun,tabela_elementos anterior,tabela_elementos anterior_programa,tabela_simbolos tabela_aux);
tabela_simbolos procurar_tabela(char * nome);
void check_duplicado(struct ts* tabela,arvore no);
void check_definido(struct ts* tab, arvore raiz);
void check_type(struct ts* tab, arvore no);
void check_definido2(struct te* elm,char* nome, arvore no);

