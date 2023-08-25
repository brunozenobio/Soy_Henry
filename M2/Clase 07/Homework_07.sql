# Ejercicio 1
SELECT count(*) as cantidadCarreras
FROM carrera;
#Hay un total de 2 carreras

# Ejercicio 2 
SELECT count(*) as cantidadAlumnos
FROM alumno;
#Hay un total de 180 alumnos

# Ejercicio 3
SELECT a.idCohorte,count(*)
FROM alumno a
GROUP BY a.idCohorte;
# Cada cohorte tiene 20 alumnos

# Ejercicio 4 
SELECT idAlumno,cedulaIdentidad,concat(nombre,' ',apellido) as Nombre_Y_Apellido ,fechaNacimiento,fechaIngreso,idCohorte
FROM alumno
ORDER BY fechaIngreso DESC;

# Ejercicio 5  y 6

#################ALTERNATIVA 1##############
SELECT nombre
FROM alumno
ORDER BY fechaIngreso
LIMIT 1;
#EL nombre del primer alumno que ingreso a henry es Beverly
SELECT fechaIngreso
FROM alumno
ORDER BY fechaIngreso
LIMIT 1;

############ALTERNATIVA 2##############
SELECT min(fechaIngreso)
FROM alumno;


#########ALTERNATIVA 3############# LA MAS CORRECTA
SELECT fechaIngreso
FROM alumno
WHERE fechaIngreso = (SELECT min(fechaIngreso) FROM alumno);



# Ingreso el 4 de diciembre de 2019


# Ejercicio 7 
SELECT nombre
FROM alumno
ORDER BY fechaIngreso DESC
LIMIT 1;
# El ultimo alumno que ingreso es Jason

# Ejercicio 8 
SELECT  year(fechaIngreso) as AñoIngreso,count(*) as AlumnosPorAño
FROM alumno
GROUP BY AñoIngreso
ORDER BY 1; # Ordena por columna 1

# Ejercicio 9 
SELECT year(fechaIngreso) as Año,weekofyear(fechaIngreso) as Semana,count(*) as Alumnos
FROM alumno
GROUP BY año,semana
ORDER BY 1;

# Ejercicio 10
SELECT count(*) as AlumnosPorAño,year(fechaIngreso)
FROM alumno
GROUP BY year(fechaIngreso)
HAVING AlumnosPorAño>20
ORDER BY 1;
# EN los años 2020 2021 2022

# Ejercicio 11
SELECT concat(nombre,' ',apellido) as NombreYApellido,timestampdiff(year,fechaNacimiento,curdate()) as Edad ##PASO LA UNIDAD EN QUE QUIERO EL RESULTADO; LA FECHA MAYOR,LA FECHA MENOR
FROM instructor;
# Si se puede calcular la edad

SELECT concat(nombre,' ',apellido) as NombreYApellido,fechaNacimiento,timestampdiff(year,fechaNacimiento,curdate()) as Edad,date_add(fechaNacimiento,interval timestampdiff(year,fechaNacimiento,curdate()) year ) as Ver
FROM instructor;
# Timestamptdiff Cuenta tambien los dias por lo tanto es correcta para calcular la edad 



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
