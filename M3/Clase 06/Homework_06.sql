-- Ejercicio 1

-- Creo una tabla auxiliar para guardar localidades y provincias

DROP TABLE IF EXISTS aux_localidades ;
CREATE TABLE aux_localidades (
	LocalidadOriginal VARCHAR(60),
    ProvinciaOriginal VARCHAR(60)
);

INSERT INTO aux_localidades (LocalidadOriginal, ProvinciaOriginal)
SELECT Localidad, Provincia
FROM cliente;

INSERT INTO aux_localidades (LocalidadOriginal, ProvinciaOriginal)
SELECT Localidad, Provincia
FROM sucursal;

INSERT INTO aux_localidades (LocalidadOriginal, ProvinciaOriginal)
SELECT Departamen, State
FROM proveedor;




SELECT  UC_Words(LocalidadOriginal)
FROM aux_localidades
-- WHERE LocalidadOriginal LIKE '%Fed%'
;


ALTER TABLE aux_localidades ADD LocalidadNormal VARCHAR(60) NOT NULL DEFAULT '';

-- Localidades
UPDATE aux_localidades
SET LocalidadNormal = 'Capital Federal' WHERE LocalidadOriginal LIKE '%Fed%' OR LocalidadOriginal LIKE '%Capital%';
UPDATE aux_localidades
SET LocalidadNormal = LocalidadOriginal WHERE LocalidadOriginal NOT LIKE '%Fed%';

UPDATE aux_localidades
SET LocalidadNormal = 'Ciudad de Buenos Aires' WHERE LocalidadOriginal LIKE '%CABA%' OR LocalidadOriginal LIKE '%Buenos%';

-- Provincias
ALTER TABLE aux_localidades ADD ProvinciaNormal VARCHAR(60) NOT NULL DEFAULT '';


SELECT ProvinciaOriginal
FROM aux_localidades
WHERE ProvinciaOriginal 
	LIKE '%B%' AND ProvinciaOriginal  LIKE '%P%'
    OR ProvinciaOriginal LIKE '%B%' AND  ProvinciaOriginal LIKE '%A%' AND ProvinciaOriginal NOT LIKE '%C%';


UPDATE aux_localidades
SET ProvinciaNormal = 'Buenos Aires' WHERE ProvinciaOriginal 
	LIKE '%B%' AND ProvinciaOriginal  LIKE '%P%'
    OR ProvinciaOriginal LIKE '%B%' AND  ProvinciaOriginal LIKE '%A%' AND ProvinciaOriginal NOT LIKE '%C%';



SELECT ProvinciaOriginal
FROM aux_localidades
WHERE ProvinciaOriginal   LIKE '%Ciu%'
OR ProvinciaOriginal LIKE '%C%' AND ProvinciaOriginal LIKE '%B%' AND ProvinciaOriginal NOT LIKE '%r%' AND ProvinciaOriginal NOT LIKE '%p%';

UPDATE aux_localidades
SET ProvinciaNormal = 'Buenos Aires'  WHERE ProvinciaOriginal   LIKE '%Ciu%'
OR ProvinciaOriginal LIKE '%C%' AND ProvinciaOriginal LIKE '%B%' AND ProvinciaOriginal NOT LIKE '%r%' AND ProvinciaOriginal NOT LIKE '%p%';


UPDATE aux_localidades
SET ProvinciaNormal = 'Ciudad de Buenos Aires'  WHERE ProvinciaOriginal   LIKE '%Ciu%'
OR ProvinciaOriginal LIKE '%C%' AND ProvinciaOriginal LIKE '%B%' AND ProvinciaOriginal  LIKE '%u%';

SELECT  ProvinciaOriginal
FROM aux_localidades
WHERE ProvinciaOriginal LIKE '%Cor%';

UPDATE aux_localidades
SET ProvinciaNormal = 'Córdoba'  WHERE ProvinciaOriginal LIKE '%Cor%';

UPDATE aux_localidades
SET ProvinciaNormal = 'Tucumán'  WHERE ProvinciaOriginal LIKE 'Tucuman';


