%{
#include<stdio.h>
#include <math.h>
#include <stdlib.h>
#define YYSTYPE double
float factorial(int n)
{
	if (n == 1)
	return 1;
	return (n * factorial(n-1));
}
%}

%token NUMBER MOD PIVAL
%token PLUS MINUS DIV MUL POW SQRT OPENBRACKET CLOSEBRACKET UNARYMINUS
%token SIN COS TAN COT SEC COSEC INC DEC FACTORIAL
%left PLUS MINUS MUL DIV UNARYMINUS LOG LOG10
%%

lines	:	lines expr '\n'	{ printf("%g\n", $2); }
	|	lines '\n'
	|
	;
expr:   pow
        ;

pow: add
        | pow POW add { $$ = pow($1,$3); }
	| SQRT OPENBRACKET expr CLOSEBRACKET { $$ = sqrt($3) ; }
        ;
add: mul
        | add PLUS mul  { $$ = $1 + $3;}
        | add MINUS mul { $$ = $1 - $3; }
        ;
mul: unary
        | mul MUL unary { $$ = $1 * $3; }
        | mul DIV unary { $$ = $1 / $3; }
        | mul MOD unary { $$ = fmod($1,$3); }
        ;
unary: post
        | MINUS primary %prec UNARYMINUS { $$ = -$2; }
        | INC unary { $$ = $2+1; }
        | DEC unary { $$ = $2-1; }
        | LOG unary { $$ = log($2); }
        | LOG10 unary { $$ = log10($2); }
        ;
post   : primary
        | post INC { $$ = $1+1; }
        | post DEC { $$ = $1-1; }
        ;
primary:
         PIVAL { $$ = M_PI; }
        | OPENBRACKET expr CLOSEBRACKET { $$ = $2; }
        | function
        ;
function: SIN OPENBRACKET expr CLOSEBRACKET
               { $$ = sin($3); }
        | COS OPENBRACKET expr CLOSEBRACKET
               { $$ = cos($3); }
        | TAN OPENBRACKET expr CLOSEBRACKET
               { $$ = tan($3); }
        | COT OPENBRACKET expr CLOSEBRACKET
               { $$ = 1/tan($3); }
        | SEC OPENBRACKET expr CLOSEBRACKET
               { $$ = 1/cos($3); }
        | COSEC OPENBRACKET expr CLOSEBRACKET
               { $$ = 1/sin($3); }
	| FACTORIAL OPENBRACKET expr CLOSEBRACKET
		{ $$ = factorial((int)$3);}
	| NUMBER 
        ;
%%

#include <stdio.h>
#include "lex.yy.c"
void yyerror(const char *s)
 {    
 fprintf(stderr, "%s\n", s);	 
 } 
int main(void) 
 {    	while(1){
 	yyparse();    
	}
 return 0;
 }

