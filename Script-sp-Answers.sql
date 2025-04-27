-- Insertar una nueva respuesta
DELIMITER //
CREATE PROCEDURE procInsertAnswer(
    IN v_res_respuesta ENUM('Sí', 'No'),  -- Respuesta (Sí o No)
    IN v_en_id INT,                       -- ID de la encuesta
    IN v_usu_id INT                       -- ID del usuario que responde
)
BEGIN
    -- Verificar si el usuario ya ha respondido esta encuesta
    DECLARE respuesta_existente INT;
    SELECT COUNT(*) INTO respuesta_existente
    FROM tbl_respuestas
    WHERE tbl_encuesta_en_id = v_en_id
      AND tbl_usuarios_usu_id = v_usu_id;

    -- Si no existe una respuesta previa, se inserta la nueva respuesta
    IF respuesta_existente = 0 THEN
        INSERT INTO tbl_respuestas (
            res_respuesta, 
            tbl_usuarios_usu_id,
            tbl_encuesta_en_id
        ) 
        VALUES (
            v_res_respuesta, 
            v_usu_id,
            v_en_id
        );
    ELSE
        -- Si ya existe, se lanza un error
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'El usuario ya ha respondido esta encuesta.';
    END IF;
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
        r.res_respuesta,               -- Respuesta (Sí o No)
        CONCAT(u.usu_nombre, ' ', u.usu_apellido) AS nombre_usuario  -- Nombre completo del usuario
    FROM tbl_respuestas r
    INNER JOIN tbl_encuesta e ON r.tbl_encuesta_en_id = e.en_id 
    INNER JOIN tbl_usuarios u ON r.tbl_usuarios_usu_id = u.usu_id
    ORDER BY  r.res_id DESC;
END//
DELIMITER ;

-- Actualizar una respuesta
DELIMITER //
CREATE PROCEDURE procUpdateAnswer(
    IN v_res_id INT,                  -- ID de la respuesta
    IN v_en_id INT,                   -- ID de la encuesta
    IN v_usu_id INT,                  -- ID del usuario relacionado
    IN v_res_respuesta ENUM('Sí', 'No')  -- Nueva respuesta (Sí o No)
)
BEGIN
    -- Verifica si la respuesta existe antes de actualizar
    IF EXISTS (
        SELECT 1 
        FROM tbl_respuestas 
        WHERE res_id = v_res_id 
          AND tbl_encuesta_en_id = v_en_id
          AND tbl_usuarios_usu_id = v_usu_id
    ) THEN
        -- Actualiza la respuesta
        UPDATE tbl_respuestas 
        SET 
            res_respuesta = v_res_respuesta
        WHERE res_id = v_res_id 
          AND tbl_encuesta_en_id = v_en_id
          AND tbl_usuarios_usu_id = v_usu_id;
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
      AND tbl_usuarios_usu_id = v_usu_id;
END//
DELIMITER ;

-- ID del usuario del cual se desean obtener las respuestas
DELIMITER //
CREATE PROCEDURE procSelectAnswerByUser(
    IN p_user_id INT  -- ID del usuario
)
BEGIN
    -- Selecciona las respuestas dadas por el usuario
    SELECT 
        r.res_id,                      -- ID de la respuesta
        r.tbl_encuesta_en_id,          -- ID de la encuesta
        e.en_descripcion_pregunta,     -- Pregunta de la encuesta
        r.res_respuesta,               -- Respuesta (Sí o No)
        CONCAT(u.usu_nombre, ' ', u.usu_apellido) AS nombre_usuario  -- Nombre completo del usuario
    FROM tbl_respuestas r
    INNER JOIN tbl_encuesta e ON r.tbl_encuesta_en_id = e.en_id
    INNER JOIN tbl_usuarios u ON r.tbl_usuarios_usu_id = u.usu_id
    WHERE r.tbl_usuarios_usu_id = p_user_id
    ORDER BY  r.res_id DESC;
END//
DELIMITER ;

-- ID del usuario del cual se desean obtener las preguntas no respondidas.
DELIMITER //
CREATE PROCEDURE procGetUnansweredQuestionsByUser(
    IN v_usu_id INT  -- ID del usuario
)
BEGIN
    -- Selecciona las preguntas no respondidas por el usuario
    SELECT 
        e.en_id,                      -- ID de la encuesta
        e.en_descripcion_pregunta     -- Pregunta de la encuesta
    FROM tbl_encuesta e
    WHERE e.en_id NOT IN (
        SELECT r.tbl_encuesta_en_id 
        FROM tbl_respuestas r
        WHERE r.tbl_usuarios_usu_id = v_usu_id
    )
    ORDER BY e.en_descripcion_pregunta ASC;
END//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE procSelectUnansweredQuestionsByUser(IN v_usu_id INT)
BEGIN
    -- Retorna preguntas no respondidas o un mensaje si no hay
    IF EXISTS (SELECT 1 FROM tbl_encuesta) THEN
        SELECT 
            e.en_id, 
            e.en_descripcion_pregunta
        FROM tbl_encuesta e
        LEFT JOIN tbl_respuestas r 
            ON e.en_id = r.tbl_encuesta_en_id AND r.tbl_usuarios_usu_id = v_usu_id
        WHERE r.res_id IS NULL;
    ELSE
        -- Retorna una fila con valores nulos si no hay preguntas
        SELECT NULL AS en_id, 'No hay preguntas en el sistema' AS en_descripcion_pregunta;
    END IF;
END//
DELIMITER ;


-- conteo de respuestas "Sí" y "No" para una pregunta específica
DELIMITER //
CREATE PROCEDURE procCountAnswersByQuestion(
    IN p_en_id INT
)
BEGIN
    -- Verificar si la pregunta existe
    IF NOT EXISTS (SELECT 1 FROM tbl_encuesta WHERE en_id = p_en_id) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'La pregunta especificada no existe.';
    ELSE
        -- Mostrar el conteo de respuestas
        SELECT 
            e.en_id AS 'ID Pregunta',
            e.en_descripcion_pregunta AS 'Pregunta',
            SUM(CASE WHEN r.res_respuesta = 'Sí' THEN 1 ELSE 0 END) AS 'Total Sí',
            SUM(CASE WHEN r.res_respuesta = 'No' THEN 1 ELSE 0 END) AS 'Total No',
            COUNT(r.res_id) AS 'Total Respuestas',
            CASE WHEN COUNT(r.res_id) > 0 
                 THEN ROUND(SUM(CASE WHEN r.res_respuesta = 'Sí' THEN 1 ELSE 0 END) * 100.0 / COUNT(r.res_id), 2)
                 ELSE 0 END AS 'Porcentaje Sí',
            CASE WHEN COUNT(r.res_id) > 0 
                 THEN ROUND(SUM(CASE WHEN r.res_respuesta = 'No' THEN 1 ELSE 0 END) * 100.0 / COUNT(r.res_id), 2)
                 ELSE 0 END AS 'Porcentaje No'
        FROM tbl_encuesta e
        LEFT JOIN tbl_respuestas r ON e.en_id = r.tbl_encuesta_en_id
        WHERE e.en_id = p_en_id
        GROUP BY e.en_id, e.en_descripcion_pregunta;
    END IF;
END //
DELIMITER ;

-- Procedimiento específico para listar encuestas 
DELIMITER //
CREATE PROCEDURE procGetAllSurveyQuestions()
BEGIN
    SELECT 
        en_id AS question_id,
        en_descripcion_pregunta AS question_text
    FROM tbl_encuesta
    ORDER BY en_id DESC;
END //
DELIMITER ;