
#include "semantics.h"
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <ctype.h>

void display_symbols(){

	tabela_simbolos tab_temp = tab;
	tabela_elementos  elem_temp = tab_temp->elemento;
	

	printf("===== Outer Symbol Table =====\n");	

	while(elem_temp != NULL){
		printf("%s\t%s",elem_temp->nome,elem_temp->tipo);
		if(elem_temp->flag!=NULL)
			printf("\t%s", elem_temp->flag);
		if(elem_temp->valor!=NULL)
			printf("\t%s",elem_temp->valor);
		
		printf("\n");
		elem_temp=elem_temp->next;
	}
	tab_temp=tab_temp->next;

	elem_temp=tab_temp->elemento;

	printf("\n===== Function Symbol Table =====\n");	
	while(elem_temp != NULL){
		printf("%s\t%s",elem_temp->nome,elem_temp->tipo);
		if(elem_temp->flag!=NULL)
			printf("\t%s",elem_temp->flag);
		if(elem_temp->valor!=NULL)
			printf("\t%s",elem_temp->valor);
		printf("\n");
		elem_temp=elem_temp->next;
	}
	tab_temp=tab_temp->next;

	elem_temp=tab_temp->elemento;

	printf("\n===== Program Symbol Table =====\n");
	while(elem_temp != NULL){
		printf("%s\t_%s_\n",elem_temp->nome,elem_temp->tipo);
		elem_temp=elem_temp->next;
	}

	tab_temp=tab_temp->next;	

	while(tab_temp!=NULL){
		elem_temp=tab_temp->elemento;
		printf("\n===== Function Symbol Table =====\n");	
		while(elem_temp != NULL){
			printf("%s\t_%s_",elem_temp->nome,elem_temp->tipo);
			if(elem_temp->flag!=NULL)
				printf("\t%s",elem_temp->flag);
			if(elem_temp->valor!=NULL)
				printf("\t%s",elem_temp->valor);
			printf("\n");
			elem_temp=elem_temp->next;
		}
		tab_temp=tab_temp->next;
	}
}

struct te *search_element(char *str){
	
	struct ts* tab_temp;
	struct te* elem_temp;

	while(tab_temp != NULL){
		while(elem_temp != NULL){
			if(strcmp(elem_temp->nome,str)==0)
				return elem_temp;
		}
	}
	return NULL;
}

void check_duplicado(struct ts* tabela,arvore no){
	struct te* temp = tabela->elemento;
	
	
	while(temp!=NULL){		
		if(strcmp(temp->nome,lower(no->valor))==0){
			printf("Line %d, col %d: Symbol %s already defined\n",no->linha,no->coluna,no->valor);
			exit(0);
		}
		temp = temp->next;
	}
}


void check_definido2(struct te* elm,char* nome, arvore no){
	while(elm!=NULL){
		if(strcmp(elm->nome,nome)==0){
				
			printf("Line %d, col %d: Type identifier expected\n",no->linha,no->coluna);
			exit(0);
		}
		elm = elm->next;
	}

}

void check_definido(struct ts* tabela, arvore no){
	struct te* elm;
	char* nome = lower(no->valor);
	

	
	
	if(tabela!=NULL){
		elm = tabela->elemento;
		check_definido2(elm,nome,no);
	}
	tabela = tab->next->next;
	elm = tabela->elemento;

	check_definido2(elm,nome,no);


	tabela = tab->next;
	elm = tabela->elemento;
	
	check_definido2(elm,nome,no);


	tabela = tab;
	
	elm = tab->elemento;
	while(elm!=NULL){
		if(strcmp(elm->nome,nome)==0 && strcmp(elm->tipo,"_type_")==0){
			return;
		}
		else if((strcmp(elm->nome,nome)==0) && ((strcmp(elm->tipo,"_boolean_")==0) || (strcmp(elm->tipo,"_program_")==0) || (strcmp(elm->tipo,"_function_")==0))){
			
			printf("Line %d, col %d: Type identifier expected\n",no->linha,no->coluna);
			exit(0);
		}
		elm = elm->next;
	}
	

	printf("Line %d, col %d: Symbol %s not defined\n",no->linha,no->coluna,no->valor);
	exit(0);
}



