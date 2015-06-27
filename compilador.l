
%{
#include "dades.h"
#include "compilador.tab.h"
%}
DIGIT [0-9] 
identificador [a-z]
%x con
%%

":=" { return(ASV); } 
">" { return(MGQ); }
"<" { return(MPQ); }
"!=" { return(DFQ); }
"==" { return(IGQ); }
{identificador} { yylval.number = yytext[0]-97; return(ID);}
-?{DIGIT}+ { yylval.number = strtol(yytext, NULL, 10); return(NUMBER); }
else { return(ELSE); } 
if { return(IF); }
then { return(THEN); } 
print { return(PRINT); }
