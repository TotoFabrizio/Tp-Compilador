// tabla.h
#ifndef TABLA_H
#define TABLA_H

#include <stdio.h>
#include <stdlib.h>
#include <string.h>


typedef struct {
   char nombre[10];
   int valor;
}Identificador;

typedef struct Nodo{
   Identificador id;
   struct Nodo* sig;
}Nodo;

typedef struct{
   Nodo* cabeza;
   int longitud;
}Lista;


// Declaraciones de funciones
Nodo* crearNodo(Identificador* id);
void insertar(Lista* lista, Identificador* id);
Identificador* buscar(Lista* lista, char identificador[]);
void modificar(Lista* lst, char ident[], int nuevoValor);

#endif