void check_type(struct ts* tab, arvore no){

	struct te* temp = tab->elemento;

	while(temp!= NULL){
		if(strcmp(temp->nome,no->valor)==0 && strcmp(temp->tipo,"_type_")==0){
			return;
		}
		temp = temp->next;
	}

	printf("Line %d, col %d: Type identifier expected\n",no->linha,no->coluna);
}



void *lower(char* palavra){ 
	char* n = malloc(strlen(palavra)+1);
	strcpy(n,palavra);
	int i;
	for(i=0;i<strlen(palavra);i++){
		n[i]=tolower(n[i]);
	}
	return n;

}


tabela_elementos insert_el(char* name,char* type, char* fl,char* value)
{

	tabela_elementos elemento=(tabela_elementos) malloc(sizeof(TE));

	elemento->nome = lower(name);

	//strcpy(elemento->nome, name);

	//strcpy(elemento->tipo, type);
	elemento->tipo = lower(type);

	if(fl!=NULL){
		//strcpy(elemento->flag, fl);	
		elemento->flag = lower(fl);
	}else{
		elemento->flag = NULL;
	}

	if(value!=NULL){
		//strcpy(elemento->valor,value);
		elemento->valor = lower(value);
	}else{
		elemento->valor=NULL;
	}
	elemento->next = NULL;

	return elemento;
}

void criar_tabelas(arvore tree){


	tabela_elementos anterior = NULL;
	tabela_elementos anterior_programa = NULL;
	tab = (tabela_simbolos) malloc(sizeof(TS));
	tabela_simbolos tabela_aux = tab;	

	anterior = insert_el("boolean","_type_","constant","_boolean_");

	tabela_aux->elemento = anterior;

	anterior->next = insert_el("integer","_type_","constant","_integer_");
	anterior = anterior->next;

	anterior->next = insert_el("real","_type_","constant","_real_");
	anterior=anterior->next;

	anterior->next = insert_el("false","_boolean_","constant","_false_");
	anterior=anterior->next;

	anterior->next = insert_el("true","_boolean_","constant","_true_");
	anterior = anterior->next;
	anterior->next = insert_el("paramcount","_function_",NULL,NULL);
	anterior = anterior->next;
	anterior->next = insert_el("program","_program_",NULL,NULL);
	anterior = anterior->next;
	anterior = NULL;

	tabela_aux->next = (tabela_simbolos) malloc(sizeof(TS));
	tabela_aux = tabela_aux->next;

	tabela_aux->elemento = insert_el("paramcount","_integer_",NULL,"return");
	tabela_aux->next = (tabela_simbolos) malloc(sizeof(TS));
	tabela_aux = tabela_aux->next;


	is_program(tree,anterior,anterior_programa,tabela_aux);

}



void is_program(arvore tree,tabela_elementos anterior,tabela_elementos anterior_programa, tabela_simbolos tabela_aux){

	arvore aux;
	char* temp;

    arvore iteraVarDecl=tree->filho->irmao->filho; //o primeiro filho é o id o irmao dele é o varPart e o filho dele é o primeiro VarDecl


    while(iteraVarDecl!=NULL){
    	
    	if(iteraVarDecl->filho==NULL){
            break;// se nao tiveres variaveis declaradas o filho é null logo tens de sair
        }
        aux= iteraVarDecl->filho;
        while(aux->irmao!=NULL){
        	aux= aux->irmao;

        }
        
        temp=aux->valor;
        
        check_definido(NULL,aux);
        aux=iteraVarDecl->filho;

        while(aux->irmao!=NULL){
        	
        	check_duplicado(tabela_aux,aux);
        	
        	if(anterior_programa!=NULL){
        		anterior_programa->next=insert_el(aux->valor,temp,NULL,NULL);
        		anterior_programa=anterior_programa->next;
        	}else{

        		anterior_programa = insert_el(aux->valor,temp,NULL,NULL);
        		//tabela_aux->elemento = anterior_programa;
        		tab->next->next->elemento = anterior_programa;
        	}
        	aux= aux->irmao;
        }
        iteraVarDecl= iteraVarDecl->irmao;
    }


   //tabela_aux = NULL;

    arvore iteraFun = tree->filho->irmao->irmao->filho;

    while(iteraFun != NULL){

    	if(strcmp(iteraFun->tipo,"FuncDef") == 0){
    		
    		is_funcdef(iteraFun,anterior,anterior_programa,tabela_aux); 
    		

    		tabela_aux = tabela_aux->next;
    		if(anterior_programa != NULL){
    			anterior_programa = anterior_programa->next;	
    		}else{
    			anterior_programa=tab->next->next->elemento;
    		}

    		

    		
    	}else if(strcmp(iteraFun->tipo,"FuncDef2") == 0){
    		
    		is_funcdef2(iteraFun,anterior,anterior_programa,tabela_aux);
    		
    		

    	}else if(strcmp(iteraFun->tipo,"FuncDecl") == 0){
    		
    		is_funcdecl(iteraFun,anterior,anterior_programa,tabela_aux);

    		tabela_aux = tabela_aux->next;

    		if(anterior_programa != NULL){
    			anterior_programa = anterior_programa->next;
    			
    		}else{
    			anterior_programa = tab->next->next->elemento;

    		}

    		
    	}

    	iteraFun = iteraFun->irmao;
    }


}


