use adventureworks;
#-------------- EJERCICIO 1 --------------
/*
Obtener un listado de cuál fue el volumen de ventas (cantidad) por año y 
método de envío mostrando para cada registro, qué porcentaje representa 
del total del año. Resolver utilizando Subconsultas y Funciones Ventana, 
luego comparar la diferencia en la demora de las consultas.
*/

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
       ventas_pais / SUM(ventas_pais) OVER () as fraccion_cantidadPais,
       total_pais / SUM(total_pais) OVER () as fraccion_cantidadPais
       
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
	   ROW_NUMBER() OVER (PARTITION BY ProductID ORDER BY LineTotal DESC ) as Fila
		FROM salesorderheader s
		JOIN salesorderdetail using(SalesOrderID)
        ) j
        WHERE Fila = Floor(Cantidad / 2) AND Fila = ceiling(Cantidad / 2 )
			OR Fila = ceiling((Cantidad / 2))
GROUP BY producto;




