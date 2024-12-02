USE gestioncompras;


CREATE DATABASE GestionCompras;

SELECT * FROM Clientes;
SELECT * FROM Compras;
SELECT * FROM DetalleCompras;
SELECT * FROM Productos;

-- Tabla Clientes
CREATE TABLE Clientes (
    ID_Cliente INT AUTO_INCREMENT PRIMARY KEY,
    Nombre VARCHAR(100) NOT NULL,
    Correo VARCHAR(100) NOT NULL UNIQUE,
    Teléfono VARCHAR(15),
    Ubicación POINT NOT NULL,
    SPATIAL INDEX (Ubicación)
);
SELECT * FROM Clientes;

INSERT INTO Clientes (Nombre, Correo, Teléfono, Ubicación)
VALUES ('pruebacliente', 'cliente@prueba.com', '123456789', POINT(0, 0));

INSERT INTO Clientes (Nombre, Correo, Teléfono, Ubicación)
VALUES ('Chinacota', 'chinacota@datos.com', '32321221', POINT(2, 3));



-- Tabla Productos
CREATE TABLE Productos (
    ID_Producto INT AUTO_INCREMENT PRIMARY KEY,
    Nombre VARCHAR(100) NOT NULL,
    Descripción TEXT,
    Precio DECIMAL(10, 2) NOT NULL,
    Stock INT NOT NULL,
    Stock_Minimo INT NOT NULL
);
SET SQL_SAFE_UPDATES = 0;

DELETE FROM Productos;
SELECT * FROM productos
INSERT INTO Productos (Nombre, Descripción, Precio, Stock, Stock_Minimo)
VALUES ('Tarjeta Plateada', 'Tarjeta de crédito con límite de $7,500', 85.000, 35, 5);

INSERT INTO Productos (Nombre, Descripción, Precio, Stock, Stock_Minimo)
VALUES ('Tarjeta Roja', 'Tarjeta de crédito con límite de $8,000', 90.000, 40, 2);

INSERT INTO Productos (Nombre, Descripción, Precio, Stock, Stock_Minimo)
VALUES
    ('Tarjeta Roja', 'Tarjeta de crédito con límite de $10,000', 105.000, 50, 5),
	('Tarjeta Azul', 'Tarjeta de crédito con límite de $5,000', 75.000, 30, 3),
	('Tarjeta Dorada', 'Tarjeta de crédito premium con límite de $20,000', 150.000, 40, 4),
	('Tarjeta Negra', 'Tarjeta de crédito élite con beneficios exclusivos', 200.000, 25, 2),
	('Tarjeta Verde', 'Tarjeta de crédito con cashback de 1%', 90.000, 60, 6),
   ('Tarjeta Morada', 'Tarjeta de crédito con límite de $9,000', 45.00, 20, 5);





-- Tabla Compras
CREATE TABLE Compras (
    ID_Compra INT AUTO_INCREMENT PRIMARY KEY,
    ID_Cliente INT NOT NULL,
    Fecha_Compra DATETIME NOT NULL,
    Total DECIMAL(10, 2) NOT NULL,
    Estado VARCHAR(50) DEFAULT 'Completado',
    FOREIGN KEY (ID_Cliente) REFERENCES Clientes(ID_Cliente)
);
Select * from Compras
INSERT INTO Compras (ID_Cliente, Fecha_Compra, Total, Estado)
VALUES (5, NOW(), 75.000, 'Completado');

SELECT * FROM compras
CREATE PROCEDURE RegistrarCompra(
    IN p_ID_Cliente INT,
    IN p_Fecha_Compra DATETIME,
    IN p_ID_Producto INT,
    IN p_Cantidad INT
)
BEGIN
    DECLARE v_ID_Compra INT;
    DECLARE v_PrecioUnitario DECIMAL(10, 2);
    DECLARE v_Subtotal DECIMAL(10, 2);

    -- Insertar la compra
    INSERT INTO Compras (ID_Cliente, Fecha_Compra, Total)
    VALUES (p_ID_Cliente, p_Fecha_Compra, 0);

    SET v_ID_Compra = LAST_INSERT_ID();

    -- Obtener el precio unitario del producto
    SELECT Precio INTO v_PrecioUnitario
    FROM Productos
    WHERE ID_Producto = p_ID_Producto;

    -- Calcular el subtotal
    SET v_Subtotal = p_Cantidad * v_PrecioUnitario;

    -- Insertar en DetalleCompras
    INSERT INTO DetalleCompras (ID_Compra, ID_Producto, Cantidad, Subtotal)
    VALUES (v_ID_Compra, p_ID_Producto, p_Cantidad, v_Subtotal);

    -- Actualizar el total de la compra
    UPDATE Compras
    SET Total = v_Subtotal
    WHERE ID_Compra = v_ID_Compra;



