-- Insertar una nueva respuesta
DELIMITER //
CREATE PROCEDURE procInsertAnswer(
    IN v_res_respuesta TEXT,          -- Respuesta (texto libre)
    IN v_en_id INT,                   -- ID de la encuesta
    IN v_usu_id INT                   -- ID del usuario que responde
)
BEGIN
    -- Inserta la respuesta
    INSERT INTO tbl_respuestas (
        res_respuesta, 
        tbl_encuesta_en_id,
        tbl_encuesta_tbl_usuarios_usu_id
    ) 
    VALUES (
        v_res_respuesta, 
        v_en_id,
        v_usu_id
    );
END//
DELIMITER ;

-- Mostrar todas las respuestas
DELIMITER //
CREATE PROCEDURE procSelectAnswer()
BEGIN
    SELECT 
        r.res_id,                      -- ID de la respuesta
        r.tbl_encuesta_en_id,          -- ID de la encuesta
        e.en_descripcion_pregunta,     -- Pregunta de la encuesta
        r.res_respuesta,               -- Respuesta (texto libre)
        CONCAT(u.usu_nombre, ' ', u.usu_apellido) AS nombre_usuario  -- Nombre completo del usuario
    FROM tbl_respuestas r
    INNER JOIN tbl_encuesta e ON r.tbl_encuesta_en_id = e.en_id 
    INNER JOIN tbl_usuarios u ON r.tbl_encuesta_tbl_usuarios_usu_id = u.usu_id
    ORDER BY e.en_descripcion_pregunta, r.res_id ASC;
END//
DELIMITER ;

-- Actualizar una respuesta
DELIMITER //
CREATE PROCEDURE procUpdateAnswer(
    IN v_res_id INT,                  -- ID de la respuesta
    IN v_en_id INT,                   -- ID de la encuesta
    IN v_usu_id INT,                  -- ID del usuario relacionado
    IN v_res_respuesta TEXT           -- Nueva respuesta (texto libre)
)
BEGIN
    -- Verifica si la respuesta existe antes de actualizar
    IF EXISTS (
        SELECT 1 
        FROM tbl_respuestas 
        WHERE res_id = v_res_id 
          AND tbl_encuesta_en_id = v_en_id
          AND tbl_encuesta_tbl_usuarios_usu_id = v_usu_id
    ) THEN
        -- Actualiza la respuesta
        UPDATE tbl_respuestas 
        SET 
            res_respuesta = v_res_respuesta
        WHERE res_id = v_res_id 
          AND tbl_encuesta_en_id = v_en_id
          AND tbl_encuesta_tbl_usuarios_usu_id = v_usu_id;
    ELSE
        -- Si no existe, lanza un error
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'No se encontró la respuesta para actualizar. Verifica los IDs proporcionados.';
    END IF;
END//
DELIMITER ;


-- Eliminar una respuesta
DELIMITER //
CREATE PROCEDURE procDeleteAnswer(
    IN v_res_id INT,                  -- ID de la respuesta
    IN v_en_id INT,                   -- ID de la encuesta
    IN v_usu_id INT                   -- ID del usuario relacionado
)
BEGIN 
    -- Elimina la respuesta
    DELETE FROM tbl_respuestas 
    WHERE res_id = v_res_id 
      AND tbl_encuesta_en_id = v_en_id
      AND tbl_encuesta_tbl_usuarios_usu_id = v_usu_id;
END//
DELIMITER ;