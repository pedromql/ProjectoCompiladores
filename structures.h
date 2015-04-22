#include <stdlib.h>

typedef struct _node {
    char *id;
    struct _node *brother;
    struct _node *son;
    
}Node;


Node * make_node(char *name,Node *son,Node *brother){
    
    Node *new = malloc(sizeof(Node));
    
    if (name != NULL) {
        new->id = (char*)malloc(strlen(name)*sizeof(char));
        strcpy(new->id,name);
    }
    else new->id = (char*)malloc(sizeof(char));
    
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

void printAll(Node * node,int level) {
    int i;
    if (node == NULL) return;
    for (i = 0; i < level; i++) {
        printf("..");
    }
    printf("%s\n",node->id);
    printAll(node->son,level+1);
    printAll(node->brother,level);
}

Node * check_statlist(Node * temp) {
    if (temp == NULL ) {
        return make_node("StatList",NULL,NULL);
    }
    else if (temp->brother == NULL) {
        return temp;
    }
    
    else {
    	return make_node("StatList",temp,NULL);
        
    }
}

Node * check_statlist2(Node * temp) {
    if (temp == NULL || temp->brother == NULL) {
        return make_node("StatList",NULL,NULL);
    }
    
    else {
    	return make_node("StatList",temp,NULL);
        
    }
}







