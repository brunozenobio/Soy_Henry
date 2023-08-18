create database henry_hc_05;
use henry_hc_05;

create table Carrera (
	id_carrera int not null  auto_increment,/*Llave primaria*/
    nombre  varchar(20) not null,
    primary key (id_carrera)
);


create table Instructor (
	id_instructor int not null  auto_increment,
    celula_identidad varchar(20) not null,
    nombre varchar(20) not null,
    apellido varchar(20) not null,
    fecha_nacimiento date not null,
    fecha_incorporacion date,
    primary key (id_instructor)
);




create table Cohorte(
	id_cohorte int not null  auto_increment,
    codigo int not null,
    fecha_inicio date,
    fecha_fin date,
    id_carrera int not null,
    id_instructor int not null,
    primary key (id_cohorte),
    foreign key(id_carrera) references Carrera(id_carrera),
    foreign key(id_instructor) references Instructor(id_instructor)
);

create table alumno(
	id_alumno int not null  auto_increment,
    cedula_identidad varchar(20) not null,
    nombre varchar(20) not null,
    apellido varchar(20) not null,
    fecha_nacimiento date,
	fecha_ingreso date,
    id_cohorte int not null,
    primary key (id_alumno),
    foreign key (id_cohorte) references Cohorte(id_cohorte)

);
