
CREATE DATABASE test;
use test;
#########TABLA CANAL DE VENTAS##########
DROP TABLE IF EXISTS canal_venta;
CREATE TABLE canal_venta(
	Codigo INT,
    Descripcion VARCHAR(50)
);
########################
#########TIPO DE GASTO##########

DROP TABLE IF EXISTS tipo_gasto;
CREATE TABLE tipo_gasto(
	ID_tipo_gasto INT,
    Descripcion VARCHAR(50),
    Monto_aproximado VARCHAR(50)
);

########################
#########SUCURSALES##########
DROP TABLE IF EXISTS sucursal;
CREATE TABLE sucursal(
	ID_sucursal INT,
    Nombre VARCHAR(80),
    Direccion VARCHAR(100),
    Localidad VARCHAR(100),
    Provincia VARCHAR(100),
    Latitud VARCHAR(70),
    Longitud VARCHAR(70)
);
########################
#########EMPLEADOS##########
DROP TABLE IF EXISTS empleado;
CREATE TABLE empleado (
					ID_empleado INTEGER ,
                    Apellido VARCHAR(30) ,
                    Nombre Varchar(30) ,
                    Surcursal VARCHAR(50),
                    Sector VARCHAR(40),
                    Cargo Varchar(40),
                    Salario DECIMAL(13,3)

);
########################
#########PROVEEDORES##########
DROP TABLE IF EXISTS proveedor;
CREATE TABLE proveedor(
			ID_proveedor INTEGER ,
            Nombre VARCHAR(50),
            Address VARCHAR(80),
            City VARCHAR(60),
            State VARCHAR(60),
            Country VARCHAR(50),
            Departamen VARCHAR(80)
);
########################
#########CLIENTES##########

DROP TABLE IF EXISTS cliente;
CREATE TABLE cliente (
		ID_cliente INT ,
        Provincia VARCHAR(40),
        Nombre_Apellido VARCHAR(80),
        Domicilio VARCHAR(120),
        Telefono VARCHAR(80),
        Edad INT,
        Localidad VARCHAR(80),
        Longitud VARCHAR(50),
        Latitud VARCHAR(50),
        Fecha_Alta DATE,
        Usuario_Alta VARCHAR(40),
        Fecha_Modificacion DATE,
        Usuario_Modificacion VARCHAR(30),
        Marca_Baja TINYINT,
        col10 VARCHAR(1)
);
########################
#########PRODUCTOS##########
CREATE TABLE producto (
		ID_producto INT,
        Concepto VARCHAR(100),
        Tipo VARCHAR(80),
        Precio DOUBLE
);

########################


#########VENTAS#########
DROP TABLE IF EXISTS venta;
CREATE TABLE venta(
				ID_venta INT ,
                Fecha DATE,
                Fecha_Entrega DATE,
				ID_canal INT,
                ID_cliente INT,
                ID_sucursal INT ,
                ID_empleado INT ,
                ID_producto INT ,
                Precio VARCHAR(40),
                Cantidad VARCHAR(40)

);
########################
#########GASTO#########
DROP TABLE IF EXISTS gasto;
CREATE TABLE gasto(
		ID_gasto INT ,
        ID_sucursal INT ,
        ID_tipo_gasto INT,
        Fecha DATE,
        Monto VARCHAR(40)
);
########################

#########COMPRA#########
DROP TABLE IF EXISTS compra;
CREATE TABLE compra(
		ID_compra INT ,
        Fecha DATE,
        ID_producto INT,
        Cantidad INT,
        Precio VARCHAR(40),
        ID_proveedor INT 
);
########################

##########        CARGANDO LOS DATOS        # ##############

SHOW GLOBAL VARIABLES LIKE 'local_infile';
SHOW GRANTS;
SET GLOBAL local_infile = ON;
GRANT FILE ON *.* TO 'root'@'localhost';
FLUSH PRIVILEGES;
SELECT @@global.secure_file_priv;
SHOW GRANTS FOR 'root'@'localhost';
#sucursal

#########SUCURSALES##########
LOAD DATA INFILE 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\Sucursales.csv'
INTO TABLE sucursal
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ';' OPTIONALLY ENCLOSED BY '\"' ESCAPED BY '\"'
LINES  TERMINATED BY '\n'
IGNORE 1 LINES;

#########EMPLEADOS##########
LOAD DATA INFILE 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\Empleados.csv'
INTO TABLE empleado
FIELDS TERMINATED BY ','  
LINES  TERMINATED BY '\n'
IGNORE 1 LINES;


#########PROVEEDORES##########

LOAD DATA INFILE 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\Proveedores .csv' 
INTO TABLE proveedor
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"' 
LINES TERMINATED BY '\n' IGNORE 1 LINES;

#########CLIENTES##########
LOAD DATA INFILE 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\Clientes.csv' 
INTO TABLE cliente
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ';' ENCLOSED BY '"' 
LINES TERMINATED BY '\n' 
IGNORE 1 LINES;

########PRODUCTOS##########
LOAD DATA INFILE 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\Productos.csv' 
INTO TABLE producto
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n' 
IGNORE 1 LINES;

#########VENTAS#########
LOAD DATA INFILE 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\Ventas.csv' 
INTO TABLE venta
FIELDS TERMINATED BY ',' ENCLOSED BY '' ESCAPED BY ''
LINES  TERMINATED BY '\n' 
IGNORE 1 LINES;

#########GASTO#########

LOAD DATA INFILE 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\Gastos.csv' 
INTO TABLE gasto
FIELDS TERMINATED BY ',' ENCLOSED BY '' ESCAPED BY ''
LINES  TERMINATED BY '\n' 
IGNORE 1 LINES;

#########COMPRA#########

LOAD DATA INFILE 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\Compra.csv' 
INTO TABLE compra
FIELDS TERMINATED BY ',' ENCLOSED BY '' ESCAPED BY ''
LINES  TERMINATED BY '\n' 
IGNORE 1 LINES;

#########TIPO DE GASTO##########
LOAD DATA INFILE 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\Tipo_gasto.csv' 
INTO TABLE tipo_gasto
FIELDS TERMINATED BY ',' ENCLOSED BY '' ESCAPED BY ''
LINES  TERMINATED BY '\n' 
IGNORE 1 LINES;


#########TABLA CANAL DE VENTAS##########
LOAD DATA INFILE 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\Canal_venta.csv' 
INTO TABLE canal_venta
FIELDS TERMINATED BY ',' ENCLOSED BY '' ESCAPED BY ''
LINES  TERMINATED BY '\n' 
IGNORE 1 LINES;







