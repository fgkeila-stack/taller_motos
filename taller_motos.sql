DROP DATABASE IF EXISTS taller_motos;

CREATE DATABASE taller_motos;

USE taller_motos;

CREATE TABLE contadores(
	id_contador INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
	cantidad_clientes INT,
	cantidad_motos INT,
	cantidad_mecanicos INT,
	cantidad_ordenes INT
);

INSERT INTO contadores(cantidad_clientes, cantidad_motos, cantidad_mecanicos, cantidad_ordenes) VALUES
(0,0,0,0);

CREATE TABLE clientes(
	id_cliente INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
	nombre VARCHAR(25),
	apellido VARCHAR(25),
	telefono VARCHAR(15),
	email VARCHAR(40),
	direccion VARCHAR(50)
);

CREATE TABLE motos(
	id_moto INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
	marca VARCHAR(20),
	modelo VARCHAR(20),
	anio VARCHAR(4),
	cilindrada VARCHAR(10)
);

CREATE TABLE especialidades(
	id_especialidad INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
	especialidad VARCHAR(30)
);

CREATE TABLE estados(
	id_estado INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
	estado VARCHAR(25)
);

CREATE TABLE servicios(
	id_servicio INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
	servicio VARCHAR(40)
);

CREATE TABLE mecanicos(
	id_mecanico INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
	nombre VARCHAR(25),
	apellido VARCHAR(25),
	telefono VARCHAR(15),
	id_especialidad INT,
	FOREIGN KEY (id_especialidad) REFERENCES especialidades(id_especialidad)
);

CREATE TABLE ordenes(
	id_orden INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
	fecha_ingreso DATETIME,
	fecha_egreso DATETIME,
	kilometraje DECIMAL(8,2),
	observaciones VARCHAR(30),
	id_servicio INT,
	id_cliente INT,
	id_moto INT,
	id_mecanico INT,
	id_estado INT,
	FOREIGN KEY (id_servicio) REFERENCES servicios(id_servicio),
	FOREIGN KEY (id_cliente) REFERENCES clientes(id_cliente),
	FOREIGN KEY (id_moto) REFERENCES motos(id_moto),
	FOREIGN KEY (id_mecanico) REFERENCES mecanicos(id_mecanico),
	FOREIGN KEY (id_estado) REFERENCES estados(id_estado)
);

DELIMITER //
CREATE OR REPLACE TRIGGER tg_contador_clientes
AFTER INSERT ON clientes
FOR EACH ROW
BEGIN
	UPDATE contadores
	SET cantidad_clientes = cantidad_clientes + 1
	WHERE id_contador = 1;
END //
DELIMITER ;

DELIMITER //
CREATE OR REPLACE TRIGGER tg_contador_motos
AFTER INSERT ON motos
FOR EACH ROW
BEGIN
	UPDATE contadores
	SET cantidad_motos = cantidad_motos + 1
	WHERE id_contador = 1;
END //
DELIMITER ;

DELIMITER //
CREATE OR REPLACE TRIGGER tg_contador_mecanicos
AFTER INSERT ON mecanicos
FOR EACH ROW
BEGIN
	UPDATE contadores
	SET cantidad_mecanicos = cantidad_mecanicos + 1
	WHERE id_contador = 1;
END //
DELIMITER ;

DELIMITER //
CREATE OR REPLACE TRIGGER tg_contador_ordenes
AFTER INSERT ON ordenes
FOR EACH ROW
BEGIN
	UPDATE contadores
	SET cantidad_ordenes = cantidad_ordenes + 1
	WHERE id_contador = 1;
END //
DELIMITER ;

DELIMITER //
CREATE OR REPLACE TRIGGER tg_ordenes_egreso
BEFORE UPDATE ON ordenes
FOR EACH ROW
BEGIN
	IF NEW.id_estado = 5 AND NEW.fecha_egreso IS NULL THEN
		SET NEW.fecha_egreso = NOW();
	END IF;
END //
DELIMITER ;

INSERT INTO especialidades (especialidad) VALUES
('Motor y Transmisión'),
('Sistema Eléctrico'),
('Suspensión y Frenos'),
('Inyección Electrónica'),
('Neumáticos y Balanceo'),
('Chapa y Pintura');

INSERT INTO estados (estado) VALUES
('Pendiente'),
('En Proceso'),
('Esperando Repuestos'),
('Finalizado'),
('Entregado');

INSERT INTO servicios (servicio) VALUES
('Service General'),
('Cambio de Pastillas de Freno'),
('Reparación de Sistema Eléctrico'),
('Cambio de Kit de Transmisión'),
('Limpieza de Inyectores'),
('Cambio de Neumáticos'),
('Alineación y Balanceo'),
('Reparación de Motor'),
('Cambio de Aceite y Filtros'),
('Regulación de Válvulas');

