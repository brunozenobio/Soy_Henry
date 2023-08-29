SET log_bin_trust_function_creators = ON;

use adventureworks;

#---------------JERCICIO 1---------------
DROP PROCEDURE IF EXISTS  orders_fecha;
DELIMITER $$
CREATE PROCEDURE orders_fecha(IN fecha_orden DATE)
BEGIN
	SELECT count(*) 
    FROM salesorderheader
    WHERE OrderDate = fecha_orden;
END$$
DELIMITER ;
CALL orders_fecha('2001-07-01');

#---------------EJERCICIO 2---------------
DROP FUNCTION IF EXISTS nominal;
DELIMITER $$
CREATE FUNCTION nominal(precio DECIMAL(12,3),margen_bruto DECIMAL(6,2)) RETURNS DECIMAL(12,3)
BEGIN
	DECLARE valor_nominal DECIMAL(12,3);
	SET valor_nominal = precio * (margen_bruto);
	RETURN valor_nominal;

END$$


DELIMITER ;

#---------------JERCICIO 3---------------

SELECT ProductID,Name,
		ListPrice,StandardCost,
        nominal(StandardCost,1.2) as Valor_Nominal,
        ListPrice - nominal(StandardCost,1.2) as Diferencia
FROM product
ORDER BY Name;

#---------------JERCICIO 4---------------

DROP PROCEDURE IF EXISTS costo_fechas;

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


CALL costo_fechas('2001-05-31','2001-7-31');


#---------------EJERCICIO 5---------------
DROP PROCEDURE IF EXISTS insert_shipmethod;
DELIMITER $$
CREATE PROCEDURE insert_shipmethod(name VARCHAR(50),ShipBase DOUBLE,ShipRate DOUBLE)
BEGIN
	INSERT INTO shipmethod (Name,ShipBase,ShipRate,ModifiedDate)
    VALUES(name,ShipBase,ShipRate,CURRENT_TIMESTAMP());

END$$
DELIMITER ;
CALL insert_shipmethod('BICLITE 4 RUEDAS',6.44,1.66);