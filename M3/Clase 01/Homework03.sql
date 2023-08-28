SET log_bin_trust_function_creators = ON;

use adventureworks;

#---------------JERCICIO 1---------------
DROP PROCEDURE  orders_fecha;
DELIMITER $$
CREATE PROCEDURE orders_fecha(IN fecha_orden DATE)
BEGIN
	SELECT count(*) 
    FROM salesorderheader
    WHERE DATE(OrderDate) = fecha_orden;
END$$
DELIMITER ;


CALL orders_fecha('2002-01-01');

#---------------JERCICIO 2---------------

DELIMITER $$
CREATE FUNCTION nominal(precio_lista DECIMAL(8,1),margen_bruto DECIMAL(2,1)) RETURNS DECIMAL(8,1)
BEGIN
	DECLARE valor_nominal DECIMAL(8,1);
	SET valor_nominal = precio_lista * (margen_bruto + 1);
	RETURN valor_nominal;

END$$


DELIMITER ;

#---------------JERCICIO 3---------------

SELECT Name,ListPrice,StandardCost,nominal(StandardCost,0.2) as Valor_Nominal,ListPrice - nominal(StandardCost,0.2) as Diferencia
FROM product
ORDER BY Name;

#---------------JERCICIO 4---------------

DELIMITER $$
CREATE PROCEDURE costo_fechas(fecha_desde DATE,fecha_hasta DATE)
BEGIN
	SELECT CustomerID,SUM(Freight) as total_trasnporte
    FROM salesorderheader
    WHERE OrderDate BETWEEN fecha_desde AND fecha_hasta
    GROUP BY CustomerID
    ORDER BY total_trasnporte DESC
    LIMIT 10;

END$$
DELIMITER ;


CALL costo_fechas('2001-05-31','2001-7-31')


#---------------JERCICIO 5---------------

DELIMITER $$
CREATE PROCEDURE insert_shipmethod(name VARCHAR(50),ShipBase DOUBLE,ShipRate DOUBLE,rowguid varbinary(16))
BEGIN
	INSERT INTO shipmethod (Name,ShipBase,ShipRate,rowguid,ModifedDate)
    VALUES(name,ShipBase,ShipRate,rowguid,CURRENT_TIMESTAMP());

END$$
DELIMITER ;