INSERT INTO clientes (nombre, apellido, telefono, email, direccion) VALUES
('Marcos', 'Villalba', '1155443322', 'marcos.villalba@gmail.com', 'Av. Rivadavia 4500'),
('Camila', 'Duarte', '1144332211', 'camila.duarte@hotmail.com', 'Calle Lavalle 820'),
('Gonzalo', 'Ibarra', '1177885544', 'gonzalo.ibarra@gmail.com', 'Av. Corrientes 3300'),
('Lucía', 'Peralta', '1144556677', 'lucia.peralta@gmail.com', 'Calle Mitre 150'),
('Tomás', 'Quiroga', '1188776655', 'tomas.quiroga@yahoo.com', 'Pasaje Los Andes 45'),
('Florencia', 'Sosa', '1133445566', 'flor.sosa@gmail.com', 'Av. San Martín 1200'),
('Nicolás', 'Ferreyra', '1133221100', 'nico.ferreyra@outlook.com', 'Calle Belgrano 987'),
('Agustina', 'Maidana', '1188990011', 'agus.maidana@gmail.com', 'Av. Directorio 2100'),
('Ramiro', 'Acosta', '1100112233', 'ramiro.acosta@gmail.com', 'Calle Moreno 610'),
('Valeria', 'Núñez', '1166554433', 'valeria.nunez@gmail.com', 'Pasaje Sarmiento 77');

INSERT INTO motos (marca, modelo, anio, cilindrada) VALUES
('Yamaha', 'FZ 25', '2022', '250cc'),
('Honda', 'Twister CB250', '2021', '250cc'),
('Kawasaki', 'Ninja 400', '2023', '400cc'),
('Suzuki', 'AX 100', '2020', '100cc'),
('Bajaj', 'Dominar 400', '2023', '400cc'),
('KTM', 'Duke 200', '2022', '200cc'),
('Yamaha', 'R3', '2021', '321cc'),
('Honda', 'Wave 110', '2023', '110cc'),
('Benelli', 'TNT 300', '2020', '300cc'),
('Zanella', 'RZ 25', '2022', '250cc'),
('Royal Enfield', 'Himalayan 411', '2022', '411cc'),
('Honda', 'XR 150L', '2020', '150cc');

INSERT INTO mecanicos (nombre, apellido, telefono, id_especialidad) VALUES
('Ernesto', 'Palanca', '1122112233', 1),
('Pablo', 'Voltaje', '1133445566', 2),
('Gustavo', 'Amortiguador', '1155667788', 3),
('Ariel', 'Inyector', '1199001122', 4),
('Axel', 'Cubierta', '1177889900', 5),
('Patricio', 'Pintura', '1144225566', 6),
('Damián', 'Pistón', '1166332244', 1),
('Alberto', 'Cables', '1188442211', 2);

INSERT INTO ordenes (fecha_ingreso, fecha_egreso, kilometraje, observaciones, id_servicio, id_cliente, id_moto, id_mecanico, id_estado) VALUES
('2026-09-01 09:30:00', '2026-09-02 17:00:00', 15000, 'Ruido al acelerar', 1, 1, 1, 1, 5),
('2026-09-03 10:15:00', NULL, 8500.50, 'Frena con dificultad', 2, 2, 2, 3, 2),
('2026-09-04 08:00:00', NULL, 22000, 'Falla el tablero electrico', 3, 3, 3, 2, 1),
('2026-09-05 11:00:00', '2026-09-05 15:30:00', 5000, 'Alineacion tras caida', 7, 4, 4, 5, 5),
('2026-09-06 09:00:00', NULL, 12000, 'Tironea en bajas vueltas', 5, 5, 5, 4, 3),
('2026-09-07 14:20:00', NULL, 18000, 'Cambio de cubierta trasera', 6, 6, 6, 5, 4),
('2026-09-08 16:45:00', NULL, 31000, 'Humo denso por el escape', 8, 7, 7, 7, 2),
('2026-09-09 10:00:00', '2026-09-09 13:00:00', 3500, 'Mantenimiento 3000 km', 9, 8, 8, 7, 5),
('2026-09-10 08:30:00', NULL, 27000, 'Golpeteo en las valvulas', 10, 9, 9, 1, 1),
('2026-09-11 12:10:00', NULL, 14000, 'Cadena muy estirada', 4, 10, 10, 7, 3),
('2026-10-15 09:00:00', NULL, 16200, 'Service de los 15000 km', 1, 1, 1, 1, 2),
('2026-10-20 10:00:00', NULL, 19200, 'Ruido en la horquilla', 2, 3, 11, 3, 1),
('2026-10-22 15:00:00', NULL, 24000, 'Pierde aceite', 9, 3, 12, 7, 1);


