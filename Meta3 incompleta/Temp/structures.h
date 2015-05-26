#include <stdlib.h>

typedef struct _node {
    
    char *id;
    struct _node *brother;
    struct _node *son;
    char * type;
    char * value;
    
}Node;


Node * make_node(char *name,char *type,char *value,Node *son,Node *brother){
    
    Node *new = malloc(sizeof(Node));
    
    if (name != NULL) {
        new->id = (char*)malloc(strlen(name)*sizeof(char));
        strcpy(new->id,name);
    }
    else new->id = (char*)malloc(sizeof(char));
    
    if (type != NULL) {
        
        //tipo
        new->type = (char*)malloc(strlen(type)*sizeof(char));
        strcpy(new->type,type);
    }
    else {
        new->type = (char*)malloc(sizeof(char));
    }
    if (value != NULL) {

        //valor
        new->value = (char*)malloc(strlen(value)*sizeof(char));
        strcpy(new->value,value);
    }
    else{
        new->value = (char*)malloc(sizeof(char));

    } 

    new->brother = brother;
    new->son = son;
    return new;
}

void addBrother(Node * temp, Node * brother) {
    if (temp == NULL || brother == NULL) return;
    while (temp->brother != NULL) {
        temp = temp->brother;
    }
    temp->brother = brother;
}

void addChild(Node * temp, Node * child) {
    temp->son = child;
}
/*
esta funcao pode dar merda o prof aconselhou a fazer uma versao iterativa para ver os tipos dos dados
*/
void printAll(Node * node,int level) {
    int i;
    if (node == NULL) return;
    for (i = 0; i < level; i++) {
        printf("..");
    }
    //if(strcmp(node->type,"")!=0)
    printf("%s         type=%s, value=%s\n",node->id,node->type,node->value);

    //else
    //printf("%s\n",node->id);

    printAll(node->son,level+1);
    printAll(node->brother,level);
}

Node * check_statlist(Node * temp) {
    if (temp == NULL ) {
        return make_node("StatList",NULL,NULL,NULL,NULL);
    }
    else if (temp->brother == NULL) {
        return temp;
    }
    
    else {
        return make_node("StatList",NULL,NULL,temp,NULL);
        
    }
}

Node * check_statlist2(Node * temp) {

    if (temp == NULL || temp->brother == NULL) {
        return temp;
    }
    
    else {
        return make_node("StatList",NULL,NULL,temp,NULL);
        
    }
}







