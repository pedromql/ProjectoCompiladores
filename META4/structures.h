#include <stdlib.h>

typedef struct _node {
    
    char *id;
    struct _node *brother;
    struct _node *son;
    char * type;
    char * value;
    int line;
    int col;
    
}Node;


//create new node and return it
Node * make_node(char *name,char *type,char *value,Node *son,Node *brother, int line, int col){
    
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
    new->line = line;
    new->col = col;

    return new;
}

//add a node as a brother
void addBrother(Node * temp, Node * brother) {
    if (temp == NULL || brother == NULL) return;
    while (temp->brother != NULL) {
        temp = temp->brother;
    }
    temp->brother = brother;
}

//add a child to a node
void addChild(Node * temp, Node * child) {
    temp->son = child;
}


//print ast in postfix notation
void printAll(Node * node,int level) {
    int i;
    if (node == NULL) return;
    for (i = 0; i < level; i++) {
        printf("..");
    }
    //if(strcmp(node->type,"")!=0)
    //        printf("%s         type=%s, value=%s\n",node->id,node->type,node->value);

    //else
    printf("%s\n",node->id);

    printAll(node->son,level+1);
    printAll(node->brother,level);
}

//check statlist sons, if its null create one, if it has no brothers return, else create new node with 
Node * check_statlist(Node * temp, int line, int col) {
    if (temp == NULL ) {
        return make_node("StatList",NULL,NULL,NULL,NULL,line,col);
    }
    else if (temp->brother == NULL) {
        return temp;
    }
    
    else {
        return make_node("StatList",NULL,NULL,temp,NULL,line,col);
        
    }
}

//if it has no brothers or it´s  null return it , else create new node with "temp" as a brother
Node * check_statlist2(Node * temp, int line, int col) {

    if (temp == NULL || temp->brother == NULL) {
        return temp;
    }
    
    else {
        return make_node("StatList",NULL,NULL,temp,NULL,line,col);
        
    }
}







