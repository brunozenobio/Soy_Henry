-- EJERCICIO 1

/*
Genere 5 consultas simples con alguna función de agregación y
 filtrado sobre las tablas. Anote los resultados del la ficha de estadísticas.
*/

SELECT AVG(Precio) as promedio_sucursal
FROM venta
WHERE YEAR(Fecha) = 2020
GROUP BY IdSucursal;
#client:0.062
#Server: 0.051

SELECT p.IdTipoProducto,SUM(v.Precio) as SUMA_TIPO_PRODUCTO
FROM venta v
JOIN producto p ON v.IdProducto = p.IdProducto
GROUP BY IdTipoProducto;

#Cliente:0.078
#Servidor: 0.72

SELECT cliente.IdLocalidad,l.Localidad,COUNT(*)
FROM cliente
JOIN localidad l ON cliente.IdLocalidad = l.IdLocalidad
WHERE Domicilio NOT LIKE '%Faltante%'
GROUP BY cliente.IdLocalidad;

#Cliente:0.015
#Servidor: 0.10

SELECT IdEmpleado,SUM(Cantidad) as cantidad_empleado
FROM venta
WHERE YEAR(Fecha) = 2020
GROUP BY IdEmpleado;
#client:0.031
#Server: 0.042

SELECT IdCanal,SUM(Cantidad) as cantidad_canal
FROM venta
WHERE YEAR(Fecha) = 2020
GROUP BY IDCanal;
#client:0.047
#Server: 0.041


-- EJERCICIO 2

/*
A partir del conjunto de datos elaborado en clases anteriores,
 genere las PK de cada una de las tablas a partir del campo que cumpla
 con los requisitos correspondientes.
*/


ALTER TABLE calendario ADD PRIMARY KEY (IdCalendario);
ALTER TABLE canal_venta ADD PRIMARY KEY (Codigo);
ALTER TABLE cargo ADD PRIMARY KEY (IdCargo);
ALTER TABLE IdCargo ADD PRIMARY KEY (IdCliente);
ALTER TABLE compra ADD PRIMARY KEY (IdCompra);
ALTER TABLE empleado ADD PRIMARY KEY  (IdEmpleado)  ;
ALTER TABLE gasto ADD PRIMARY KEY (IdGasto);
ALTER TABLE localidad ADD PRIMARY KEY (IdLocalidad);
ALTER TABLE producto ADD PRIMARY KEY (IdProducto);
ALTER TABLE proveedor ADD PRIMARY KEY (IdProveedor);
ALTER TABLE sector ADD PRIMARY KEY (IdSector);
ALTER TABLE sucursal ADD PRIMARY KEY  (Idsucursal)  ;
ALTER TABLE tipo_gasto ADD PRIMARY KEY (IdTipoGasto);
ALTER TABLE tipo_producto ADD PRIMARY KEY (IdTipoProducto);
ALTER TABLE venta ADD PRIMARY KEY (IdVenta);
ALTER TABLE cliente ADD PRIMARY KEY (IdCliente);

-- EJERCICIO 3

/*
Genere la indexación de los campos que representen fechas o ID en las tablas:
venta.
cana_venta.
producto.
tipo_producto.
sucursal.
empleado.
localidad.
proveedor.
gasto.
cliente.
compra.

*/

-- TABLA venta index a los ID y fechas : Fecha,FechaEntrega,IdCanal,IdCliente,Idsucursal,IdEmpelado,IdProducto

ALTER TABLE venta ADD INDEX (Fecha);
ALTER TABLE venta ADD INDEX (FechaEntrega);
ALTER TABLE venta ADD INDEX (IdCanal);
ALTER TABLE venta ADD INDEX (IdCliente);
ALTER TABLE venta ADD INDEX (Idsucursal);
ALTER TABLE venta ADD INDEX (IdEmpleado);
ALTER TABLE venta ADD INDEX (IdProducto);

-- TABLA canal_venta index a los ID y fechas : YA LOS TIENE

-- TABLA producto index a los ID y fechas : IdTipoProducto

ALTER TABLE producto ADD INDEX (IdTipoProducto);

