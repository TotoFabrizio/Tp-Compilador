%{
#include <stdio.h>
#include "parser.tab.h"
#include "tabla.h"

// aca defino los prototipos de las funciones auxiliares que voy a estar utilizando
int obtenerValor(char lexema[]);
void actualizarSimbolo(char ident[], int nuevoValor);
int calcularFactorial(int num);


Lista lista;

extern int yylineno;
int yyerror(char *s);
int yylex();

%}

%union {                
    int entero;
    char id[10];
}

/*  defino los tokens */

%token <id> IDENTIFICADOR 
%token TIPO_DE_DATO 
%token <entero> ENTERO
%token <id> SUMA
%token <id> RESTA
%token <id> MULT
%token <id> DIV
%token <id> ASIGNACION 
%token <id> PUNTO_Y_COMA 
%token <id> SALTODELINEA 
%token <id> ESPACIO
%token PRINT
%token FACTORIAL
%token MAYOR
%token COMA
%token START
%token FINISH
%token PARENTESIS_CERRADO
%token PARENTESIS_ABIERTO

/*  defino los tipo de retorno de las reglas */
 
%type <entero> expresion
%type <entero> primaria
%type <entero> suma
%type <entero> resta
%type <entero> mult
%type <entero> mayor

%start inicioPrograma
%left SUMA RESTA
%left MULT
%left FACTORIAL
%left MAYOR
%right ASIGNACION

%%

inicioPrograma: START PUNTO_Y_COMA SALTODELINEA sentencias FINISH PUNTO_Y_COMA

sentencias: declarar_variables
            | printearVariables
            | reasignarVariables
            | printearVariables sentencias
            | reasignarVariables sentencias
            | declarar_variables sentencias
            ;

declarar_variables: TIPO_DE_DATO ESPACIO IDENTIFICADOR ASIGNACION expresion PUNTO_Y_COMA SALTODELINEA {actualizarSimbolo($3,$5);}
                
printearVariables: 
                |PRINT PARENTESIS_ABIERTO IDENTIFICADOR PARENTESIS_CERRADO PUNTO_Y_COMA SALTODELINEA 
                {
                    Identificador* id= buscar(&lista, $3);
                    if(id->valor==-1)
                    {
                        yyerror("Error-La variable no fue declarada\n");
                    }
                    else{
                        int valor=obtenerValor($3);
                        printf("%d\n",valor);
                    }
                }
                

reasignarVariables: IDENTIFICADOR ASIGNACION expresion PUNTO_Y_COMA SALTODELINEA 
                    {
                        Identificador* id = buscar(&lista, $1);
                        if(id ->valor==-1){
                          yyerror("Error-La variable no fue declarada\n");
                        }else{
                          actualizarSimbolo($1,$3);
                        }
                    }
                    
                    
expresion:  primaria{$$=$1}
            |FACTORIAL PARENTESIS_ABIERTO primaria PARENTESIS_CERRADO 
            {
                int valor= $3;
                int fact= calcularFactorial(valor);
                $$=fact;
            }
            |mayor{$$=$1;} 
            |mult{$$=$1;}
            |suma{$$=$1;}
            |resta{$$=$1;}
        

suma: primaria SUMA primaria 
        {
            int a = $1;
            int b = $3;
            int c = a + b;
            $$=c;
        }

resta: primaria RESTA primaria 
        {
            int a = $1;
            int b = $3;
            int c = a - b;
            $$=c;
        }

mult: primaria MULT primaria 
        {
            int a = $1;
            int b = $3;
            int c = a * b;
            $$=c;
        }

mayor:MAYOR PARENTESIS_ABIERTO primaria COMA primaria PARENTESIS_CERRADO{
            int a = $3;
            int b = $5;
            if(a > b){
                $$=a;
            }else{
                $$=b;
            }
        }

primaria: IDENTIFICADOR{
            Identificador* id = buscar(&lista, $1);
            if(id ->valor==-1){
                yyerror("Error-La variable no fue declarada\n");
            }else{
                $$=obtenerValor($1);
            }
    }
        |ENTERO{$$=$1}
        |PARENTESIS_ABIERTO expresion PARENTESIS_CERRADO{$$=$2}


%%              

int calcularFactorial(int num)
{
   int ret=num;
   if(num==1)
   {
      ret=1;
   }
   else
   {
      for(int i=num;i>1;i--)
      {
         int ant=i-1;
         ret=ret*ant;
      }
   }
   return ret;
}

void actualizarSimbolo(char ident[], int nuevoValor){
    modificar(&lista, ident, nuevoValor);
}

int obtenerValor(char lexema[]){
    Identificador* ident = buscar(&lista, lexema);
    return ident->valor;
}

int yyerror(char *texto) {
    fprintf(stderr, "Error sintactico en la linea %d: %s\n", yylineno, texto);
    return 0;
}

int yywrap(){
    return 1;
}
