-- EJERCICIO 1
/*
¿Qué tan actualizada está la información? ¿La forma en que se actualiza ó mantiene esa información se puede mejorar?
RESPUESTA:
Podria mejorarse agregando campos de fecha de modifcacion a otras tablas asi como lo tiene en la tabla cliente.
La tabla canal de ventas esta actualizada a 2021

*/


-- EJERCICIO 2
/*
¿Los datos están completos en todas las tablas?
RESPUESTA:
Los datos no estan completos , por ejemplo:
Tabla cliente:provincia y localidad en algunos registros estan vacios
Producto:Hay algunos con tipo vacio

*/
-- EJERCICIO 3

/*
¿Se conocen las fuentes de los datos?

RESPUESTA:
Las fuentes de los datos son de una carpeta donde estan los archivos excel y csv de los cuales las tablas:
Empleado: personal administrativo RRHH
proveedores: Analista de otra direccion que no esta mas en la empresa
Clientes:CRM de la empresa
productos:Otro analsita
ventas,gastos y compras: Generado por el sistema de transaccion de la empresa
*/

-- EJERCICIO 4
/*
Al integrar éstos datos, es prudente que haya una normalización respecto de nombrar las tablas y sus campos.
RESPUESTA:
Si es prudente que la haya
*/

-- EJERCICIO 5
/*
Es importante revisar la consistencia de los datos:
	a¿Se pueden relacionar todas las tablas al modelo?
	b¿Cuáles son las tablas de hechos y las tablas dimensionales o maestros?
	c¿Podemos hacer esa separación en los datos que tenemos (tablas de hecho y dimensiones)?
	d¿Hay claves duplicadas?
	e¿Cuáles son variables cualitativas y cuáles son cuantitativas?
	f¿Qué acciones podemos aplicar sobre las mismas?
    
RESPUESTA:
a:Se pueden relacionar tablas pero no entre todas
b,c:
Tablas de DIMENSIONES : canal_venta,cliente,empleado,producto,proveedor,sucursal,tipo_gasto
Tablas de HECHOS :  compra,gasto,venta

d: TABLAS CON DUPLICADOS:
empleado,

e,f:
Las variables cuantitativas son las referentes a la cantidada de ventas o de productos los precios,la longitud la latitud
Sobre estas se pueden calcular promedios cantidades etc
Las variables cualitativas son las referentes a telefonos codigo id, nombre de personas o direcciones, o tipo como sucursales

*/

SELECT count(*) as cantidad_duplicados
FROM empleado
GROUP BY ID_empleado
HAVING cantidad_duplicados > 1;

-- EJERCICIO 7 # compra


-- Genero los tipos de datos correctos

## TABLA CLIENTE
UPDATE cliente
SET Longitud = '0' WHERE Longitud = '';
UPDATE cliente SET Latitud = '0' WHERE Latitud = '';
UPDATE cliente SET Longitud = CAST(REPLACE(Longitud,',','.') as DECIMAL (15,9));
UPDATE cliente SET Latitud = CAST(REPLACE(Latitud,',','.') as DECIMAL (15,9));

ALTER TABLE cliente
CHANGE Longitud  Longitud DECIMAL(15,9),
CHANGE Latitud  Latitud DECIMAL(15,9);
ALTER TABLE cliente DROP col10;
## TABLA COMPRA
UPDATE compra
SET Precio = CAST(SUBSTRING_INDEX(Precio,' ',1) as DECIMAL(10,2));
ALTER TABLE compra CHANGE Precio Precio DECIMAL(10,2);

## TABLA GASTO
ALTER TABLE gasto CHANGE Monto Monto DECIMAL(6,2);
UPDATE gasto
SET Monto = CAST(Monto as DECIMAL(6,2));


## TABLA TIPOGASTO
UPDATE tipo_gasto
SET Monto_aproximado = CAST(Monto_aproximado as DECIMAL(6,2));

## TABLA SUCURSAL

