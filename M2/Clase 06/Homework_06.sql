-- MODIFICAR VALORES
#TRUCANTE TABLE tabla; 
	#Para borrar los registros de la tabla y ademas volver los indices a 0
	# Hay que tener cuidado porque si tengo tablas referenciadas con llave foranea dara un error
	# Para esto puedo temporalmente desabilitar esa referencia
	# SET foreign_key_checks = 0

# Ejercicio 2
DELETE FROM cohorte
WHERE idCohorte IN (1245,1246); 

select date_format(fechaInicio,'%m-%d') from cohorte where idCohorte = 1243;

# Ejercicio 3
UPDATE  cohorte
SET fechaInicio = '2022-05-16'
WHERE idCohorte = 1243;

# Ejercicio 4
UPDATE alumno
SET apellido = 'Ramirez'
WHERE idAlumno = 165;

-- MOSTRAR VALORES

# Ejercicio 5
SELECT idAlumno,nombre,fechaIngreso
FROM alumno
WHERE idCohorte = 1243;

# Ejercicio 6
SELECT idCarrera
FROM carrera
WHERE nombre LIKE '%F%';

SELECT DISTINCT idInstructor
FROM cohorte
WHERE idCarrera = 1;

SELECT *
FROM instructor
WHERE idInstructor IN (1,2,3,4,5);

SELECT DISTINCT i.*
FROM instructor i
JOIN cohorte co ON co.idInstructor = i.idInstructor
JOIN carrera c ON c.idCarrera = co.idCarrera
WHERE c.nombre LIKE '%full%';




# Ejercicio 7

SELECT nombre
FROM alumno
WHERE idCohorte = 1235;

# Ejercicio 8

SELECT nombre
FROM alumno
WHERE idCohorte = 1235 AND
fechaIngreso BETWEEN '2019-01-01' AND '2019-12-31'; # ALTERNATIVA YEAR(fechaIngreso) = 2019

# Ejercicio 9


SELECT alumno.nombre, apellido, fechaNacimiento, carrera.nombre as NombeCarrera
FROM alumno
INNER JOIN cohorte
ON cohorte.idCohorte=alumno.idCohorte
INNER JOIN carrera
ON carrera.idCarrera = cohorte.idCarrera;


/*
a : Se puede acceder al nombre de la carrera desde alumnos por medio de idCohorte
b : LA relacion es muchos a 1 muchos alumnos pertenecen a 1 cohorte 
c : 
*/


# C solucion 1
SELECT alumno.nombre, apellido, fechaNacimiento, carrera.nombre
FROM alumno
INNER JOIN cohorte
ON cohorte.idCohorte=alumno.idCohorte
INNER JOIN carrera
ON carrera.idCarrera = cohorte.idCarrera
WHERE carrera.nombre
LIKE '%Full Stack Developer%';
 
 # C solucion 2
 
 SELECT alumno.nombre, apellido, fechaNacimiento, carrera.nombre
FROM alumno
INNER JOIN cohorte
ON cohorte.idCohorte=alumno.idCohorte
INNER JOIN carrera
ON carrera.idCarrera = cohorte.idCarrera
WHERE carrera.nombre
NOT LIKE '%Data Science%';

# La mas correcta seria con Like ya que de haber mas carreras podria traer mas de una al usar Not like

# D solucion 1:

 SELECT alumno.nombre, apellido, fechaNacimiento, carrera.nombre
FROM alumno
INNER JOIN cohorte
ON cohorte.idCohorte=alumno.idCohorte
INNER JOIN carrera
ON carrera.idCarrera = cohorte.idCarrera
WHERE carrera.nombre =  'Full Stack Developer';

# D solucion 2:

 SELECT alumno.nombre, apellido, fechaNacimiento, carrera.nombre
FROM alumno
INNER JOIN cohorte
ON cohorte.idCohorte=alumno.idCohorte
INNER JOIN carrera
ON carrera.idCarrera = cohorte.idCarrera
WHERE carrera.nombre !=  'Data Science';

# La mas correcta seria con = ya que de haber mas carreras podria traer mas de una al usar !=


# E:

 SELECT alumno.nombre, apellido, fechaNacimiento, carrera.nombre
FROM alumno
INNER JOIN cohorte
ON cohorte.idCohorte=alumno.idCohorte
INNER JOIN carrera
ON carrera.idCarrera = cohorte.idCarrera
WHERE carrera.idCarrera = 1;


SELECT round(avg(year(curdate()) - year(fechaNacimiento)),2) as Edad
FROM alumno
ORDER BY fechaNacimiento;
-- 32.94 promedio de la edad con valores extremos
-- 22.94 Promedio de la edad sin valores extremos.
UPDATE alumno
SET fechaNacimiento = '2002-01-02'
WHERE idAlumno = 127;
