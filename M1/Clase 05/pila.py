class Estructura_pila(object):
    def __init__(self):
        self.__list = []
    def push(self,item):
        self.__list.append(item) # Añadimos un elemento al final
    
    def pop(self): # Eliminamos el ultimo elemento
        return self.__list.pop()
    #OBtenemos el elemento superior
    def peak(self):
        if self.__list: # corroboramos si no esta vacia
            return self.__list[-1] # Devolvemos el ultimo elemento si no esta vacia
        else:
            return None
    def is_empty(self): # Verificamos si esta vacia
        if self.__list == []:
            return True
        else:
            return False
    def size(self):
        return len(self.__list)
    def printlist(self):
        print(self.__list)
        