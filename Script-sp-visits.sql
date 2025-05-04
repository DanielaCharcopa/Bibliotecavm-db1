-- Insertar una nueva visita
DELIMITER //
CREATE PROCEDURE procInsertVisits(
    IN v_fecha_ingreso DATE, 
    IN v_duracion TIME, 
    IN v_usu_id INT,
    IN v_mat_id INT
)
BEGIN 
    INSERT INTO tbl_visitas(
        vis_fecha_ingreso, 
        vis_duracion, 
        tbl_usuarios_usu_id,
        tbl_material_edu_mat_id
    )
    VALUES (
        v_fecha_ingreso, 
        v_duracion, 
        v_usu_id,
        v_mat_id
    ); 
END //
DELIMITER ;

-- Mostrar todas las visitas
DELIMITER //
CREATE PROCEDURE procSelectVisits() 
BEGIN 
    SELECT 
        v.vis_id, 
        v.vis_fecha_ingreso, 
        v.vis_duracion, 
        CONCAT(u.usu_nombre, ' ', u.usu_apellido) AS usuario_nombre,
        u.usu_correo AS usuario_correo,
        m.mat_titulo AS material_titulo
    FROM tbl_visitas v
    INNER JOIN tbl_usuarios u ON v.tbl_usuarios_usu_id = u.usu_id
    INNER JOIN tbl_material_edu m ON v.tbl_material_edu_mat_id = m.mat_id; 
END //
DELIMITER ;

-- Actualizar una visita
DELIMITER // 
CREATE PROCEDURE procUpdateVisits( 
    IN v_vis_id INT,  
    IN v_fecha_ingreso DATE, 
    IN v_duracion TIME, 
    IN v_usu_id INT,
    IN v_mat_id INT
) 
BEGIN 
    UPDATE tbl_visitas 
    SET  
        vis_fecha_ingreso = v_fecha_ingreso, 
        vis_duracion = v_duracion,
        tbl_usuarios_usu_id = v_usu_id,
        tbl_material_edu_mat_id = v_mat_id
    WHERE vis_id = v_vis_id;
END //
DELIMITER ;

-- Eliminar una visita
DELIMITER // 
CREATE PROCEDURE procDeleteVisits( 
    IN v_vis_id INT
) 
BEGIN  
    DELETE FROM tbl_visitas
    WHERE vis_id = v_vis_id;
END //
DELIMITER ;

--  Contador de visitas
DELIMITER //
CREATE PROCEDURE procCountVisits()
BEGIN
    SELECT COUNT(*) AS total_visitas
    FROM tbl_visitas;
END //
DELIMITER ;

-- Contador de visitas por docente
DELIMITER //
CREATE PROCEDURE procCountVisitsByTeacher()
BEGIN
    SELECT COUNT(*) AS total_visitas_docente
    FROM tbl_visitas v
    INNER JOIN tbl_usuarios u ON v.tbl_usuarios_usu_id = u.usu_id
    WHERE u.usu_rol = 'Docente';
END //
DELIMITER ;

-- Contador de visitas por estudiante
DELIMITER //
CREATE PROCEDURE procCountVisitsByStudent()
BEGIN
    SELECT COUNT(*) AS total_visitas_estudiante
    FROM tbl_visitas v
    INNER JOIN tbl_usuarios u ON v.tbl_usuarios_usu_id = u.usu_id
    WHERE u.usu_rol = 'Estudiante';
END //
DELIMITER ;

-- Estadísticas de materiales y visitas
DELIMITER //
CREATE PROCEDURE procGetMaterialAndVisitStats()
BEGIN
    -- Contador de materiales registrados
    SELECT COUNT(*) AS total_materiales FROM tbl_material_edu;

    -- Contador total de visitas
    SELECT COUNT(*) AS total_visitas FROM tbl_visitas;

    -- Contador de visitas por docente
    SELECT COUNT(*) AS total_visitas_docente
    FROM tbl_visitas v
    INNER JOIN tbl_usuarios u ON v.tbl_usuarios_usu_id = u.usu_id
    WHERE u.usu_rol = 'Docente';

    -- Contador de visitas por estudiante
    SELECT COUNT(*) AS total_visitas_estudiante
    FROM tbl_visitas v
    INNER JOIN tbl_usuarios u ON v.tbl_usuarios_usu_id = u.usu_id
    WHERE u.usu_rol = 'Estudiante';
END //
DELIMITER ;