void is_funcdef(arvore iteraFun, tabela_elementos anterior,tabela_elementos anterior_programa, tabela_simbolos tabela_aux){

	arvore iteraVarDecl=iteraFun->filho->irmao->irmao->irmao->filho;
	arvore iteraParams=iteraFun->filho->irmao->filho;

	tabela_aux->next = (tabela_simbolos) malloc(sizeof(TS));

	tabela_aux=tabela_aux->next;
	anterior = NULL;
	arvore aux = iteraFun->filho;
    //arvore aux;
	char* temp;

	if(anterior_programa != NULL){
		anterior_programa->next = insert_el(aux->valor,"function",NULL,NULL);

		anterior_programa = anterior_programa->next;

	}else{

		anterior_programa = insert_el(aux->valor,"function",NULL,NULL);
		tab->next->next->elemento = anterior_programa;
    		//tabela_aux->elemento = anterior_programa;

	}   

	anterior = insert_el(aux->valor,aux->irmao->irmao->valor,NULL,"return");
    //check_definido(tabela_aux,aux);
	tabela_aux->elemento = anterior;
	aux= iteraFun->filho->irmao;

	while(iteraParams!=NULL){

		if(iteraParams->filho==NULL){
            break;// se nao tiveres variaveis declaradas o filho é null logo tens de sair
        }
        aux= iteraParams->filho;
        while(aux->irmao!=NULL){
        	aux= aux->irmao;

        }
        temp=aux->valor;
       	check_definido(tabela_aux,aux);
        aux=iteraParams->filho;

        while(aux->irmao!=NULL){
            check_duplicado(tabela_aux,aux);
            if(strcmp(iteraParams->tipo,"Params")==0){ //nao sei o q fazer aqui
            	if(anterior!=NULL){
            		anterior->next=insert_el(aux->valor,temp,NULL,"param");
            		anterior=anterior->next;
            	}else{

            		anterior = insert_el(aux->valor,temp,NULL,"param");
            		tabela_aux->elemento = anterior;
            	}   
            }else{
            	if(anterior!=NULL){
            		anterior->next = insert_el(aux->valor,temp,NULL,"Varparam");
            		anterior = anterior->next;
            	}else{
            		anterior = insert_el(aux->valor,temp,NULL,"Varparam");
            		tabela_aux->elemento = anterior;
            	}
            }   

            aux= aux->irmao;
        }
        iteraParams= iteraParams->irmao;
    }



    while(iteraVarDecl!=NULL){
    	
    	if(iteraVarDecl->filho==NULL){
            break;// se nao tiveres variaveis declaradas o filho é null logo tens de sair
        }
        aux= iteraVarDecl->filho;
        while(aux->irmao!=NULL){
        	aux= aux->irmao;

        }
        
        temp=aux->valor;
        
        check_definido(tabela_aux,aux);
        aux=iteraVarDecl->filho;
        
        while(aux->irmao!=NULL){
        	check_duplicado(tabela_aux,aux);
        	if(anterior!=NULL){
        		anterior->next=insert_el(aux->valor,temp,NULL,NULL);
        		anterior=anterior->next;
        		
        	}else{

        		anterior = insert_el(aux->valor,temp,NULL,NULL);
        		tabela_aux->elemento = anterior;
        		
        	}
        	aux= aux->irmao;
        }
        iteraVarDecl= iteraVarDecl->irmao;
    }
    check_definido(NULL,iteraFun->filho->irmao->irmao);
}