UPDATE aux_localidades
SET ProvinciaNormal = ProvinciaOriginal  WHERE ProvinciaNormal = '';

SELECT DISTINCT ProvinciaNormal
FROM aux_localidades
 WHERE ProvinciaNormal NOT LIKE '%Valor%';

UPDATE localidad 
SET Localidad = TRIM(Localidad);
UPDATE provincia
SET Provincia = TRIM(Provincia);

-- TABLA DE PROVINCIAS

DROP TABLE IF EXISTS provincia;
CREATE TABLE provincia (
		IdProvincia INT NOT NULL AUTO_INCREMENT,
        Provincia VARCHAR(60),
        PRIMARY KEY(IdProvincia)
);

INSERT INTO provincia(Provincia)
SELECT DISTINCT ProvinciaNormal
FROM aux_localidades
 WHERE ProvinciaNormal NOT LIKE '%Valor%';
 
 -- TABLA LOCALIDADES
 
 DROP TABLE IF EXISTS localidad;
CREATE TABLE localidad (
		IdLocalidad INT NOT NULL AUTO_INCREMENT,
        Localidad VARCHAR(60),
        IdProvincia INT NOT NULL,
        PRIMARY KEY(IdLocalidad)
);

SELECT DISTINCT LocalidadNormal
FROM aux_localidades a
JOIN provincia p ON a.ProvinciaNormal = p.Provincia;

INSERT INTO localidad (Localidad,IdProvincia)
SELECT DISTINCT LocalidadNormal,IdProvincia
FROM aux_localidades a
JOIN provincia p ON a.ProvinciaNormal = p.Provincia;

ALTER TABLE cliente ADD IdProvincia INT AFTER Provincia;
ALTER TABLE cliente ADD IdLocalidad INT AFTER Localidad;

ALTER TABLE sucursal ADD IdProvincia INT AFTER Provincia;
ALTER TABLE sucursal ADD IdLocalidad INT AFTER Localidad;

ALTER TABLE proveedor ADD IdProvincia INT AFTER State;
ALTER TABLE proveedor ADD IdLocalidad INT AFTER Departamen;

UPDATE cliente c JOIN provincia p
ON TRIM(c.Provincia) = TRIM(p.Provincia)
SET c.IdProvincia = p.IdProvincia;

UPDATE sucursal c JOIN provincia p
ON TRIM(c.Provincia) = TRIM(p.Provincia)
SET c.IdProvincia = p.IdProvincia;


UPDATE proveedor c JOIN provincia p
ON TRIM(c.State) = TRIM(p.Provincia)
SET c.IdProvincia = p.IdProvincia;


-- LOCALIDADES

UPDATE cliente c JOIN localidad p
ON TRIM(c.Localidad) = TRIM(p.Localidad)
SET c.IdLocalidad = p.IdLocalidad;

UPDATE sucursal c JOIN localidad p
ON TRIM(c.Localidad) = TRIM(p.Localidad)
SET c.IdLocalidad = p.IdLocalidad;

UPDATE proveedor c JOIN localidad p
ON TRIM(c.Departamen) = TRIM(p.Localidad)
SET c.IdLocalidad = p.IdLocalidad;

ALTER TABLE localidad
MODIFY COLUMN IdProvincia INT NOT NULL,
ADD FOREIGN KEY (IdProvincia) REFERENCES provincia(IdProvincia);





-- EJERCICIO 2 APLICANDO RANGOS ETARIOS

-- Primero busco el rango de edades

SELECT MAX(Edad) as EdadMaxima,Min(edad) as EdadMinima
FROM cliente;

-- [15,65]
-- Voy a aplicar un rango cada 10 valores
ALTER TABLE cliente DROP RangoEtario;
ALTER TABLE cliente ADD RangoEtario VARCHAR(30) DEFAULT '' AFTER Edad;
UPDATE cliente
SET RangoEtario = '15-25' WHERE Edad BETWEEN 15 AND 25 ;
UPDATE cliente
SET RangoEtario = '25-36' WHERE Edad BETWEEN 26 AND 36 ;
UPDATE cliente
SET RangoEtario = '37-47' WHERE Edad BETWEEN 37 AND 47 ;
UPDATE cliente
SET RangoEtario = '47-57' WHERE Edad BETWEEN 47 AND 57 ;
UPDATE cliente
SET RangoEtario = '57-65' WHERE Edad BETWEEN 57 AND 65 ;


