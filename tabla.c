// tabla.c
#include "tabla.h"

Nodo* crearNodo(Identificador* id)
{
   Nodo* nuevo= (Nodo*)malloc(sizeof(Nodo));    //creo el nuevo nodo
   strcpy(nuevo->id.nombre,id->nombre);
   nuevo->id.valor= id->valor;
   nuevo -> sig= NULL;
   return nuevo;
}

void insertar(Lista* lista, Identificador* id)
{

   Nodo* nuevo= crearNodo(id);
   Nodo* aux=lista->cabeza;

   if(aux!=NULL)
   {
      while(aux -> sig != NULL)
      {
         aux= aux -> sig;
      }
      aux->sig=nuevo;
   }
   else
   {
      lista->cabeza=nuevo;
   }

   lista->longitud++;
}

Identificador* buscar(Lista* lista, char identificador[])
{
   Identificador* ret=NULL;

   Nodo* aux= lista->cabeza;
   while(aux!=NULL && strcmp(aux->id.nombre,identificador)!=0 )
   {
      aux=aux->sig;
   }
   if(aux!=NULL) //si lo encontro
   {
      ret= &(aux->id);     //retorno la direccion de memoria del identificador
   }
   return ret;
}

void modificar(Lista* lst, char ident[], int nuevoValor)
{
   Identificador* id= buscar(lst,ident);
   id ->valor=nuevoValor;
}

void recorrerLista(Lista lst)
{
   Nodo* aux= lst.cabeza;
   while(aux!=NULL)
   {
      printf("ident: %s", aux->id.nombre);
      printf(", valor= %d\n", aux->id.valor);
      aux=aux->sig;
   }
}

Lista crearLista(){
   Lista lst;
   lst.cabeza=NULL;
   lst.longitud=0;
   return lst;
}