void is_funcdef2(arvore iteraFun,tabela_elementos anterior,tabela_elementos anterior_programa,tabela_simbolos tabela_aux){
	
	arvore iterar = iteraFun->filho;
	arvore iteradef2 = iteraFun->filho->irmao->filho;
	//arvore aux = iteraFun->filho;
	arvore aux;
	char* temp;
	tabela_simbolos tabela_2 = procurar_tabela(iterar->valor);

	/*if(tabela_2==NULL){
		printf("Line %d, col %d: Function identifier expected\n",iterar->linha,iterar->coluna);
		exit(1);
	}*/

		anterior=tabela_2->elemento;

		while(anterior->next!=NULL){
		anterior=anterior->next; // iterar para o fim da tabela
	}


	while(iteradef2!=NULL){

		if(iteradef2->filho==NULL){
            break;// se nao tiveres variaveis declaradas o filho é null logo tens de sair
        }
        aux = iteradef2->filho;

        while(aux->irmao!=NULL){
        	aux=aux->irmao;
        }
        temp = aux->valor;
		check_definido(tabela_2,aux);
        aux=iteradef2->filho;

        while(aux->irmao!=NULL){
			check_duplicado(tabela_2,aux);
        	if(anterior!=NULL){
        		anterior->next = insert_el(aux->valor,temp,NULL,NULL);
        		anterior=anterior->next;
        	}else{
        		anterior = insert_el(aux->valor,temp,NULL,NULL);
        		tabela_2->elemento=anterior;
        	}
        	aux=aux->irmao;
        }
        iteradef2=iteradef2->irmao;

    }


}
void is_funcdecl(arvore iteraFun,tabela_elementos anterior,tabela_elementos anterior_programa,tabela_simbolos tabela_aux){
	
	tabela_aux->next = (tabela_simbolos) malloc(sizeof(TS));
	tabela_aux=tabela_aux->next;
	char* temp;
	arvore iteradecl=iteraFun->filho->irmao->filho;

	arvore aux = iteraFun->filho;

	if(anterior_programa != NULL){
		anterior_programa->next = insert_el(aux->valor,"function",NULL,NULL);
		anterior_programa=anterior_programa->next;
	}else{
		anterior_programa = insert_el(aux->valor,"function",NULL,NULL);
		tab->next->next->elemento = anterior_programa;
		//tabela_aux->elemento = anterior_programa;
	}
	anterior = insert_el(aux->valor,aux->irmao->irmao->valor,NULL,"return");
	check_definido(tabela_aux,aux->irmao->irmao);
	tabela_aux->elemento = anterior;
	//aux = iteraFun->filho->irmao;



	while(iteradecl!=NULL){

		if(iteradecl->filho==NULL){
            break;// se nao tiveres variaveis declaradas o filho é null logo tens de sair
        }
        aux= iteradecl->filho;
        while(aux->irmao!=NULL){
        	aux= aux->irmao;

        }
        temp=aux->valor;
        check_definido(tabela_aux,aux);
        aux=iteradecl->filho;

        while(aux->irmao!=NULL){
            check_duplicado(tabela_aux,aux);
            if(strcmp(iteradecl->tipo,"Params")==0){ //nao sei o q fazer aqui
            	if(anterior!=NULL){
            		anterior->next=insert_el(aux->valor,temp,NULL,"param");
            		anterior=anterior->next;
            	}else{

            		anterior = insert_el(aux->valor,temp,NULL,"param");
            		tabela_aux->elemento = anterior;
            	}   
            }else{
            	if(anterior!=NULL){
            		anterior->next = insert_el(aux->valor,temp,NULL,"Varparam");
            		anterior = anterior->next;
            	}else{
            		anterior = insert_el(aux->valor,temp,NULL,"Varparam");
            		tabela_aux->elemento = anterior;
            	}
            }   

            aux= aux->irmao;
        }
        iteradecl= iteradecl->irmao;
    }

    check_definido(NULL,iteraFun->filho->irmao->irmao);
}



tabela_simbolos procurar_tabela(char * nome){
	tabela_simbolos tabela_aux = tab->next->next->next;

	while(tabela_aux != NULL){
		if(strcmp(lower(nome),tabela_aux->elemento->nome)== 0){
			return tabela_aux;
		}
		tabela_aux = tabela_aux->next;
	}
	return NULL;
}