-- Material más visitado
DELIMITER //
CREATE PROCEDURE procGetMostVisitedMaterials()
BEGIN
    SELECT 
        m.mat_id,
        m.mat_titulo,
        COUNT(v.vis_id) AS total_visitas
    FROM tbl_material_edu m
    INNER JOIN tbl_visitas v ON m.mat_id = v.tbl_material_edu_mat_id
    GROUP BY m.mat_id, m.mat_titulo
    ORDER BY total_visitas DESC
    LIMIT 5; -- Opcional, para mostrar los 5 más visitados
END //
DELIMITER ;

-- Visitas por usuario logueado
DELIMITER //
CREATE PROCEDURE procSelectVisitsByUser(IN v_user_id INT)
BEGIN
    SELECT 
        v.vis_id, 
        v.vis_fecha_ingreso, 
        v.vis_duracion, 
        m.mat_titulo AS mat_titulo
    FROM tbl_visitas v
    INNER JOIN tbl_material_edu m ON v.tbl_material_edu_mat_id = m.mat_id
    WHERE v.tbl_usuarios_usu_id = v_user_id;
END //
DELIMITER ;

--  Crear el procedimiento almacenado para listar materiales educativos
DELIMITER //
CREATE PROCEDURE procListarMaterialesEducativos()
BEGIN
    SELECT 
        mat_id AS id,
        mat_titulo AS titulo
    FROM tbl_material_edu;
END //
DELIMITER ;

-- buscar visitas por correo electrónico
DELIMITER //
CREATE PROCEDURE procSearchUserVisitsByEmail(IN p_email VARCHAR(80))
BEGIN
    SELECT 
        v.vis_id AS visit_id,
        CONCAT(u.usu_nombre, ' ', u.usu_apellido) AS usuario_nombre,
        u.usu_correo AS email,
        v.vis_fecha_ingreso AS visit_date,
        v.vis_duracion AS visit_duration,  
        v.tbl_material_edu_mat_id AS material_id,
        m.mat_titulo AS material_name
    FROM tbl_visitas v
    JOIN tbl_usuarios u ON v.tbl_usuarios_usu_id = u.usu_id
    JOIN tbl_material_edu m ON v.tbl_material_edu_mat_id = m.mat_id
    WHERE u.usu_correo LIKE CONCAT('%', p_email, '%')
    ORDER BY v.vis_fecha_ingreso DESC;
END//
DELIMITER ;

-- filtro para buscar por rango de fecha
DELIMITER //
CREATE PROCEDURE procSearchVisitsByDateRange(
    IN p_email VARCHAR(80),
    IN p_fecha_inicio DATE,
    IN p_fecha_fin DATE
)
BEGIN
    -- Validación de rango de fechas
    IF (p_fecha_inicio IS NOT NULL AND p_fecha_fin IS NOT NULL AND p_fecha_inicio > p_fecha_fin) THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Error: La fecha de inicio no puede ser mayor a la fecha fin';
    END IF;
    SELECT 
        v.vis_id AS visit_id,
        u.usu_correo AS email,
        v.vis_fecha_ingreso AS visit_date,
        v.tbl_material_edu_mat_id AS material_id,
        m.mat_titulo AS material_name,
        v.vis_duracion AS duration
    FROM tbl_visitas v
    JOIN tbl_usuarios u ON v.tbl_usuarios_usu_id = u.usu_id
    JOIN tbl_material_edu m ON v.tbl_material_edu_mat_id = m.mat_id
    WHERE (p_email IS NULL OR u.usu_correo LIKE CONCAT('%', p_email, '%'))
      AND (p_fecha_inicio IS NULL OR v.vis_fecha_ingreso >= p_fecha_inicio)
      AND (p_fecha_fin IS NULL OR v.vis_fecha_ingreso <= p_fecha_fin)
    ORDER BY v.vis_fecha_ingreso DESC;
END//
DELIMITER ;

--  Actualizar la duración de la visita, para ver el tiempo de visita.
DELIMITER //
CREATE PROCEDURE procActualizarDuracionVisita(
    IN v_visita_id INT,
    IN v_duracion VARCHAR(8) -- Cambiar de TIME a VARCHAR
)
BEGIN
    -- Conversión explícita a TIME
    UPDATE tbl_visitas 
    SET vis_duracion = CAST(v_duracion AS TIME)
    WHERE vis_id = v_visita_id;
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE procObtenerUltimaVisitaId(
    IN v_usu_id INT,
    IN v_mat_id INT
)
BEGIN
    SELECT vis_id
    FROM tbl_visitas
    WHERE tbl_usuarios_usu_id = v_usu_id
      AND tbl_material_edu_mat_id = v_mat_id
    ORDER BY vis_fecha_ingreso DESC
    LIMIT 1;
END //
DELIMITER ;
