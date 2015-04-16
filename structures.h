#include <stdlib.h>

typedef struct _node {
	char *id;
	struct _node *brother;
	struct _node *son;
	
}Node;


Node *make_node(char *name,Node *brother,Node *son){
	
	Node *new = malloc(sizeof(Node));
	new->id = (char*)malloc(strlen(name)*sizeof(char));
	strcpy(new->id,name);
	new->brother = brother;
	new->son = son;
	return new;
}

void addBrother(Node * temp, Node * brother) {
	while (temp->brother != NULL) {
		temp = temp->brother;
	}
	temp->brother = brother;
}

void addChild(Node * temp, Node * child) {
	temp->son = child;
}

void printAll(Node * node) {
	if (node == NULL) return;
	printf("bla bla bla%s\n",node->id);
	printAll(node->son);
	printAll(node->brother);
}


