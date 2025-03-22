-- Procedimientos almacenados para tbl_editorial
-- Insertar
DELIMITER // 
CREATE PROCEDURE procInsertEditorial(
    IN v_nombre VARCHAR(45),
    IN v_ciudad VARCHAR(25), 
    IN v_telefono INT,
    IN v_correo VARCHAR(80)
)
BEGIN 
    INSERT INTO tbl_editorial (edi_nombre, edi_ciudad, edi_telefono, edi_correo) 
    VALUES (v_nombre, v_ciudad, v_telefono, v_correo);
END//
DELIMITER ;

-- Mostrar
DELIMITER //
CREATE PROCEDURE procSelectEditorial()
BEGIN
    SELECT edi_id, edi_nombre, edi_ciudad, edi_telefono, edi_correo 
    FROM tbl_editorial;
END//
DELIMITER ;

-- Mostrar DDL (ID y Nombre Editorial)
DELIMITER //
CREATE PROCEDURE procSelectEditorialDDL()
BEGIN
    SELECT edi_id, edi_nombre  
    FROM tbl_editorial;
END//
DELIMITER ;

-- Actualizar
DELIMITER // 
CREATE PROCEDURE procUpdateEditorial(
    IN v_id INT, 
    IN v_nombre VARCHAR(45),
    IN v_ciudad VARCHAR(25), 
    IN v_telefono INT,
    IN v_correo VARCHAR(80)
)
BEGIN
    UPDATE tbl_editorial
    SET edi_nombre = v_nombre, 
        edi_ciudad = v_ciudad, 
        edi_telefono = v_telefono, 
        edi_correo = v_correo
    WHERE edi_id = v_id;
END//
DELIMITER ;

-- Eliminar
DELIMITER // 
CREATE PROCEDURE procDeleteEditorial(
    IN v_id INT
)
BEGIN
    DELETE FROM tbl_editorial 
    WHERE edi_id = v_id;
END//
DELIMITER ;