-- EJERCICIO 2 OUTLIERS
-- DEsviacion estandar general de Precio en ventas
SELECT STDDEV(Precio) INTO  @desviacionEstandar
FROM venta;


-- Outliers de Precio en venta
SELECT Precio
FROM venta
WHERE Precio > @promedio + @desviacionEstandar * 3 OR Precio <@promedio - @desviacionEstandar * 3;

SELECT Idsucursal,AVG(Precio) as promedio_por_sucursal,STDDEV(Precio) as desviacion_por_sucursal
FROM venta
GROUP BY Idsucursal;

-- OUTLIERS DE PRECIO POR SUCURSAL

SELECT Idsucursal,Precio
From (
SELECT Idsucursal,Precio,
		AVG(Precio) OVER(PARTITION BY Idsucursal) as promedio_por_sucursal,
        STDDEV(Precio) OVER(PARTITION BY Idsucursal) as desviacion_por_sucursal,
        AVG(Precio) OVER(PARTITION BY Idsucursal) - 3 *  STDDEV(Precio) OVER(PARTITION BY Idsucursal) as Minimo,
        AVG(Precio) OVER(PARTITION BY Idsucursal) + 3 *  STDDEV(Precio) OVER(PARTITION BY Idsucursal) as Maximo
FROM venta) v
WHERE Precio < Minimo OR Precio > Maximo ;


-- PRECIO POR SUCURSAL SIN OUTLIERS
SELECT Idsucursal,Precio
From (
SELECT Idsucursal,Precio,
		AVG(Precio) OVER(PARTITION BY Idsucursal) as promedio_por_sucursal,
        STDDEV(Precio) OVER(PARTITION BY Idsucursal) as desviacion_por_sucursal,
        AVG(Precio) OVER(PARTITION BY Idsucursal) - 3 *  STDDEV(Precio) OVER(PARTITION BY Idsucursal) as Minimo,
        AVG(Precio) OVER(PARTITION BY Idsucursal) + 3 *  STDDEV(Precio) OVER(PARTITION BY Idsucursal) as Maximo
FROM venta) v
WHERE Precio BETWEEN Minimo and Maximo ;



-- OUTLIERS DE CANTIDAD POR SUCURSAL

SELECT Idsucursal,Cantidad
From (
SELECT Idsucursal,Cantidad,
		AVG(Cantidad) OVER(PARTITION BY Idsucursal) as promedio_por_sucursal,
        STDDEV(Cantidad) OVER(PARTITION BY Idsucursal) as desviacion_por_sucursal,
        AVG(Cantidad) OVER(PARTITION BY Idsucursal) - 3 *  STDDEV(Cantidad) OVER(PARTITION BY Idsucursal) as Minimo,
        AVG(Cantidad) OVER(PARTITION BY Idsucursal) + 3 *  STDDEV(Cantidad) OVER(PARTITION BY Idsucursal) as Maximo
FROM venta) v
WHERE Cantidad < Minimo OR Cantidad > Maximo ;


-- CANTIDAD POR SUCURSAL SIN OUTLIERS
SELECT Idsucursal,Cantidad
From (
SELECT Idsucursal,Cantidad,
		AVG(Cantidad) OVER(PARTITION BY Idsucursal) as promedio_por_sucursal,
        STDDEV(Cantidad) OVER(PARTITION BY Idsucursal) as desviacion_por_sucursal,
        AVG(Cantidad) OVER(PARTITION BY Idsucursal) - 3 *  STDDEV(Cantidad) OVER(PARTITION BY Idsucursal) as Minimo,
        AVG(Cantidad) OVER(PARTITION BY Idsucursal) + 3 *  STDDEV(Cantidad) OVER(PARTITION BY Idsucursal) as Maximo
FROM venta) v
WHERE Cantidad BETWEEN Minimo and Maximo ;