DELIMITER //
DROP FUNCTION IF EXISTS fn_ultimo_km_moto //
CREATE FUNCTION fn_ultimo_km_moto(p_id_moto INT)
RETURNS DECIMAL(8,2)
READS SQL DATA
BEGIN
	DECLARE v_km DECIMAL(8,2);

	SELECT MAX(kilometraje) INTO v_km
	FROM ordenes
	WHERE id_moto = p_id_moto;

	RETURN v_km;
END //
DELIMITER ;

DELIMITER //
DROP FUNCTION IF EXISTS fn_cantidad_ordenes_cliente //
CREATE FUNCTION fn_cantidad_ordenes_cliente(p_id_cliente INT)
RETURNS INT
READS SQL DATA
BEGIN
	DECLARE v_total INT;

	SELECT COUNT(*) INTO v_total
	FROM ordenes
	WHERE id_cliente = p_id_cliente;

	RETURN v_total;
END //
DELIMITER ;

DELIMITER //
DROP FUNCTION IF EXISTS fn_ordenes_activas_mecanico //
CREATE FUNCTION fn_ordenes_activas_mecanico(p_id_mecanico INT)
RETURNS INT
READS SQL DATA
BEGIN
	DECLARE v_total INT;

	SELECT COUNT(*) INTO v_total
	FROM ordenes
	WHERE id_mecanico = p_id_mecanico
	AND id_estado IN (1, 2, 3);

	RETURN v_total;
END //
DELIMITER ;

DELIMITER //
DROP FUNCTION IF EXISTS fn_updateCliente //
CREATE FUNCTION fn_updateCliente(
	p_id_cliente INT,
	p_nombre VARCHAR(25),
	p_apellido VARCHAR(25),
	p_telefono VARCHAR(15),
	p_email VARCHAR(40),
	p_direccion VARCHAR(50)
)
RETURNS INT
MODIFIES SQL DATA
BEGIN
	UPDATE clientes
	SET nombre = p_nombre,
	apellido = p_apellido,
	telefono = p_telefono,
	email = p_email,
	direccion = p_direccion
	WHERE id_cliente = p_id_cliente;

	RETURN ROW_COUNT();
END //
DELIMITER ;

CREATE OR REPLACE VIEW vw_ordenes_detalle AS
SELECT
	o.id_orden,
	CONCAT(c.apellido, ', ', c.nombre) AS cliente,
	CONCAT(m.marca, ' ', m.modelo) AS moto,
	s.servicio,
	CONCAT(me.nombre, ' ', me.apellido) AS mecanico,
	e.estado,
	o.fecha_ingreso,
	o.fecha_egreso,
	o.kilometraje,
	o.observaciones
FROM ordenes o
INNER JOIN clientes c ON c.id_cliente = o.id_cliente
INNER JOIN motos m ON m.id_moto = o.id_moto
INNER JOIN servicios s ON s.id_servicio = o.id_servicio
INNER JOIN mecanicos me ON me.id_mecanico = o.id_mecanico
INNER JOIN estados e ON e.id_estado = o.id_estado
ORDER BY o.id_estado, o.fecha_ingreso;

CREATE OR REPLACE VIEW vw_carga_mecanicos AS
SELECT
	CONCAT(me.nombre, ' ', me.apellido) AS mecanico,
	es.especialidad,
	COUNT(o.id_orden) AS ordenes_totales,
	fn_ordenes_activas_mecanico(me.id_mecanico) AS ordenes_activas
FROM mecanicos me
INNER JOIN especialidades es ON es.id_especialidad = me.id_especialidad
LEFT JOIN ordenes o ON o.id_mecanico = me.id_mecanico
GROUP BY me.id_mecanico, me.nombre, me.apellido, es.especialidad;

CREATE OR REPLACE VIEW vw_resumen_clientes AS
SELECT
	CONCAT(c.apellido, ', ', c.nombre) AS cliente,
	c.telefono,
	fn_cantidad_ordenes_cliente(c.id_cliente) AS cantidad_ordenes,
	MAX(o.fecha_ingreso) AS ultima_visita
FROM clientes c
LEFT JOIN ordenes o ON o.id_cliente = c.id_cliente
GROUP BY c.id_cliente, c.apellido, c.nombre, c.telefono;

DELIMITER //
CREATE OR REPLACE PROCEDURE sp_get_cliente(IN p_id_cliente INT)
BEGIN
	SELECT * FROM clientes
	WHERE id_cliente = p_id_cliente;
END //
DELIMITER ;

