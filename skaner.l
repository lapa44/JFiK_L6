%{
#include "string.h"
#include "y.tab.h"
int yyparse();
int yywrap();
%}
%%
"PRINT" return PRINT;
[a-zA-Z]+ {
	yylval.vName = malloc(strlen(yytext)*sizeof(char));
	strcpy(yylval.vName,yytext);
	return ZMIENNA;
}
[0-9]+ {
	yylval.iValue = atoi(yytext);
	return LICZBA;
	}
[+\-*^/=;] {
	return yytext[0];
	}
[ \t\n] ;
.	{
	return UNK;
	}
%%