use adventureworks;
#-------------- EJERCICIO 1 --------------
/*
Obtener un listado de cuál fue el volumen de ventas (cantidad) por año y 
método de envío mostrando para cada registro, qué porcentaje representa 
del total del año. Resolver utilizando Subconsultas y Funciones Ventana, 
luego comparar la diferencia en la demora de las consultas.
*/
# COMO PARA CADA REGISTRO QUIERO VER EL PROCENTAJE DEL TOTAL DE ANIO SOBRE LA TABLA QUE CADA REGISTRO ES UN ANIO POR ENVIO
# VOY A HAER UNA PARTICION SOBRE EL ANIO,PARA CALCULAR EL TOTAL DEL ANIO Y COMPARAR CON ANIO Y ENVIO

SELECT anio,envio_id,cantidad_anio_envio,
	   cantidad_anio_envio / SUM(cantidad_anio_envio) OVER (PARTITION BY anio) as fraccion_envio_por_anio
FROM

		(SELECT year(s.OrderDate) as anio,s.ShipMethodID as envio_id,SUM(d.OrderQty) as cantidad_anio_envio
		FROM salesorderheader s 
		JOIN salesorderdetail d using(SalesOrderID)
		JOIN shipmethod p
		GROUP BY anio,envio_id) v;



# SIN FUNCION VENTANA


SELECT anio,s.ShipMethodID as envio,SUM(d.OrderQty) as volumen_ventas_anio_envio,volumen_ventas_anio,SUM(d.OrderQty) /  volumen_ventas_anio as fraccion_envio_poranio
FROM salesorderheader s
JOIN salesorderdetail d using(SalesOrderID)
JOIN (SELECT year(OrderDate) as anio,SUM(OrderQty) as volumen_ventas_anio
		FROM salesorderheader s
		JOIN salesorderdetail d using(SalesOrderID)
		GROUP BY anio) j
ON year(s.OrderDate) = j.anio
GROUP BY anio,envio;
  #0.390


# CON FUNCION VENTANA
SELECT j.anio,
	   envio,
       cantidad_anio_envio,
	   SUM(cantidad_anio_envio) OVER (PARTITION BY anio) as cantidad_anio,
       cantidad_anio_envio / SUM(cantidad_anio_envio) OVER (PARTITION BY anio ORDER BY anio) as fraccion_envio_poranio
FROM(
	SELECT year(s.OrderDate) as anio,s.ShipMethodID as envio,SUM(d.OrderQty) as cantidad_anio_envio
    FROM salesorderheader s
    JOIN salesorderdetail d using(SalesOrderID)
    GROUP BY anio,envio

	) j;
    
    #0.156
       

#-------------- EJERCICIO 2 --------------

/*
Obtener un listado por categoría de productos, 
con el valor total de ventas y productos vendidos, 
mostrando para ambos, su porcentaje respecto del total.
*/

SELECT categoria,cantidad_categoria,format(total_categoria,4,'es_ES'),
	SUM(cantidad_categoria) OVER () as cantidad_productos,
    SUM(total_categoria) OVER () as total_productos,
    ROUND(cantidad_categoria / SUM(cantidad_categoria)  OVER (),3) * 100 as porcentaje_cantidad_categoria,
     ROUND(total_categoria / SUM(total_categoria) OVER (),3)*100 as porcentaje_total_categoria
FROM
	(SELECT pc.ProductCategoryID as categoria_id,pc.Name as categoria,SUM(d.OrderQty) as cantidad_categoria,SUM(d.LineTotal) as total_categoria
	FROM salesorderdetail d
	JOIN product p using(ProductID)
	JOIN productsubcategory ps using(ProductSubcategoryID)
	JOIN productcategory pc using(ProductCategoryID)
	GROUP BY categoria_id) v;


#CON FUNCION VENTANA
SELECT categoria,
		cantidad_categoria/SUM(cantidad_categoria) OVER() as fraccion_c,
        total_categoria/SUM(total_categoria) OVER()
FROM
		(SELECT	pc.ProductCategoryID as categoria,SUM(d.OrderQty) as cantidad_categoria,SUM(d.LineTotal) as total_categoria
		FROM salesorderheader s
		JOIN salesorderdetail d using(SalesOrderID)
		JOIN product p using(ProductID)
		JOIN productsubcategory sub using(ProductSubcategoryID)
		JOIN productcategory pc using(ProductCategoryID)
		GROUP BY categoria) j;
    
#0.438

#SIN FUNCION VENTANA
SELECT	pc.ProductCategoryID as categoria,
SUM(d.OrderQty) as cantidad_categoria,
SUM(d.LineTotal) as total_categoria,
SUM(d.OrderQty) / (SELECT SUM(OrderQty) FROM salesorderdetail),
SUM(d.LineTotal) / (SELECT SUM(LineTotal) FROM salesorderdetail)
FROM salesorderheader s
JOIN salesorderdetail d using(SalesOrderID)
JOIN product p using(ProductID)
JOIN productsubcategory sub using(ProductSubcategoryID)
JOIN productcategory pc using(ProductCategoryID)
GROUP BY categoria;

#0.500


#-------------- EJERCICIO 3 --------------

/*
Obtener un listado por país (según la dirección de envío),
 con el valor total de ventas y productos vendidos,
 mostrando para ambos, su porcentaje respecto del total.
*/

SELECT pais,
	   ventas_pais,
       total_pais,
       ROUND(ventas_pais / SUM(ventas_pais) OVER (),4)*100 as porcentaje_cantidad_cantidadPais,
       ROUND(total_pais / SUM(total_pais) OVER (),4)*100 as porcentaje_total_cantidadPais
       
FROM
	(SELECT c.Name as pais,SUM(d.OrderQty) as ventas_pais,SUM(d.LineTotal) as total_pais
	FROM salesorderheader s
	JOIN salesorderdetail d using(SalesOrderID)
	JOIN address a ON s.ShipToAddressID = a.AddressID
	JOIN stateprovince st ON a.StateProvinceID = st.StateProvinceID
	JOIN countryregion c using(CountryRegionCode)
	GROUP BY c.CountryRegionCode ) j;



#-------------- EJERCICIO 4 --------------

/*
Obtener por ProductID, los valores correspondientes a la mediana de las ventas (LineTotal),
 sobre las ordenes realizadas. Investigar las funciones FLOOR() y CEILING().
*/
 
SELECT producto,AVG(total_producto),Cantidad,Floor(Cantidad / 2), ceiling(Cantidad / 2),Fila
FROM (SELECT ProductID as producto ,LineTotal as total_producto,
	   COUNT(*) OVER (PARTITION BY ProductID ) as Cantidad,
	   ROW_NUMBER() OVER (PARTITION BY ProductID ORDER BY LineTotal DESC ) as Fila # ordeno por totales(para la mediana) agrupado por producto
		FROM salesorderheader s
		JOIN salesorderdetail using(SalesOrderID)
        ) j
        WHERE Fila = Floor(Cantidad / 2) AND Fila = ceiling(Cantidad / 2 )
			OR Floor(Cantidad / 2)  = ceiling((Cantidad  / 2))+1 # Calcula el promedio de e o los valores que estan en la mmitad
GROUP BY producto;


####FORMAT() PARA DAR FORMATO CON UNIDADES DE MIl
SELECT format(123123123,4,'es_Es')