-- Promedio por sucursal con outliers
SELECT Idsucursal,AVG(Precio) as promedio_sucursal_CO,Max(Precio),Min(Precio)
From (
SELECT Idsucursal,Precio,
		AVG(Precio) OVER(PARTITION BY Idsucursal) as promedio_por_sucursal,
        STDDEV(Precio) OVER(PARTITION BY Idsucursal) as desviacion_por_sucursal,
        AVG(Precio) OVER(PARTITION BY Idsucursal) - 3 *  STDDEV(Precio) OVER(PARTITION BY Idsucursal) as Minimo,
        AVG(Precio) OVER(PARTITION BY Idsucursal) + 3 *  STDDEV(Precio) OVER(PARTITION BY Idsucursal) as Maximo
FROM venta) v
GROUP BY Idsucursal ;



--  sucursal sin outliers
SELECT Idsucursal,AVG(Precio) as promedio_sucursal_SO,Max(Precio),Min(Precio)
From (
SELECT Idsucursal,Precio,
		AVG(Precio) OVER(PARTITION BY Idsucursal) as promedio_por_sucursal,
        STDDEV(Precio) OVER(PARTITION BY Idsucursal) as desviacion_por_sucursal,
        AVG(Precio) OVER(PARTITION BY Idsucursal) - 3 *  STDDEV(Precio) OVER(PARTITION BY Idsucursal) as Minimo,
        AVG(Precio) OVER(PARTITION BY Idsucursal) + 3 *  STDDEV(Precio) OVER(PARTITION BY Idsucursal) as Maximo
FROM venta) v
WHERE Precio BETWEEN Minimo and Maximo
GROUP BY Idsucursal ;


SELECT Idsucursal,t.promedio_sucursal_SO / v.promedio_sucursal_CO * 100 porcentaje_outliers,suma_CO,suma_SO
FROM (
SELECT Idsucursal,AVG(Precio) as promedio_sucursal_CO,Max(Precio),Min(Precio),SUM(Precio) as suma_CO
From (
SELECT Idsucursal,Precio,
		AVG(Precio) OVER(PARTITION BY Idsucursal) as promedio_por_sucursal,
        STDDEV(Precio) OVER(PARTITION BY Idsucursal) as desviacion_por_sucursal,
        AVG(Precio) OVER(PARTITION BY Idsucursal) - 3 *  STDDEV(Precio) OVER(PARTITION BY Idsucursal) as Minimo,
        AVG(Precio) OVER(PARTITION BY Idsucursal) + 3 *  STDDEV(Precio) OVER(PARTITION BY Idsucursal) as Maximo
FROM venta) v
GROUP BY Idsucursal 
) v JOIN (SELECT Idsucursal,AVG(Precio) as promedio_sucursal_SO,Max(Precio),Min(Precio),SUM(Precio) as suma_SO
From (
SELECT Idsucursal,Precio,
		AVG(Precio) OVER(PARTITION BY Idsucursal) as promedio_por_sucursal,
        STDDEV(Precio) OVER(PARTITION BY Idsucursal) as desviacion_por_sucursal,
        AVG(Precio) OVER(PARTITION BY Idsucursal) - 3 *  STDDEV(Precio) OVER(PARTITION BY Idsucursal) as Minimo,
        AVG(Precio) OVER(PARTITION BY Idsucursal) + 3 *  STDDEV(Precio) OVER(PARTITION BY Idsucursal) as Maximo
FROM venta) v
WHERE Precio BETWEEN Minimo and Maximo
GROUP BY Idsucursal ) t using(Idsucursal);




-- AGREGO LOS VALORES OUTLIERS DE PRECIO Y CANTIDAD A LA TABLA AUX VENTA

-- Motivo 2 :  Outliers precio
-- Motivo 3 :  Outliers Cantidad

