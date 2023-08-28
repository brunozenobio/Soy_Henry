SELECT venta.IdCanal,canal_venta.Canal as Canal,count(*) as Cantidad,SUM(Precio*Cantidad)
FROM venta
JOIN canal_venta ON venta.IdCanal = canal_venta.IdCanal
GROUP BY IdCanal
ORDER BY 4;


select IdCanal, sum((Precio*Cantidad))
from venta
group by IdCanal
order by 2;

########################

SELECT c.Canal,count(*) as cantidad_ventas
FROM venta v
JOIN canal_venta c ON v.IdCanal = c.IdCanal
WHERE year(Fecha) = 2020
GROUP BY v.IdCanal
ORDER BY 2;


####################
SELECT p.Tipo,count(*),SUM(v.Cantidad * v.Precio)
FROM venta v
JOIN producto p ON v.IDProducto = p.IDProducto
WHERE year(v.Fecha) = 2020
GROUP BY p.Tipo
ORDER BY  3 DESC;


####################

SELECT  date_format(Fecha,'%m%Y') as Añomes,avg(timestampdiff(day,Fecha,Fecha_Entrega)) as diasEntrega
FROM venta
GROUP BY date_format(Fecha,'%m%Y')
ORDER BY 2;

select year(Fecha) as anio, month(Fecha), avg(timestampdiff(day,Fecha,Fecha_Entrega))
from venta 
group by anio, month(Fecha) 
order by 1,2,3;



#################

SELECT count(*) as productos
FROM producto
WHERE Tipo LIKE 'i%';


###################
SELECT IDProducto,Concepto 
FROM producto
WHERE Concepto = 'EPSON COPYFAX 2000';

#############################
SELECT IDProducto,Concepto 
FROM producto
WHERE Concepto = 'PARLANTE JBL GO ORANGE BLUETOOTH';


##################################


SELECT month(Fecha) as Mes,SUM(Precio*Cantidad),count(*)
FROM venta
WHERE IdSucursal = 13 and year(Fecha) = 2015
GROUP BY Mes
ORDER BY SUM(Precio*Cantidad);
