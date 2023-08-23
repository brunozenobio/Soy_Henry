# Ejercicio 1
SELECT count(*) as cantidadCarreras
FROM carrera;
#Hay un total de 2 carreras

# Ejercicio 2 
SELECT count(*) as cantidadAlumnos
FROM alumno;
#Hay un total de 180 alumnos

# Ejercicio 3
SELECT count(*)
FROM alumno a
JOIN cohorte c ON c.idCohorte = a.idCohorte
GROUP BY c.idCohorte;
# Cada cohorte tiene 20 alumnos

# Ejercicio 4 
SELECT idAlumno,cedulaIdentidad,concat(nombre,' ',apellido) as Nombre_Y_Apellido ,fechaNacimiento,fechaIngreso,idCohorte
FROM alumno
ORDER BY fechaIngreso DESC;

# Ejercicio 5  y 6
SELECT nombre
FROM alumno
ORDER BY fechaIngreso
LIMIT 1;
#EL nombre del primer alumno que ingreso a henry es Beverly
SELECT fechaIngreso
FROM alumno
ORDER BY fechaIngreso
LIMIT 1;

# Ingreso el 4 de diciembre de 2019

# Ejercicio 7 
SELECT nombre
FROM alumno
ORDER BY fechaIngreso DESC
LIMIT 1;
# El ultimo alumno que ingreso es Jason

# Ejercicio 8 
SELECT count(*) as AlumnosPorAño
FROM alumno
GROUP BY year(fechaIngreso);

# Ejercicio 9 
SELECT weekofyear(fechaIngreso) as Semana,count(*) as AlumnosPorSemana,year(fechaIngreso) as Año
FROM alumno
GROUP BY weekofyear(fechaIngreso),year(fechaIngreso);

# Ejercicio 10
SELECT count(*) as AlumnosPorAño,year(fechaIngreso)
FROM alumno
GROUP BY year(fechaIngreso)
HAVING count(*)>20;

# EN los años 2020 2021 2022

# Ejercicio 11
SELECT concat(nombre,' ',apellido) as NombreYApellido,timestampdiff(year,fechaNacimiento,curdate()) ##PASO LA UNIDAD EN QUE QUIERO EL RESULTADO; LA FECHA MAYOR,LA FECHA MENOR
FROM instructor;
# Si se puede calcular la edad

SELECT concat(nombre,' ',apellido) as NombreYApellido,fechaNacimiento,timestampdiff(year,fechaNacimiento,curdate()) as Edad,date_add(fechaNacimiento,interval timestampdiff(year,fechaNacimiento,curdate()) year ) as Ver
FROM instructor;
# Solo cuenta los años



# Ejercicio 12 
SELECT nombre,timestampdiff(year,fechaNacimiento,curdate()) as Edad
FROM alumno;

SELECT avg(timestampdiff(year,fechaNacimiento,curdate()) ) as EdadPromedio
FROM alumno;


SELECT cohorte.codigo as Cohorte,avg(timestampdiff(year,fechaNacimiento,curdate()) ) as EdadPromedioPorCohorte
FROM alumno
JOIN cohorte ON alumno.idCohorte = cohorte.idCohorte
GROUP BY alumno.idCohorte;

# Ejercicio 13
##CALCULO EL PROMEDIO

SELECT avg(timestampdiff(year,fechaNacimiento,curdate())) as EdadPromedio
FROM alumno
 ;
#22.5167


SELECT timestampdiff(year,fechaNacimiento,curdate()) as Edad
FROM alumno
WHERE timestampdiff(year,fechaNacimiento,curdate()) > (SELECT avg(timestampdiff(year,fechaNacimiento,curdate())) as EdadPromedio
FROM alumno) ;
