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