-- TABLA sucursal index a los ID y fechas : IdLocalidad
ALTER TABLE sucursal ADD INDEX (IdLocalidad);

-- TABLA tipo_producto  YA LOS TIENE

-- TABLA empleado index a los ID y fechas :IdSector IdCargo IdSucursal

ALTER TABLE empleado ADD INDEX (IdSector);
ALTER TABLE empleado ADD INDEX (IdCargo);
ALTER TABLE empleado ADD INDEX (IdSucursal);


-- TABLA localidad index a los ID y fechas :Ya lo tiene

-- TABLA proveedor index a los ID y fechas :IdProvincia IdLocalidad

ALTER TABLE proveedor ADD INDEX (IdProvincia);
ALTER TABLE proveedor ADD INDEX (IdLocalidad);


-- TABLA gasto index a los ID y fechas :Idsucursal IdTipoGasto Fecha
ALTER TABLE gasto ADD INDEX (Idsucursal);
ALTER TABLE gasto ADD INDEX (IdTipoGasto);
ALTER TABLE gasto ADD INDEX (Fecha);

-- TABLA cliente index a los ID y fechas :IdLocalidad FechaAlta

ALTER TABLE cliente ADD INDEX (IdLocalidad);
ALTER TABLE cliente ADD INDEX (FechaAlta);

-- TABLA compra index a los ID y fechas :IdProveedor Fecha

ALTER TABLE compra ADD INDEX (IdProveedor);
ALTER TABLE compra ADD INDEX (Fecha);



SELECT AVG(Precio) as promedio_sucursal
FROM venta
WHERE YEAR(Fecha) = 2020
GROUP BY IdSucursal;
#client:0.062
#Server: 0.051

SELECT p.IdTipoProducto,SUM(v.Precio) as SUMA_TIPO_PRODUCTO
FROM venta v
JOIN producto p ON v.IdProducto = p.IdProducto
GROUP BY IdTipoProducto;

#Cliente:0.078
#Servidor: 0.72

SELECT cliente.IdLocalidad,l.Localidad,COUNT(*)
FROM cliente
JOIN localidad l ON cliente.IdLocalidad = l.IdLocalidad
WHERE Domicilio NOT LIKE '%Faltante%'
GROUP BY cliente.IdLocalidad;

#Cliente:0.015
#Servidor: 0.10

SELECT IdEmpleado,SUM(Cantidad) as cantidad_empleado
FROM venta
WHERE YEAR(Fecha) = 2020
GROUP BY IdEmpleado;
#client:0.031
#Server: 0.042

SELECT IdCanal,SUM(Cantidad) as cantidad_canal
FROM venta
WHERE YEAR(Fecha) = 2020
GROUP BY IDCanal;
#client:0.047
#Server: 0.041




-- EJERCICIO 3

/*
Genere una nueva tabla que lleve el nombre fact_venta (modelo estrella) 
que pueda agrupar los hechos relevantes de la tabla venta,
 los campos a considerar deben ser los siguientes:
 
 IdVenta
Fecha
Fecha_Entrega
IdCanal
IdCliente
IdEmpleado
IdProducto
Precio
Cantidad

*/
DROP TABLE IF EXISTS fact_venta;
CREATE TABLE fact_venta(
	IdVenta INT NOT NULL  AUTO_INCREMENT,
    Fecha DATE,
    Fecha_Entrega DATE,
    IdCanal INT NOT NULL,
    IdCliente INT NOT NULL,
    IdEmpleado INT NOT NULL,
    IdProducto INT NOT NULL,
    Precio DECIMAL(10,2),
    Cantidad INT,
    PRIMARY KEY (IdVenta),
    FOREIGN KEY (IdCanal) REFERENCES canal_venta(Codigo),
    FOREIGN KEY (IdCliente) REFERENCES cliente(IdCliente),
    FOREIGN KEY (IdEmpleado) REFERENCES empleado(IdEmpleado),
    FOREIGN KEY (IdProducto) REFERENCES producto(IdProducto)
);

INSERT INTO fact_venta
SELECT IdVenta,Fecha,FechaEntrega,IdCanal,IdCliente,IdEmpleado,IdProducto,Precio,Cantidad
FROM venta;