INSERT INTO aux_venta 
SELECT IdVenta,Fecha,FechaEntrega,Idcliente,Idsucursal,IdEmpleado,IdProducto,Precio,Cantidad,2
From (
SELECT IdVenta,Fecha,FechaEntrega,Idcliente,Idsucursal,IdEmpleado,IdProducto,Precio,Cantidad,
		AVG(Precio) OVER(PARTITION BY Idsucursal) as promedio_por_sucursal,
        STDDEV(Precio) OVER(PARTITION BY Idsucursal) as desviacion_por_sucursal,
        AVG(Precio) OVER(PARTITION BY Idsucursal) - 3 *  STDDEV(Precio) OVER(PARTITION BY Idsucursal) as Minimo,
        AVG(Precio) OVER(PARTITION BY Idsucursal) + 3 *  STDDEV(Precio) OVER(PARTITION BY Idsucursal) as Maximo
FROM venta) v
WHERE Precio < Minimo OR Precio > Maximo ;



INSERT INTO aux_venta 
SELECT IdVenta,Fecha,FechaEntrega,Idcliente,Idsucursal,IdEmpleado,IdProducto,Precio,Cantidad,3
From (
SELECT IdVenta,Fecha,FechaEntrega,Idcliente,Idsucursal,IdEmpleado,IdProducto,Precio,Cantidad,
		AVG(Cantidad) OVER(PARTITION BY Idsucursal) as promedio_por_sucursal,
        STDDEV(Cantidad) OVER(PARTITION BY Idsucursal) as desviacion_por_sucursal,
        AVG(Cantidad) OVER(PARTITION BY Idsucursal) - 3 *  STDDEV(Cantidad) OVER(PARTITION BY Idsucursal) as Minimo,
        AVG(Cantidad) OVER(PARTITION BY Idsucursal) + 3 *  STDDEV(Cantidad) OVER(PARTITION BY Idsucursal) as Maximo
FROM venta) v
WHERE Cantidad < Minimo OR Cantidad > Maximo ;


-- Agrego la columna outlier en venta, que pondra 0 para los valores de precio y cantidad no atipicos y 1 para los atipicos
ALTER TABLE VENTA DROP Outlier;
ALTER TABLE venta ADD Outlier INT DEFAULT 1;

UPDATE  venta v
JOIN aux_venta a ON v.IdVenta = a.IdVenta AND Motivo IN (2,3)
SET Outlier = 0;


-- Ejercicio 2 : usando tablas auxiliares


-- Ejercicio 3 KPI:


-- 1: Return of investment ROI ingresos/inversion -1 

-- EL DE HR

SELECT 	venta.Concepto, 
		venta.SumaVentas, 
        venta.CantidadVentas, 
        venta.SumaVentasOutliers,
        compra.SumaCompras, 
        compra.CantidadCompras,
        ((venta.SumaVentas / compra.SumaCompras - 1) * 100) as margen
FROM
	(SELECT 	p.Concepto,
			SUM(v.Precio * v.Cantidad * v.Outlier) 	as 	SumaVentas,
			SUM(v.Outlier) 							as	CantidadVentas,
			SUM(v.Precio * v.Cantidad) 				as 	SumaVentasOutliers,
			COUNT(*) 								as	CantidadVentasOutliers
	FROM venta v JOIN producto p
		ON (v.IdProducto = p.IdProducto
			AND YEAR(v.Fecha) = 2019)
	GROUP BY p.Concepto) AS venta
JOIN
	(SELECT 	p.Concepto,
			SUM(c.Precio * c.Cantidad) 				as SumaCompras,
			COUNT(*)								as CantidadCompras
	FROM compra c JOIN producto p
		ON (c.IdProducto = p.IdProducto
			AND YEAR(c.Fecha) = 2019)
	GROUP BY p.Concepto) as compra
ON (venta.Concepto = compra.Concepto);


