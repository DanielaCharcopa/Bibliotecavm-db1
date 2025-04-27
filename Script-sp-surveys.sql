-- Insertar una nueva encuesta
DELIMITER //
CREATE PROCEDURE procInsertSurvey(
    IN v_descripcion_pregunta TEXT, 
    IN v_usu_id INT 
)
BEGIN
   
    INSERT INTO tbl_encuesta (
        en_descripcion_pregunta, 
        tbl_usuarios_usu_id
    ) VALUES (
        v_descripcion_pregunta, 
        v_usu_id
    );
END//
DELIMITER ;

-- Mostrar todas las encuestas
DELIMITER //
CREATE PROCEDURE procSelectSurvey()
BEGIN
    SELECT 
        en_id, 
        en_descripcion_pregunta, 
        tbl_usuarios_usu_id
    FROM tbl_encuesta
    ORDER BY en_id DESC;
END//
DELIMITER ;

-- Mostrar encuestas con el nombre completo del usuario (para DDL)
DELIMITER //
CREATE PROCEDURE procSelectSurveyDDL()
BEGIN
    SELECT 
        e.en_id, 
        e.en_descripcion_pregunta, 
        e.tbl_usuarios_usu_id, 
        CONCAT(u.usu_nombre, ' ', u.usu_apellido) AS nombre_completo
    FROM tbl_encuesta e
    -- Unir con la tabla tbl_usuarios para obtener el nombre completo
    JOIN tbl_usuarios u ON e.tbl_usuarios_usu_id = u.usu_id
    ORDER BY en_id DESC;
    END//
DELIMITER ;

-- Actualizar una encuesta
DELIMITER //
CREATE PROCEDURE procUpdateSurvey(
    IN v_en_id INT, 
    IN v_descripcion_pregunta TEXT, 
    IN v_usu_id INT 
)
BEGIN
    -- Actualizar la encuesta con los nuevos datos
    UPDATE tbl_encuesta 
    SET 
        en_descripcion_pregunta = v_descripcion_pregunta,
        tbl_usuarios_usu_id = v_usu_id
    WHERE 
        en_id = v_en_id;
END//
DELIMITER ;



-- -- Eliminar una encuesta

DELIMITER //
CREATE PROCEDURE procDeleteSurvey (
    IN v_en_id INT
)
BEGIN
    DECLARE v_exists INT DEFAULT 0;
    -- Verificar si la encuesta existe
    SELECT COUNT(*) INTO v_exists
    FROM tbl_encuesta
    WHERE en_id = v_en_id;

    IF v_exists = 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'La encuesta no existe';
    ELSE
        -- Eliminar las respuestas relacionadas
        DELETE FROM tbl_respuestas
        WHERE tbl_encuesta_en_id = v_en_id;
        -- Eliminar la encuesta
        DELETE FROM tbl_encuesta
        WHERE en_id = v_en_id;
    END IF;
END //
DELIMITER ;