DELIMITER //
CREATE OR REPLACE PROCEDURE sp_historial_moto(IN p_id_moto INT)
BEGIN
	SELECT
		o.id_orden,
		CONCAT(m.marca, ' ', m.modelo) AS moto,
		CONCAT(c.nombre, ' ', c.apellido) AS propietario,
		s.servicio,
		CONCAT(me.nombre, ' ', me.apellido) AS mecanico,
		e.estado,
		o.kilometraje,
		o.fecha_ingreso,
		o.fecha_egreso
	FROM ordenes o
	INNER JOIN motos m ON m.id_moto = o.id_moto
	INNER JOIN clientes c ON c.id_cliente = o.id_cliente
	INNER JOIN servicios s ON s.id_servicio = o.id_servicio
	INNER JOIN mecanicos me ON me.id_mecanico = o.id_mecanico
	INNER JOIN estados e ON e.id_estado = o.id_estado
	WHERE o.id_moto = p_id_moto
	ORDER BY o.fecha_ingreso DESC;
END //
DELIMITER ;

DELIMITER //
CREATE OR REPLACE PROCEDURE sp_ordenes_por_estado(IN p_id_estado INT)
BEGIN
	SELECT
		o.id_orden,
		CONCAT(c.apellido, ', ', c.nombre) AS cliente,
		CONCAT(m.marca, ' ', m.modelo) AS moto,
		s.servicio,
		o.fecha_ingreso
	FROM ordenes o
	INNER JOIN clientes c ON c.id_cliente = o.id_cliente
	INNER JOIN motos m ON m.id_moto = o.id_moto
	INNER JOIN servicios s ON s.id_servicio = o.id_servicio
	WHERE o.id_estado = p_id_estado
	ORDER BY o.fecha_ingreso;
END //
DELIMITER ;

DELIMITER //
CREATE OR REPLACE PROCEDURE sp_nueva_orden(
	IN p_id_cliente INT,
	IN p_id_moto INT,
	IN p_id_mecanico INT,
	IN p_id_servicio INT,
	IN p_observaciones VARCHAR(30),
	IN p_kilometraje DECIMAL(8,2)
)
BEGIN
	DECLARE v_ultimo_km DECIMAL(8,2);

	SET v_ultimo_km = fn_ultimo_km_moto(p_id_moto);

	IF v_ultimo_km IS NOT NULL AND p_kilometraje < v_ultimo_km THEN
		SELECT 'Error: el kilometraje es menor al ultimo registrado' AS mensaje;
	ELSE
		INSERT INTO ordenes (fecha_ingreso, fecha_egreso, kilometraje, observaciones,
			id_servicio, id_cliente, id_moto, id_mecanico, id_estado)
		VALUES (NOW(), NULL, p_kilometraje, p_observaciones,
			p_id_servicio, p_id_cliente, p_id_moto, p_id_mecanico, 1);

		SELECT 'Orden creada' AS mensaje;
	END IF;
END //
DELIMITER ;

DELIMITER //
CREATE OR REPLACE PROCEDURE sp_cambiar_estado_orden(
	IN p_id_orden INT,
	IN p_nuevo_estado INT
)
BEGIN
	DECLARE v_estado_actual INT;

	SELECT id_estado INTO v_estado_actual
	FROM ordenes
	WHERE id_orden = p_id_orden;

	IF v_estado_actual IS NULL THEN
		SELECT 'Error: la orden no existe' AS mensaje;
	ELSEIF v_estado_actual = 5 THEN
		SELECT 'Error: la orden ya fue entregada' AS mensaje;
	ELSE
		UPDATE ordenes
		SET id_estado = p_nuevo_estado
		WHERE id_orden = p_id_orden;

		SELECT 'Estado actualizado' AS mensaje;
	END IF;
END //
DELIMITER ;

SELECT * FROM contadores;

SELECT * FROM vw_ordenes_detalle;
SELECT * FROM vw_carga_mecanicos;
SELECT * FROM vw_resumen_clientes;

SELECT fn_ultimo_km_moto(1) AS ultimo_km;
SELECT fn_cantidad_ordenes_cliente(3) AS ordenes_cliente_3;
SELECT fn_ordenes_activas_mecanico(7) AS activas_mecanico_7;
SELECT fn_updateCliente(1, 'Marcos', 'Villalba', '1155443399', 'marcos.villalba@gmail.com', 'Av. Rivadavia 4500') AS filas_modificadas;

CALL sp_get_cliente(2);
CALL sp_historial_moto(1);
CALL sp_ordenes_por_estado(1);

CALL sp_nueva_orden(2, 2, 4, 5, 'Se apaga en semaforo', 9000);  
CALL sp_nueva_orden(2, 2, 4, 5, 'Km menor al anterior', 100);  
CALL sp_cambiar_estado_orden(2, 5); 
CALL sp_cambiar_estado_orden(2, 1);
SELECT id_orden, id_estado, fecha_egreso FROM ordenes WHERE id_orden = 2;
