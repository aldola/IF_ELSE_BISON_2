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
       execute_print {
        printf("\n %c = %d\n",$1.variable+97, c[$1.variable]);
      }
    | execute_set {
        c[$1.variable]=$1.valor; 
        printf("\n %c has been set: %d\n",$1.variable+97, $1.valor); 
      }
    | execute_conditional {
        if ($1.operacio == 2){
          c[$1.variable]=$1.valor; 
          printf("\n %c has been set: %d\n",$1.variable+97, $1.valor); 
        }else if($1.operacio == 1){
           printf("\n %c = %d\n",$1.variable+97, c[$1.variable]);
        }      
      }
;
execute_print:
      PRINT ID { 
        struct dades a = {1,$2};
        $$ = a; 
      }
;
execute_set:  
      ID ASV NUMBER { 
        struct dades a = {2,$1,$3};
        $$ = a;
      } 
;

execute_conditional:
    IF expr_booleana THEN no_exec_inst { 
      if ($2){
        $$ = $4; 
      }else{
        struct dades a = {0};
        $$ = a; 
      }
    } 
    | IF expr_booleana THEN no_exec_inst ELSE no_exec_inst  {
      if ($2){
        $$ = $4; 
      }else{
        $$ = $6;
      }
    } 
;
no_exec_inst: 
      PRINT ID { 
        struct dades a = {1,$2};
        $$ = a;
      }
    | ID ASV NUMBER {
        struct dades a = {2,$1,$3};
        $$ = a;} 
    | IF expr_booleana THEN no_exec_inst {
        if ($2){
          $$ = $4; 
        }else{
          struct dades a = {0};
          $$ = a; 
        }
      } 
    | IF expr_booleana THEN no_exec_inst ELSE no_exec_inst {
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
