%{
#include <stdio.h>
#include <stdlib.h>
#include <stdarg.h>
#include <math.h>
#include <string.h>
#include <ctype.h>
#include "arbore.h"


extern FILE *yyin;
extern FILE *yyout;
void freeNode(nodeType *p);
int ex(nodeType *p);
void yyerror(char *s);
char sym[52];
nodeType * opr(int oper, int nops, ...);
nodeType * id(char i);
nodeType * con(char *value);
int yylex(void);


%}
%union {
	nodeType *nPtr;
	char *iVal; 
	char sIndex;
	char *str;
	
};
%token <iVal> INT
%token <sIndex> VAR
%token <str> STRING
%token PRINT
%right INC DEC LEN UL
%left '*' '/' FIRST
%left '+' '-'
%left GE LE EQ NE '>' '<'
%type <nPtr> program function stmt assign expr

%%
program: function { ex($1); freeNode($1); }
		
		| program function { ex($1); freeNode($2); }
;

function: stmt { $$=$1; }
;

stmt: ';' { $$ = opr(';',2,NULL,NULL);}

	| expr ';' { $$ = $1; }
	
	| assign ';' { $$ = $1; }
	
	| PRINT expr ';' { $$ = opr(PRINT,1,$2);}
	;
	
assign:
	VAR '=' expr { $$=opr('=',2, id($1), $3);}
	| VAR '=' expr '.' assign {$$=opr('=',2, id($1), $3); }
	;
	
expr:
	INT {  $$ = con(strdup($1));  }
	
	| VAR { $$ = opr(';',1,id($1)); }
	
	| STRING { $$ = con(strdup($1)); }
	
	| DEC expr
	{ $$= opr('--i',1,$2);}
	
	| expr DEC
	{ $$= opr('i--',1,$1); }
	
	| INC expr
	{ $$= opr('++i',1,$2); }
	
	| expr INC
	{ $$= opr('i++',1,$1); }
	
	| LEN expr
	{ $$= opr('~',1,$2);}
	
	| UL expr
	{ $$= opr('^',1,$2);}
	
	| expr '+' expr
	{ $$=opr('+', 2,$1, $3); }
	
	| expr '-' expr
	{ 	$$=opr('-', 2,$1, $3);}
	
	| expr '*' INT
	{ $$=opr('*', 2,$1, con($3));
	}		
	
	| expr FIRST INT
	{ 	$$=opr('#', 2,$1, con($3));
	}
	
	| expr '/' INT
	{ 	$$=opr('/', 2,$1, con($3));
	}
	
	| expr '<' expr
	{ $$=opr('<', 2,$1, $3);}
	
	| expr '>' expr
	{ $$=opr('>', 2,$1, $3);}
	
	| expr GE expr
	{ $$=opr('GE', 2,$1, $3);}
	
	| expr LE expr
	{ $$=opr('LE', 2,$1, $3);}
	
	| expr NE expr
	{ $$=opr('NE', 2,$1, $3);}
	
	| expr EQ expr
	{ $$=opr('EQ', 2,$1, $3);}
	
	| '(' expr ')'
	{ $$ = $2; }
	;
%%

nodeType *con(char *value) { 
nodeType *p;


if ((p = malloc(sizeof(nodeType))) == NULL) 
	yyerror("out of memory");


p->type = typeCon;
p->con.value = value;

return p;
}

nodeType *id(char i) { nodeType *p;


if ((p = malloc(sizeof(nodeType))) == NULL) yyerror("out of memory");

p->type = typeId;
p->id.i = i;

return p;
}

nodeType *opr(int oper, int nops, ...) 
{ 
va_list ap;
nodeType *p; 
int i;


if ((p = malloc(sizeof(nodeType) + (nops-1) * sizeof(nodeType *))) == NULL)
yyerror("out of memory");
 
p->type = typeOpr;
p->opr.oper = oper; 
p->opr.nops = nops; 
va_start(ap, nops);
for (i = 0; i < nops; i++)
	p->opr.op[i] = va_arg(ap, nodeType*); 
va_end(ap);
return p;
}

void freeNode(nodeType *p) { int i;

if (!p) return;
if (p->type == typeOpr) {
for (i = 0; i < p->opr.nops; i++) freeNode(p->opr.op[i]);
}
free (p);
}

void yyerror(char *s) { fprintf(stdout, "%s\n", s);
}


 
int main(int argc, char *argv[])
{ 
    extern FILE *yyin, *yyout;
    if (argc == 3)
        {
            yyin = fopen(argv[1],"r");
            yyout = fopen(argv[2],"w");
			yyparse(); 
        }
        else
		{
			yyin=stdin;
			yyout=stdout;
			printf("Preluam datele din consola !\n");
			yyparse();  
		}
    fclose(yyin);
    fclose(yyout);
	
	return 1;
}
