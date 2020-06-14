
typedef enum { typeCon, typeId, typeOpr } nodeEnum;


typedef struct {
	char *value; 
	} conNodeType;


typedef struct {
	char i; 
} idNodeType;


	typedef struct {
	int oper;
	int nops;
	struct nodeTypeTag *op[1]; 
	} oprNodeType;

	typedef struct nodeTypeTag {
		nodeEnum type; 
		union {
			conNodeType con; 
			idNodeType id; 
			oprNodeType opr; 
		};
	} nodeType;
	extern char sym[52]; 