-- ATENCION ...
-- LO CORRECTO SERIA CREAR DOS NUEVOS CAMPOS IGUALARLOS AL REMPLAZO de , por .
--  Y LUEGO MODIFCAR LOS VALORES
UPDATE sucursal SET Longitud = '0' WHERE Longitud = '';
UPDATE sucursal SET Latitud = '0' WHERE Latitud = '';
UPDATE sucursal SET Longitud = CAST(REPLACE(Longitud,',','.') as DECIMAL (15,9));
UPDATE sucursal SET Latitud = CAST(REPLACE(Latitud,',','.') as DECIMAL (15,9));
ALTER TABLE sucursal
CHANGE Longitud  Longitud DECIMAL(15,9),
CHANGE Latitud  Latitud DECIMAL(15,9);


## TABLA VENTA
UPDATE venta SET Precio = '0' WHERE Precio = '';
UPDATE venta SET Precio = CAST( Precio as DECIMAL (13,4));

ALTER TABLE venta
CHANGE  Precio  Precio DECIMAL(15,4);

ALTER TABLE venta
CHANGE 	Cantidad  Cantidad DECIMAL(15,9);
-- LO MA CORRECTO PARA ESTABLECER EN LOS VACIAS SERIA BUSCAR LA MEDIA Y VERIFICAR OUTLIERS
ALTER TABLE venta  ADD Cantidad2 DECIMAL(10,0) DEFAULT '1' AFTER Cantidad;
UPDATE venta SET Cantidad2 = Cantidad WHERE Cantidad != '\r';
UPDATE venta SET Cantidad = Replace(Cantidad,'\r','');
DROP TABLE IF EXISTS `aux_venta`;
CREATE TABLE IF NOT EXISTS `aux_venta` (
  `IdVenta`				INTEGER,
  `Fecha` 				DATE NOT NULL,
  `Fecha_Entrega` 		DATE NOT NULL,
  `IdCliente`			INTEGER, 
  `IdSucursal`			INTEGER,
  `IdEmpleado`			INTEGER,
  `IdProducto`			INTEGER,
  `Precio`				FLOAT,
  `Cantidad`			INTEGER,
  `Motivo`				INTEGER
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish_ci;
INSERT INTO aux_venta (IdVenta, Fecha, Fecha_Entrega, IdCliente, IdSucursal, IdEmpleado, IdProducto, Precio, Cantidad, Motivo)
SELECT IdVenta, Fecha, FechaEntrega, IdCliente, Idsucursal, IdEmpleado, IdProducto, Precio, 0, 1
FROM venta WHERE Cantidad = '' or Cantidad is null;
ALTER TABLE venta DROP Cantidad;
ALTER TABLE venta CHANGE Cantidad2 Cantidad INTEGER;

UPDATE venta v
JOIN producto p ON v.IdProducto = p.IdProducto
SET  v.Precio = p.Precio
WHERE v.Precio = 0;


## Nombres de campos

##CLIENTE
ALTER TABLE cliente CHANGE  ID_cliente IdCliente INT NOT NULL;
ALTER TABLE cliente CHANGE Nombre_Apellido NombreApellido VARCHAR(70);
ALTER TABLE cliente CHANGE Fecha_Alta FechaAlta DATE;
ALTER TABLE cliente CHANGE Usuario_Alta UsuarioAlta VARCHAR(40);
ALTER TABLE cliente CHANGE Fecha_Modificacion FechaModificacion Date;
ALTER TABLE cliente CHANGE Usuario_Modificacion UsuarioModificacion VARCHAR(30);
ALTER TABLE cliente CHANGE Marca_Baja MarcaBaja TINYINT;

##COMPRA
ALTER TABLE compra CHANGE  ID_compra IdCompra INT NOT NULL;
ALTER TABLE compra CHANGE  ID_producto IdProducto INT NOT NULL;
ALTER TABLE compra CHANGE  ID_proveedor IdProveedor INT NOT NULL;

##EMPLEADO
ALTER TABLE empleado CHANGE  ID_empleado IdEmpleado INT NOT NULL;
##GASTO
ALTER TABLE gasto  CHANGE ID_gasto IdGasto INT NOT NULL;
ALTER TABLE gasto  CHANGE ID_sucursal Idsucursal INT ;
ALTER TABLE gasto  CHANGE ID_tipo_gasto IdTipoGasto INT ;
##PRODUCTO

ALTER TABLE producto CHANGE  ID_producto IdProducto INT ;
##PROVEEDOR
ALTER TABLE proveedor CHANGE  ID_proveedor IdProveedor INT NOT NULL;

##SUCURSAL

ALTER TABLE tipo_gasto  CHANGE ID_tipo_gasto IdTipoGasto INT NOT NULL ;

##VENTA

ALTER TABLE venta CHANGE ID_venta IdVenta INT NOT NULL;
ALTER TABLE venta CHANGE Fecha_Entrega FechaEntrega INT ;
ALTER TABLE venta CHANGE ID_canal IdCanal INT NOT NULL;
ALTER TABLE venta CHANGE ID_cliente IdCliente INT ;
ALTER TABLE venta  CHANGE ID_sucursal Idsucursal INT ;
ALTER TABLE venta CHANGE  ID_empleado IdEmpleado INT ;
ALTER TABLE venta CHANGE  ID_producto IdProducto INT ;


##TIPO GASTO
ALTER TABLE tipo_gasto CHANGE  Montoaproximado MontoAproximado VARCHAR(50) ;

#CALENDARIO

ALTER TABLE calendario CHANGE id IdCalendario INT NOT NULL;
ALTER TABLE calendario CHANGE fecha Fecha DATE;
ALTER TABLE calendario CHANGE anio Anio INT;
ALTER TABLE calendario CHANGE mes Mes INT ;
ALTER TABLE calendario CHANGE dia Dia INT ;
ALTER TABLE calendario CHANGE trimestre Trimestre INT;
ALTER TABLE calendario CHANGE semana Semana INT ;
ALTER TABLE calendario CHANGE dia_nombre DiaNombre VARCHAR(9);
ALTER TABLE calendario CHANGE mes_nombre MesNombre VARCHAR(9);


-- EJERCICIO 7, SUCURSAL,PROVEEDOR,EMPEADO Y CLIENTE

# suursal,proveedor,empleado,cliente
UPDATE sucursal SET Nombre = 'Valor faltante' WHERE Nombre = '' OR Nombre is null; -- Es buena practica usar TRIM(Nombre)
UPDATE sucursal SET Direccion = 'Valor faltante' WHERE Direccion = '' OR Direccion is null;
UPDATE sucursal SET Localidad = 'Valor faltante' WHERE Localidad = '' OR Localidad is null;
UPDATE sucursal SET Provincia = 'Valor faltante' WHERE Provincia = '' OR Provincia is null;

UPDATE proveedor SET Nombre = 'Valor faltante' WHERE Nombre = '' OR Nombre is null;
UPDATE proveedor SET Address = 'Valor faltante' WHERE Address = '' OR Address is null;
UPDATE proveedor SET State = 'Valor faltante' WHERE State = '' OR State is null;
UPDATE proveedor SET Country = 'Valor faltante' WHERE Country = '' OR Country is null;
UPDATE proveedor SET Departamen = 'Valor faltante' WHERE Departamen = '' OR Departamen is null;
UPDATE proveedor SET City = 'Valor faltante' WHERE City = '' OR City is null;

UPDATE empleado SET Apellido = 'Valor faltante' WHERE Apellido = '' OR Apellido is null;
UPDATE empleado SET Nombre = 'Valor faltante' WHERE Nombre = '' OR Nombre is null;
UPDATE empleado SET Surcursal = 'Valor faltante' WHERE Surcursal = '' OR Surcursal is null;
UPDATE empleado SET Sector = 'Valor faltante' WHERE Sector = '' OR Sector is null;
UPDATE empleado SET Cargo = 'Valor faltante' WHERE Cargo = '' OR Cargo is null;

UPDATE cliente SET Provincia = 'Valor faltante' WHERE Provincia = '' OR Provincia is null;
UPDATE cliente SET NombreApellido = 'Valor faltante' WHERE NombreApellido = '' OR NombreApellido is null;
UPDATE cliente SET Domicilio = 'Valor faltante' WHERE Domicilio = '' OR Domicilio is null;
UPDATE cliente SET Telefono = 'Valor faltante' WHERE Telefono = '' OR Telefono is null;
UPDATE cliente SET Edad = 'Valor faltante' WHERE Edad = '' OR Edad is null;
UPDATE cliente SET Localidad = 'Valor faltante' WHERE Localidad = '' OR Localidad is null;
UPDATE cliente SET UsuarioAlta = 'Valor faltante' WHERE UsuarioAlta = '' OR UsuarioAlta is null;
UPDATE cliente SET UsuarioModificacion = 'Valor faltante' WHERE UsuarioModificacion = '' OR UsuarioModificacion is null;



## Ejercicio 8
UPDATE canal_venta SET Descripcion = UC_Words(Descripcion);
UPDATE cliente SET Provincia = UC_Words(Provincia);
UPDATE cliente SET NombreApellido = UC_Words(NombreApellido);
UPDATE cliente SET Domicilio= UC_Words(Domicilio);
UPDATE cliente SET Localidad= UC_Words(Localidad);
UPDATE cliente SET UsuarioAlta= UC_Words(UsuarioAlta);
UPDATE cliente SET UsuarioModificacion= UC_Words(UsuarioModificacion);
UPDATE empleado SET Apellido= UC_Words(Apellido);
UPDATE empleado SET Nombre= UC_Words(Nombre);
UPDATE empleado SET Surcursal= UC_Words(Surcursal);
UPDATE empleado SET Sector= UC_Words(Sector);
UPDATE empleado SET Cargo= UC_Words(Cargo);
UPDATE producto SET Tipo = UC_Words(Tipo);
UPDATE producto SET Concepto = UC_Words(Concepto);
UPDATE proveedor SET Nombre = UC_Words(Nombre);
UPDATE proveedor SET Address= UC_Words(Address);
UPDATE proveedor SET City= UC_Words(City);
UPDATE proveedor SET State= UC_Words(State);
UPDATE proveedor SET Country= UC_Words(Country);
UPDATE proveedor SET Departamen= UC_Words(Departamen);
UPDATE sucursal SET Nombre = UC_Words(Nombre);
UPDATE sucursal SET Direccion = UC_Words(Direccion);
UPDATE sucursal SET Localidad = UC_Words(Localidad);
UPDATE sucursal SET Provincia = UC_Words(Provincia);
UPDATE tipo_gasto SET Descripcion = UC_Words(Descripcion);
UPDATE tipo_gasto SET MontoAproximado = UC_Words(MontoAproximado);

-- EJERCICIO 9 VENTA

SELECT v.Precio,p.Precio
FROM venta v 
JOIN producto p using(IdProducto)
WHERE v.Precio != p.Precio;

# Hay inconsitencia en los precios de ventas y productos
# por esto voy a setear los precios en ventas


## EJERCICIO 10

SELECT COUNT(*) as cantidad_repetidos FROM calendario GROUP BY id HAVING(cantidad_repetidos) > 1; # calendario
SELECT COUNT(*) as cantidad_repetidos FROM canal_venta GROUP BY Codigo HAVING(cantidad_repetidos) > 1; # canal_Venta
SELECT COUNT(*) as cantidad_repetidos FROM cliente GROUP BY IdCliente HAVING(cantidad_repetidos) > 1; # cliente
SELECT COUNT(*) as cantidad_repetidos FROM compra GROUP BY IdCompra HAVING(cantidad_repetidos) > 1; # compra
SELECT COUNT(*) as cantidad_repetidos,IdEmpleado FROM empleado GROUP BY IdEmpleado HAVING(cantidad_repetidos) > 1; # empleado
SELECT COUNT(*) as cantidad_repetidos FROM gasto GROUP BY IdGasto HAVING(cantidad_repetidos) > 1; # gasto
SELECT COUNT(*) as cantidad_repetidos FROM producto GROUP BY IdProducto HAVING(cantidad_repetidos) > 1; #producto
SELECT COUNT(*) as cantidad_repetidos FROM proveedor GROUP BY IdProveedor HAVING(cantidad_repetidos) > 1; #proveedor
SELECT COUNT(*) as cantidad_repetidos FROM sucursal GROUP BY Idsucursal HAVING(cantidad_repetidos) > 1; #sucursal
SELECT COUNT(*) as cantidad_repetidos FROM tipo_gasto GROUP BY IdTipoGasto HAVING(cantidad_repetidos) > 1; #venta
SELECT COUNT(*) as cantidad_repetidos FROM venta GROUP BY IdVenta HAVING(cantidad_repetidos) > 1; #producto

# SOLO LA TABLA EMPLEADOS TIENE CLAVES REPETIDAS




## NORMALIZACION 10

## 10

/*
Generar dos nuevas tablas a partir de la tabla 'empelado' que contengan las entidades Cargo y Sector.
*/


DROP TABLE  IF EXISTS Cargo;
CREATE TABLE Cargo(
		IdCargo INT NOT NULL AUTO_INCREMENT,
        Cargo VARCHAR(50),
        PRIMARY KEY(IdCargo)
);

DROP TABLE  IF EXISTS Sector;
CREATE TABLE Sector(
		IdSector INT NOT NULL AUTO_INCREMENT,
        Sector VARCHAR(50),
        PRIMARY KEY(IdSector)
);


INSERT INTO cargo(Cargo)
SELECT DISTINCT Cargo
FROM empleado
ORDER BY Cargo;

INSERT INTO sector(Sector)
SELECT DISTINCT Sector
FROM empleado
ORDER BY Sector;

ALTER TABLE empleado ADD IdCargo INT AFTER Cargo;
UPDATE empleado e JOIN cargo c using(Cargo)
SET e.IdCargo = c.IdCargo;

ALTER TABLE empleado ADD IdSector INT AFTER Sector;
UPDATE empleado e JOIN sector s using(Sector)
SET e.IdSector = s.IdSector;

ALTER TABLE empleado DROP Sector;
ALTER TABLE empleado DROP Cargo;

DROP TABLE  IF EXISTS tipo_producto;
CREATE TABLE tipo_producto(
		IdTipoProducto INT NOT NULL AUTO_INCREMENT,
        Tipo VARCHAR(50),
        PRIMARY KEY(IdTipoProducto)
);

INSERT INTO tipo_producto(Tipo)
SELECT DISTINCT Tipo
FROM producto
ORDER BY Tipo;

ALTER TABLE producto ADD IdTipoProducto INT AFTER Tipo;
UPDATE producto p JOIN tipo_producto t using(Tipo)
SET p.IdTipoProducto = t.IdTipoProducto;
ALTER TABLE producto DROP Tipo; 






SELECT e.Surcursal FROM empleado e
WHERE e.Surcursal not in (SELECT s.Nombre as sucursal from sucursal s);
# MENDOZA 1 y MENDOZA 2 TIENE MAL EL NOMBRE EN SUCURSAL

UPDATE empleado
SET Surcursal = 'Mendoza1' WHERE Surcursal = 'Mendoza 1';
UPDATE empleado
SET Surcursal = 'Mendoza2' WHERE Surcursal = 'Mendoza 2';


ALTER TABLE empleado DROP IdSucursal;
ALTER TABLE empleado ADD IdSucursal INT;
ALTER TABLE empleado CHANGE IdSucursal IdSucursal INT NULL DEFAULT '0';
UPDATE empleado e JOIN sucursal s ON (e.Surcursal = s.Nombre)
SET e.IdSucursal = s.IdSucursal WHERE s.IdSucursal  is not null;
ALTER TABLE empleado DROP Surcursal;



###DUPLICADOS EN EMPLEADOS##
SELECT COUNT(*) as cantidad_repetidos,IdEmpleadoAntiguo FROM empleado GROUP BY IdEmpleadoAntiguo HAVING(cantidad_repetidos) > 1; # empleado
ALTER TABLE empleado CHANGE IdEmpleado IdEmpleadoAntiguo INT NOT NULL;

 ALTER TABLE empleado DROP IdEmpleado ;
ALTER TABLE empleado ADD IdEmpleado INT NOT NULL;

UPDATE empleado SET IdEmpleado = (IdSucursal * 10000) + IdEmpleadoAntiguo;

SELECT v.IdProducto,v.Precio,p.Precio,v.Cantidad
FROM venta v 
JOIN producto p ON v.IdProducto = p.IdProducto
WHERE v.Precio != p.Precio;


SELECT v.Precio
FROM venta v
WHERE IdProducto = 42788;




###POSIBLES RELACIONES

-- tipo_producto 1--n > producto
-- sector 1--n > empleado
--  cargo 1--n > empleado
--  sucursal 1--n > empleado
--  tipo_gasto 1--n > gasto
--  compra n -- 1 > producto
-- 

