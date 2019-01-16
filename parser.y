%{
	#include <stdio.h>
	#include <string.h>
	#include <stdlib.h>
	void yyerror(char*);
	int yylex();
	int liczbaZmiennych = 0;
	char** zmienne;
	int* wartosci;
	int indeksZmiennej(char *nazwa);
%}

%union {
    int iValue;
	char *vName;
};

%start S
%token <iValue> LICZBA 
%type <iValue> E
%type <vName> ZMIENNA
%token UNK PRINT ZMIENNA 

%%
S : ZADANIE ';' S
  | /*nic*/
  ;

ZADANIE : PRINT E {printf("%d",$2);}
		| ZMIENNA '=' E {
			if(indeksZmiennej($1)>=0)
			{
				printf("zmienna %s istnieje, przypisano do niej wartosc %d\n",$1,$3);
				wartosci[indeksZmiennej($1)] = $3;
			}
			else
			{
				printf("zmienna %s nie istnieje, utworzono ja i przypisano do niej wartosc %d\n",$1,$3);
				zmienne = realloc(zmienne, sizeof(char*) * (liczbaZmiennych+1));
				wartosci = realloc(wartosci, sizeof(int) * (liczbaZmiennych+1));
				zmienne[liczbaZmiennych] = $1;
				wartosci[liczbaZmiennych] = $3;
				liczbaZmiennych += 1;
			}
		}
		;

E : LICZBA	{$$ = $1;}
  | ZMIENNA {$$ = wartosci[indeksZmiennej($1)]; printf("indeks pobieranej zmiennej to %d\n",indeksZmiennej($1));}
  | E '+' E {$$ = $1 + $3;}
  | E '*' E {$$ = $1 * $3;}
  | E '-' E {$$ = $1 - $3;}
  | E '/' E {$$ = $1 / $3;}
  ;
%%
int main()
{
	yyparse();
}
void yyerror(char* str)
{
	printf("%s",str);
}
int yywrap()
{
	return 1;
}
int indeksZmiennej(char *nazwa)
{
	for(int i = 0; i<liczbaZmiennych; i++)
	{
		if(strcmp(nazwa,zmienne[i]) == 0)
			return i;
	}
	return -1;
}