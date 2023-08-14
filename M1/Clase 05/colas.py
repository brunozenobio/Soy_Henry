class Estructura_cola(object):
    def __init__(self):
        self.__list = []
    
    # Agregar elemento
    def equeue(self, item):
        self.__list.append(item)
    
    # Eliminamos el primero en entrar 
    def dequeue(self):
        return self.__list.pop(0)
    
    # Obtener elemento superior EL primero que sale
    def first(self): 
        if self.__list:
            return self.__list[0]
        else:
            return None
    
    def is_empty(self):
        return self.__list == []
    
    def size(self):
        return len(self.__list)