-- Insertar una nueva visita
DELIMITER //
CREATE PROCEDURE procInsertVisits(
    IN v_fecha_ingreso DATE, 
    IN v_duracion TIME, 
    IN v_dispositivo ENUM('Computadora', 'Móvil', 'Tableta', 'Otro'),
    IN v_usu_id INT,
    IN v_mat_id INT
)
BEGIN 
    INSERT INTO tbl_visitas(
        vis_fecha_ingreso, 
        vis_duracion, 
        vis_dispositivo, 
        tbl_usuarios_usu_id,
        tbl_material_edu_mat_id
    )
    VALUES (
        v_fecha_ingreso, 
        v_duracion, 
        v_dispositivo, 
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
        v.vis_dispositivo,
        CONCAT(u.usu_nombre, ' ', u.usu_apellido) AS usuario_nombre,
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
    IN v_dispositivo ENUM('Computadora', 'Móvil', 'Tableta', 'Otro'),
    IN v_usu_id INT,
    IN v_mat_id INT
) 
BEGIN 
    UPDATE tbl_visitas 
    SET  
        vis_fecha_ingreso = v_fecha_ingreso, 
        vis_duracion = v_duracion,
        vis_dispositivo = v_dispositivo,
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
CREATE PROCEDURE procSelectVisitsByUser(
    IN v_user_id INT
)
BEGIN
    SELECT 
        v.vis_id,
        v.vis_fecha_ingreso,
        v.vis_duracion,
        v.vis_dispositivo,
        CONCAT(u.usu_nombre, ' ', u.usu_apellido) AS usuario_nombre,
        m.mat_titulo AS material_titulo
    FROM tbl_visitas v
    INNER JOIN tbl_usuarios u ON v.tbl_usuarios_usu_id = u.usu_id
    INNER JOIN tbl_material_edu m ON v.tbl_material_edu_mat_id = m.mat_id
    WHERE v.tbl_usuarios_usu_id = v_user_id;
END//
DELIMITER ;