SELECT y.Producto,cant_venta_sinOut,cant_venta_conOut,cantidad_compra,venta_conOut,venta_sinOut,compra,(venta_sinOut/compra - 1)*100  as ROI
FROM (

(SELECT p.Concepto as Producto,SUM(v.Cantidad * v.Precio) as venta_conOut ,SUM(v.Cantidad * v.Precio * Outlier) as venta_sinOut,SUM(v.Cantidad*Outlier) as cant_venta_sinOut,
		SUM(v.Cantidad) as cant_venta_conOut
FROM venta v
JOIN producto p ON v.IdProducto = p.IdProducto
WHERE YEAR(v.Fecha) = 2019
GROUP BY p.Concepto) y
JOIN
(SELECT p.Concepto as Producto,SUM(v.Cantidad * v.Precio) compra,SUM(Cantidad) as cantidad_compra
FROM compra v
JOIN producto p ON v.IdProducto = p.IdProducto
WHERE YEAR(v.Fecha) = 2019
GROUP BY p.Concepto )t
ON y.Producto = t.Producto);



-- Posible: Venta realizada por empleado en un año

SELECT IdEmpleado,SUM(Precio*Cantidad*Outlier) as venta_sinOut,SUM(Precio*Cantidad) as venta_conOut,
		SUM(Cantidad*Outlier) as cantidad_sinOut,SUM(Cantidad) as venta_conOut
FROM venta
WHERE YEAR(Fecha) = 2019
GROUP BY IdEmpleado
ORDER BY cantidad_sinOut DESC;


-- CORRECION DE LAS COORDENADAS EN CLIENTE

DROP TABLE IF EXISTS aux_cliente;
CREATE TABLE aux_cliente(
	IdCliente INT,
    Latitud DOUBLE,
    Longitud DOUBLE
);

INSERT INTO aux_cliente
SELECT IdCliente,Latitud,Longitud
FROM cliente WHERE Latitud < -55; -- La minima latitud en Argentina

UPDATE cliente SET Latitud = Latitud * -1 WHERE Latitud > 0; 
UPDATE cliente SET Longitud = Longitud * -1 WHERE Longitud > 0;  -- EN ARGENTINA LA LATITUD Y LA LONGITUD SON NEGATIVAS

SELECT Latitud,Longitud
FROM cliente WHERE Latitud < -55;


-- Como se ve en la consulta que la latitud sea menor a -55 parece ser por estar cambiada con la longitud asique voy a alterar

UPDATE cliente c
JOIN aux_cliente a ON c.IdCliente = a.IdCliente
SET c.Latitud = a.Longitud,
c.Longitud = a.Latitud;



-- Puedo estimar las coordenadas de una localidad con el promedio de las coordenadas de los clientes que pertencen a esa localidad

SELECT l.IdLocalidad,l.Localidad,AVG(Latitud)
FROM cliente
JOIN localidad l ON cliente.IdLocalidad = l.IdLocalidad
WHERE Latitud <> 0
GROUP BY IdLocalidad;


-- GUARDO LAS COORDENDAS EN LOCALIDADES
ALTER TABLE localidad DROP Latitud,DROP Longitud;
ALTER TABLE localidad ADD Latitud DECIMAL(15,9)  DEFAULT '0', ADD Longitud DECIMAL(15,9)  DEFAULT '0';

UPDATE localidad l 
	JOIN (	SELECT IdLocalidad, AVG(Latitud) AS Latitud
			FROM cliente WHERE Latitud <> 0 
			GROUP BY IdLocalidad) c
	ON (l.IdLocalidad = c.IdLocalidad)
SET l.Latitud = c.Latitud;

UPDATE localidad l 
	JOIN (	SELECT IdLocalidad, AVG(Longitud) AS Longitud
			FROM cliente WHERE Longitud <> 0 
			GROUP BY IdLocalidad) c
	ON (l.IdLocalidad = c.IdLocalidad)
SET l.Longitud = c.Longitud;


-- ACTUALIZO LOS VALORES NULOS CON EL VALOR DE LA COORDENADA E LA LOCALIDAD
UPDATE cliente c JOIN localidad l
	ON (c.IdLocalidad = l.IdLocalidad)
SET c.Latitud = l.Latitud
WHERE c.Latitud = 0;

UPDATE cliente c JOIN localidad l
	ON (c.IdLocalidad = l.IdLocalidad)
SET c.Longitud = l.Longitud
WHERE c.Longitud = 0; 






