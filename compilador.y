
%{

#include <stdio.h>

int c[25];

struct dades 
{ 
  int operacio; 
  int variable; 
  int valor; 
}; 

%}
%type <ovv_var> no_instancia 
%type <number> valor expr_booleana

%token <number> NUMBER ID
%token PRINT ASV

%left MGQ MPQ DFQ IGQ

%right IF THEN ELSE

%union
{
  int number;
  struct dades ovv_var;
}

%%

programa:
	instancia
	| programa instancia;
;

instancia:
       PRINT ID {
        printf("\n %c = %d\n",$2+97, c[$2]);
      }
    | ID ASV NUMBER {
        c[$1]=$3; 
        printf("\n %c conte: %d\n",$1+97, $3); 
      }
    | IF expr_booleana THEN no_instancia { 
      if ($2){
        if ($4.operacio == 2){
          c[$4.variable]=$4.valor; 
          printf("\n %c conte: %d\n",$4.variable+97, $4.valor); 
        }else if($4.operacio == 1){
           printf("\n %c = %d\n",$4.variable+97, c[$4.variable]);
        }    
      }
    } 
    | IF expr_booleana THEN no_instancia ELSE no_instancia  {
      if ($2){
        if ($4.operacio == 2){
          c[$4.variable]=$4.valor; 
          printf("\n %c conte: %d\n",$4.variable+97, $4.valor); 
        }else if($4.operacio == 1){
           printf("\n %c = %d\n",$4.variable+97, c[$4.variable]);
        }    
      }else{
        if ($6.operacio == 2){
          c[$6.variable]=$6.valor; 
          printf("\n %c conte: %d\n",$6.variable+97, $6.valor); 
        }else if($6.operacio == 1){
           printf("\n %c = %d\n",$6.variable+97, c[$6.variable]);
        }    
      }
    } 
;
    
no_instancia: 
      PRINT ID { 
        struct dades a = {1,$2};
        $$ = a;
      }
    | ID ASV NUMBER {
        struct dades a = {2,$1,$3};
        $$ = a;} 
    | IF expr_booleana THEN no_instancia {
        if ($2){
          $$ = $4; 
        }else{
          struct dades a = {0};
          $$ = a; 
        }
      } 
    | IF expr_booleana THEN no_instancia ELSE no_instancia {
        if ($2){
          $$ = $4; 
        }else{
          $$ = $6;
        }
      } 
;

expr_booleana: 
	 valor MGQ valor  {$$=(int)$1>$3;}
	|valor MPQ valor  {$$=(int)$1<$3;}
	|valor DFQ valor  {$$=(int)$1!=$3;}
	|valor IGQ valor  {$$=(int)$1==$3;}
;

valor:
	ID
	|NUMBER
;
	

%%
int yyerror(){return 0;}
int yywrap(){ return 1; }

int main() {
 
  return yyparse();
}