-- Tabla DetalleCompras
CREATE TABLE DetalleCompras (
    ID_Detalle INT AUTO_INCREMENT PRIMARY KEY,
    ID_Compra INT NOT NULL,
    ID_Producto INT NOT NULL,
    Cantidad INT NOT NULL,
    Subtotal DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (ID_Compra) REFERENCES Compras(ID_Compra),
    FOREIGN KEY (ID_Producto) REFERENCES Productos(ID_Producto)
);
select * from DetalleCompras

INSERT INTO DetalleCompras (ID_Compra, ID_Producto, Cantidad, Subtotal)
VALUES (43, 15, 2, 95.00); -- en el segundo numero tengo desde 10 hasta 18, recordar!

SELECT * FROM DetalleCompras;




INSERT INTO Compras (ID_Cliente, Fecha_Compra, Total, Estado)
VALUES (1, NOW(), 0.00, 'Pendiente');



CALL RegistrarCompra(1, NOW(), 8, 2);

SELECT * FROM Clientes;
SELECT * FROM Compras;
SELECT * FROM DetalleCompras;
SELECT * FROM Productos;




-- Tabla Devoluciones
CREATE TABLE Devoluciones (
    ID_Devolución INT AUTO_INCREMENT PRIMARY KEY,
    ID_Cliente INT NOT NULL,
    ID_Compra INT NOT NULL,
    ID_Producto INT NOT NULL,
    Motivo TEXT NOT NULL,
    Fecha_Devolución DATETIME NOT NULL,
    FOREIGN KEY (ID_Cliente) REFERENCES Clientes(ID_Cliente),
    FOREIGN KEY (ID_Compra) REFERENCES Compras(ID_Compra),
    FOREIGN KEY (ID_Producto) REFERENCES Productos(ID_Producto)
);
select * from Devoluciones
select * from Compras

INSERT INTO Devoluciones (ID_Cliente, ID_Compra, ID_Producto, Fecha_Devolucion, Motivo)
VALUES (5, 44, 18, NOW(), 'La tarjeta es diferente a la que pedí');

SELECT * FROM Clientes WHERE ID_Cliente = 5;
SELECT * FROM Compras WHERE ID_Compra = 43 AND ID_Cliente = 5;
SELECT * FROM Productos WHERE ID_Producto = 18;



-- Tabla Sucursales
CREATE TABLE Sucursales (
    ID_Sucursal INT AUTO_INCREMENT PRIMARY KEY,
    Nombre VARCHAR(100) NOT NULL,
    Ubicación POINT NOT NULL,
    SPATIAL INDEX (Ubicación)
);
INSERT INTO Sucursales (Nombre, Ubicación)
VALUES 
    ('Sucursal Centro', POINT(5, 5)),
    ('Sucursal Norte', POINT(10, 15)),
    ('Sucursal Sur', POINT(-5, -10));
    
SELECT * FROM Sucursales

DELIMITER //








-- aqui basicamente es para mostrar el procedimiento de almacenado, declarar y utilizar variabe y devolver
CREATE PROCEDURE TestProcedure()
BEGIN
    DECLARE v_Test INT;
    SET v_Test = 1;
    SELECT v_Test AS Result;
END;
//
DELIMITER ;
CALL TestProcedure(); 

DROP PROCEDURE IF EXISTS RegistrarCompra;

DELIMITER //

select * from Productos

    -- Actualizar el stock
    UPDATE Productos
    SET Stock = Stock - p_Cantidad
    WHERE ID_Producto = p_ID_Producto;
END;
//

DELIMITER ;


-- aqui llamamos al procedimiento con datos de prueba
CALL RegistrarCompra(1, NOW()); 


    -- ponerle valor fijo al stock
    UPDATE Productos
	SET Stock = 60
	WHERE ID_Producto = 4;
    
    select * from Productos
    -- o se sumamos
    UPDATE Productos
	SET Stock = Stock + 3
	WHERE ID_Producto = 10;
    
    








SET SQL_SAFE_UPDATES = 0;
DELETE FROM DetalleCompras WHERE ID_Producto IN (1, 2, 3);
DELETE FROM Productos WHERE ID_Producto IN (1, 2, 3);


CALL RegistrarCompra(1, NOW(), 1, 3); 
CALL RegistrarCompra(3, NOW(), 4, 1);

CALL RegistrarCompra(6, NOW(), 5, 1);

CALL RegistrarCompra(5, NOW());

DELETE FROM DetalleCompras;
DELETE FROM Compras;


-- en esta vuelta vamos a ver si los datos se han insertado bien en las tablas
SELECT * FROM Clientes;
SELECT * FROM Compras;
SELECT * FROM DetalleCompras;
SELECT * FROM Productos;

SELECT * FROM Clientes WHERE ID_Cliente = 5;
SELECT * FROM Compras WHERE ID_Cliente = 5;

SELECT * FROM Productos WHERE ID_Producto = 4;
SELECT * FROM Compras WHERE ID_Compra = 5; -- Ajusta el ID según tu inserción.

SELECT * FROM Compras WHERE ID_Cliente = 5 AND ID_Compra = 10;
SELECT ID_Compra FROM Compras WHERE ID_Cliente = 5;




























