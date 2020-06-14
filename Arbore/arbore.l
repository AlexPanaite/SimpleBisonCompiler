%{
#include <stdlib.h>
#include <string.h>
#include "arbore.h" 
#include "arbore.tab.h"


void yyerror(char *);
char* getstring(char *s);
%}
%%
[a-z] {yylval.sIndex = *yytext - 'a'; return VAR;}

\"[^\"]*\" {yylval.str = getstring(strdup(yytext)); return STRING; }

[0-9]+ {yylval.iVal= strdup(yytext); return INT;}


[-()<>=+*/;{}.] { return *yytext;}

"#" { return FIRST; }

"^" { return UL; }

"~" { return LEN; }

"++" { return INC; }

"--" { return DEC; }

">=" { return GE; }

"<=" { return LE; }

"==" { return EQ; }

"!=" { return NE; }

"print" { return PRINT; }

[ \t\n]+ ; /* Spatiile sunt ignorate */

. yyerror(" Caracter ilegal!\n");

%%
char *getstring (char *s){
	if(strlen(s)> 2)
	{ 
		s++; 
		s[strlen(s)-1] = 0;
	}
	return s;
}


int yywrap(void) {
return 1;
}
