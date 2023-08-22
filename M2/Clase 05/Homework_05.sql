create database henry_hc_05;
use henry_hc_05;

create table carrera (
	idCarrera int not null  auto_increment,/*Llave primaria*/
    nombre  varchar(20) not null,
    primary key (idCarrera)
);


create table instructor (
	idInstructor int not null  auto_increment,
    cedulaIdentidad varchar(30) not null,
    nombre varchar(20) not null,
    apellido varchar(20) not null,
    fechaNacimiento date not null,
    fechaIncorporacion date,
    primary key (idInstructor)
);




create table cohorte(
	idCohorte int not null  auto_increment,
    codigo varchar(30) not null,
    idCarrera int not null,
    idInstructor int not null,
    fechaInicio date,
    fechaFinalizacion date,
    primary key (idCohorte),
    foreign key(idCarrera) references carrera(idCarrera),
    foreign key(idInstructor) references instructor(idInstructor)
);

create table alumno(
	idAlumno int not null  auto_increment,
    cedulaIdentidad varchar(20) not null,
    nombre varchar(20) not null,
    apellido varchar(20) not null,
    fechaNacimiento date,
	fechaIngreso date,
    idCohorte int not null,
    primary key (idAlumno),
    foreign key (idCohorte) references cohorte(idCohorte)

);
