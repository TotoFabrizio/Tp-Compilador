%{
#include "parser.tab.h"
#include <string.h>
#include <stdlib.h>
#include "tabla.h"

int yyerror(char* s);
void yyparse();
void errorLexico(char *texto);

int verificarRangoEntero(char*ptr);

extern Lista lista;
%}

/*SECCION DE OPCIONES*/
/*Para que flex lea solo un fichero de entrada*/
%option noyywrap
/*Para obtener el numero de linea*/
%option yylineno


CARACTER   [a-z]
DIGITO     [0-9]
NUMERO      [0-9]+
IDENTIFICADOR {CARACTER}({CARACTER}|{DIGITO})*

%%

"int"                   { return TIPO_DE_DATO; }
"start"                 { return START;}
"finish"                { exit(EXIT_SUCCESS);}
"factorial"             { return FACTORIAL; }
"print"                 { return PRINT; }
"mayor"                 { return MAYOR;}
"("                     { return PARENTESIS_ABIERTO;}
")"                     { return PARENTESIS_CERRADO;}
","                     { return COMA;}
"+"                     { return SUMA; }
"-"                     { return RESTA; }
"*"                     { return MULT; }
"="                     { return ASIGNACION; }
";"                     { return PUNTO_Y_COMA; }
\n                      { return SALTODELINEA; }
" "                     { return ESPACIO;}
{IDENTIFICADOR}  { 
    if (strlen(yytext) > 10)
    {
        errorLexico("Identificador excede la longitud máxima de 10 caracteres");
    } 
    else {
        Identificador* buscado = buscar(&lista, yytext);
        if (buscado == NULL)
        {
            Identificador ident;
            strcpy(ident.nombre, yytext);  
            ident.valor = -1;
            insertar(&lista, &ident);            
        }
    }
    strcpy(yylval.id, yytext); 
    return IDENTIFICADOR;
}

{NUMERO}                { verificarRangoEntero(yytext); yylval.entero = atoi(yytext); return ENTERO; }

.                       { errorLexico("Caracter no valido"); }


%%

void errorLexico(char *texto){
    fprintf(stderr, "Error lexico en la linea %d: %s\n", yylineno, texto);
}

int main(int argc, char *argv[]) {
    if(argc == 2) 
    {
        if(yyin = fopen(argv[1], "rt"))
        {
            printf("\nEl archivo se abrio en forma correcta \n");
            yyparse();
            getchar();
            fclose(yyin);
        }
        else
          printf("\nEl archivo no existe. \n");  
    }
    else {
    printf("\nNo se pudo abrir el archivo correctamente. \n");
    } 
    
    return 0;       
}

int verificarRangoEntero(char*ptr){
    int value = atoi(ptr);
    if(value < -32768 || value > 32767){
        errorLexico("Error: variable fuera de rango");
        return 0;
    }
    return 0;
}