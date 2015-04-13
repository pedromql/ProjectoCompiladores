

typedef struct _node {
	char *id;
	Node *brother,*son;
	
}Node;


Node *make_node(char *name,Node *brother,Node *son){
	
	Node *new = malloc(sizeof(Node));
	strcpy(new->id,name);
	new->brother = brother;
	new->son = son;
	return new;
}