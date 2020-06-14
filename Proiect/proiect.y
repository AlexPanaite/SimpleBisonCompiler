%{
#include <stdio.h>
#include <stdlib.h>
#include <stdarg.h>
#include <math.h>
#include <string.h>
#include <ctype.h>

extern FILE *yyout;
void yyerror(char *s);
char* itoa(int val, int base);
char *strremove(char *str, const char *sub);
int yylex();
char *sym[52];

%}
%union {
	int iVal; 
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
%type <str> program function stmt assign expr

%%
program: function { fprintf(yyout, "\"%s\"\n", $1); }
		
		| program function { fprintf(yyout, "\"%s\"\n", $2); }
;

function: stmt { $$=$1; }
;

stmt: ';' { $$ = "\n"; }

	| expr ';' { $$ = $1; }
	
	| assign ';' { $$ = $1; }
	
	| PRINT expr ';' { $$ = $2;}
	;
	
assign:
	VAR '=' expr { sym[$1] = $3; $$=$3; }
	| VAR '=' expr '.' assign {sym[$1] = $3; $$=$3; }
	;
	
expr:
	INT { $$= itoa($1,10);  }
	
	| VAR { $$ = sym[$1]; }
	
	| STRING { $$ = strdup($1); }
	
	| DEC expr
	{ $2[0]=$2[0]-1; $$=$2;  }
	
	| expr DEC
	{ $1[strlen($1)-1]=$1[strlen($1)-1]-1; }
	
	| INC expr
	{ $2[0]=$2[0]+1; $$=$2; }
	
	| expr INC
	{ $1[strlen($1)-1]=$1[strlen($1)-1]+1; }
	
	| LEN expr
	{
		$$ = itoa(strlen($2),10);
	}
	
	| UL expr
	{ char *t = strdup($2);
	  int len = strlen($2);
	  for(int i=0;i<len;i++)
	  {
		  if(islower(t[i])>0)
            t[i]=toupper(t[i]);
            else
            t[i]=tolower(t[i]);
	  }
		$$=strdup(t);
	  
	}
	
	| expr '+' expr
	{ sprintf($$,"%s%s", $1, $3);  }
	
	| expr '-' expr
	{ char *a = strdup($1);
	  char *b = strdup($3);
	  $$= strremove(a,b);
	}
	
	| expr '*' INT
	{ char *p = strdup($1);
		for(int i=2;i<=$3;i++)
		{
		 strcat(p,$1);
		}
		$$=strdup(p);
	}		
	
	| expr FIRST INT
	{ 	int len = strlen($1);
		char *k = strdup($1);
		k[len-(len-$3)] = '\0';
		$$ = strdup(k);
	}
	
	| expr '/' INT
	{ 	int len = strlen($1);
		int cut = len - $3;
		$$=$$ + cut;
	}
	
	| expr '<' expr
	{ if(strcmp($1,$3) < 0) $$="1"; else $$="0";}
	
	| expr '>' expr
	{ if(strcmp($1,$3) > 0) $$="1"; else $$="0";}
	
	| expr GE expr
	{ if(strcmp($1,$3) >= 0) $$="1"; else $$="0";}
	
	| expr LE expr
	{ if(strcmp($1,$3) <= 0) $$="1"; else $$="0";}
	
	| expr NE expr
	{ if(strcmp($1,$3) != 0) $$="1"; else $$="0";}
	
	| expr EQ expr
	{ if(strcmp($1,$3) == 0) $$="1"; else $$="0";}
	
	| '(' expr ')'
	{ $$ = $2; }
	;
%%
void yyerror(char *s) {
	fprintf(stdout, "%s\n", s);
}

char *strremove(char *str, const char *sub) {
    size_t len = strlen(sub);
    if (len > 0) {
        char *p = str;
        size_t size = 0;
        while ((p = strstr(p, sub)) != NULL) {
            size = (size == 0) ? (p - str) + strlen(p + len) + 1 : size - len;
            memmove(p, p + len, size - (p - str));
        }
    }
    return str;
}

char* itoa(int val, int base){
	
	static char buf[32] = {0};
	
	int i = 30;
	
	for(; val && i ; --i, val /= base)
	
		buf[i] = "0123456789abcdef"[val % base];
	
	return &buf[i+1];
	
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
