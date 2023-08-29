use adventureworks;

#---------------- EJERCICIO 1 ----------------
SELECT c.ContactID,concat(c.FirstName,' ',c.LastName) as NombreApellido,c.EmailAddress,c.Phone 
FROM contact c
JOIN salesorderheader s ON c.ContactID = s.ContactID
JOIN salesorderdetail sd ON sd.SalesOrderID = s.SalesOrderID
JOIN product p ON p.ProductID = sd.ProductID
JOIN  productsubcategory ps ON p.ProductSubcategoryID = ps.ProductSubcategoryID
JOIN shipmethod sh ON sh.ShipMethodID = s.ShipMethodID
WHERE ps.Name = 'Mountain Bikes' AND year(s.OrderDate) BETWEEN 2000 AND 2003 AND sh.Name = 'CARGO TRANSPORT 5' ;


#---------------- EJERCICIO 2 ----------------

SELECT c.ContactID,concat(c.FirstName,' ',c.LastName) as NombreApellido,c.EmailAddress,c.Phone,SUM(sd.OrderQty) as CantidadProducto
FROM contact c
JOIN salesorderheader s ON c.ContactID = s.ContactID
JOIN salesorderdetail sd ON sd.SalesOrderID = s.SalesOrderID
JOIN product p ON p.ProductID = sd.ProductID
JOIN  productsubcategory ps ON p.ProductSubcategoryID = ps.ProductSubcategoryID
WHERE ps.Name = 'Mountain Bikes' AND year(s.OrderDate) BETWEEN 2000 AND 2003 
GROUP BY c.ContactID
ORDER BY SUM(sd.OrderQty) DESC;

#---------------- EJERCICIO 3 ----------------


SELECT year(p.OrderDate) as Año,s.Name as Envio,SUM(pd.OrderQty) as Cantidad
FROM purchaseorderheader p
JOIN shipmethod s ON p.ShipMethodID = s.ShipMethodID
JOIN purchaseorderdetail pd ON pd.PurchaseOrderID = p.PurchaseOrderID
GROUP BY year(p.OrderDate),s.ShipMethodID
ORDER BY Cantidad DESC;


#---------------- EJERCICIO 4 ----------------

SELECT ps.Name,SUM(sd.OrderQty) as Cantidad,SUM(sd.LineTotal) as Total
FROM salesorderheader s
JOIN salesorderdetail sd ON sd.SalesOrderID = s.SalesOrderID
JOIN product p ON p.ProductID = sd.ProductID
JOIN productsubcategory psc ON p.ProductSubcategoryID = psc.ProductSubcategoryID # psc.ProductCategoryID (Asi lo hace en el resuelto)
JOIN productcategory ps ON ps.ProductCategoryID = psc.ProductCategoryID
GROUP BY ps.Name; 


#---------------- EJERCICIO 5 ----------------

SELECT cr.Name as Pais,SUM(sd.OrderQty) as Cantidad,SUM(sd.LineTotal) as TotalPrecio
FROM salesorderheader s
JOIN salesorderdetail sd ON s.SalesOrderID = sd.SalesOrderID
JOIN address a ON a.AddressID = s.ShipToAddressID
JOIN stateprovince st ON a.StateProvinceID = st.StateProvinceID
JOIN countryregion cr ON cr.CountryRegionCode = st.CountryRegionCode
GROUP BY cr.Name
HAVING Cantidad>15000;


#---------------- EJERCICIO 6 ----------------
use henry_hc_05;

SELECT DISTINCT c.*
FROM cohorte c
LEFT JOIN alumno a ON a.idCohorte = c.idCohorte
WHERE a.idCohorte is null;



