-- 1. Procedimiento para Insertar un Nuevo Usuario
DELIMITER //
CREATE PROCEDURE procInsertUsers(
    IN v_nombre VARCHAR(50),
    IN v_apellido VARCHAR(50),
    IN v_correo VARCHAR(80),
    IN v_contrasena TEXT, 
    IN v_salt TEXT,
    IN v_rol ENUM('Administrador', 'Docente', 'Estudiante')
)
BEGIN
    DECLARE user_count INT;
    DECLARE final_rol ENUM('Administrador', 'Docente', 'Estudiante');
    
    -- Verificar si el correo ya existe  
    IF EXISTS (SELECT 1 FROM tbl_usuarios WHERE usu_correo = v_correo) THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'El correo electrónico ya está registrado.';
    END IF;
    
    -- Contar usuarios existentes solo una vez
    SELECT COUNT(*) INTO user_count FROM tbl_usuarios;
    
    -- Determinar el rol final
    IF user_count = 0 THEN
        SET final_rol = 'Administrador'; -- Primer usuario siempre es Administrador
    ELSE
        SET final_rol = v_rol; -- Para los demás, usar el rol especificado
    END IF;
    
    -- Insertar nuevo usuario
    INSERT INTO tbl_usuarios(
        usu_nombre, 
        usu_apellido, 
        usu_correo, 
        usu_contrasena, 
        usu_salt, 
        usu_rol,
        usu_estado,
        usu_fecha_creacion,
        usu_fecha_ultima_modificacion
    ) 
    VALUES (
        v_nombre, 
        v_apellido, 
        v_correo, 
        v_contrasena, 
        v_salt, 
        final_rol,
        'Activo',
        CURRENT_TIMESTAMP,
        CURRENT_TIMESTAMP
    );
    
    SELECT LAST_INSERT_ID() AS nuevo_usuario_id;
END//
DELIMITER ;

-- 2. Procedimiento para Obtener Todos los Usuarios
DELIMITER //
CREATE PROCEDURE procSelectUsers()
BEGIN
    SELECT 
        usu_id, 
        usu_nombre, 
        usu_apellido, 
        usu_correo, 
        usu_rol,
        usu_estado,
        usu_fecha_creacion,
        usu_fecha_ultima_modificacion
    FROM tbl_usuarios;
END//
DELIMITER ;

-- 3. Procedimiento para Obtener el ID y Nombre Completo de los Usuarios
DELIMITER //
CREATE PROCEDURE procSelectUsersDDL()
BEGIN
    SELECT 
        usu_id, 
        CONCAT(usu_nombre, ' ', usu_apellido) AS nombre
    FROM tbl_usuarios;
END//
DELIMITER ;

-- 4. Procedimiento para Actualizar los Datos de un Usuario
DELIMITER //
CREATE PROCEDURE procUpdateUsers(
    IN v_id INT, 
    IN v_nombre VARCHAR(50),
    IN v_apellido VARCHAR(50),
    IN v_correo VARCHAR(80),
    IN v_contrasena TEXT, 
    IN v_salt TEXT,
    IN v_rol ENUM('Administrador', 'Docente', 'Estudiante'),
    IN v_estado ENUM('Activo', 'Inactivo')
)
BEGIN
    -- Verificar si el correo ya existe en otro usuario
    IF EXISTS (SELECT 1 FROM tbl_usuarios WHERE usu_correo = v_correo AND usu_id != v_id) THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'El correo electrónico ya está registrado en otro usuario.';
    END IF;
    
    -- Actualizar usuario
    UPDATE tbl_usuarios 
    SET 
        usu_nombre = v_nombre,
        usu_apellido = v_apellido,
        usu_correo = v_correo,
        usu_contrasena = COALESCE(NULLIF(v_contrasena, ''), usu_contrasena),
        usu_salt = COALESCE(NULLIF(v_salt, ''), usu_salt),
        usu_rol = v_rol,
        usu_estado = v_estado,
        usu_fecha_ultima_modificacion = CURRENT_TIMESTAMP
    WHERE usu_id = v_id;
    
    SELECT ROW_COUNT() AS filas_afectadas;
END//
DELIMITER ;

-- 5. Procedimiento para Eliminar un Usuario por su ID
DELIMITER //
CREATE PROCEDURE procDeleteUsers(IN v_id INT)
BEGIN 
    DELETE FROM tbl_usuarios 
    WHERE usu_id = v_id;
END//
DELIMITER ;

-- 6. Procedimiento para Validar el Inicio de Sesión
DELIMITER //
CREATE PROCEDURE procValidateUserLogin(
    IN v_correo VARCHAR(80)
)
BEGIN 
    SELECT 
        usu_id, 
        CONCAT(usu_nombre, ' ', usu_apellido) AS nombre_completo,
        usu_correo,
        usu_contrasena,
        usu_salt,
        usu_rol,
        usu_estado
    FROM tbl_usuarios 
    WHERE usu_correo = v_correo;
END//
DELIMITER ;

-- 7. Procedimiento para Seleccionar un Usuario por su Correo
DELIMITER //
CREATE PROCEDURE procSelectUsersMail(IN p_mail VARCHAR(80))
BEGIN
    SELECT 
        usu_correo, 
        usu_contrasena, 
        usu_salt
    FROM tbl_usuarios
    WHERE usu_correo = p_mail;
END//
DELIMITER ;

-- 8. Procedimiento para Verificar si Existe al Menos un Administrador
DELIMITER //
CREATE PROCEDURE procCheckAdminExists()
BEGIN
    SELECT COUNT(*) 
    FROM tbl_usuarios 
    WHERE usu_rol = 'Administrador';
END//
DELIMITER ;

-- 9. Procedimiento para Verificar si un Correo Electrónico ya Está Registrado
DELIMITER //
CREATE PROCEDURE procCheckEmailExists(IN v_correo VARCHAR(80))
BEGIN
    SELECT COUNT(*) 
    FROM tbl_usuarios 
    WHERE usu_correo = v_correo;
END//
DELIMITER ;

-- 10. Buscar usuarios por correo
DELIMITER //
CREATE PROCEDURE procSearchUsersByEmail(
    IN p_correo VARCHAR(80)
)
BEGIN
    SELECT 
        usu_id, 
        usu_nombre, 
        usu_apellido, 
        usu_correo, 
        usu_rol,
        usu_estado
    FROM tbl_usuarios
    WHERE usu_correo LIKE CONCAT('%', p_correo, '%')
    ORDER BY usu_nombre, usu_apellido;
END//
DELIMITER ;

-- 11. Procedimiento para activar usuarios
DELIMITER //
CREATE PROCEDURE procActiveUser(IN p_usu_id INT)
BEGIN
    UPDATE tbl_usuarios SET usu_estado = 'Activo' WHERE usu_id = p_usu_id;
END //
DELIMITER ;

-- 12. Procedimiento para desactivar usuarios
DELIMITER //
CREATE PROCEDURE procDeactivateUser(IN p_usu_id INT)
BEGIN
    UPDATE tbl_usuarios SET usu_estado = 'Inactivo' WHERE usu_id = p_usu_id;
END //
DELIMITER ;

-- 13. Procedimiento para obtener solo usuarios activos
DELIMITER //
CREATE PROCEDURE procSelectActiveUsers()
BEGIN
    SELECT 
        usu_id, 
        usu_nombre, 
        usu_apellido, 
        usu_correo, 
        usu_rol
    FROM tbl_usuarios
    WHERE usu_estado = 'Activo';
END//
DELIMITER ;

-- 14. Procedimiento para búsqueda con filtro de estado
DELIMITER //
CREATE PROCEDURE procSearchUsersByStatus(
    IN p_correo VARCHAR(80),
    IN p_estado ENUM('Activo', 'Inactivo', 'Todos')
)
BEGIN
    IF p_estado = 'Todos' THEN
        SELECT 
            usu_id, 
            usu_nombre, 
            usu_apellido, 
            usu_correo, 
            usu_rol,
            usu_estado
        FROM tbl_usuarios
        WHERE usu_correo LIKE CONCAT('%', p_correo, '%');
    ELSE
        SELECT 
            usu_id, 
            usu_nombre, 
            usu_apellido, 
            usu_correo, 
            usu_rol,
            usu_estado
        FROM tbl_usuarios
        WHERE usu_correo LIKE CONCAT('%', p_correo, '%')
        AND usu_estado = p_estado;
    END IF;
END//
DELIMITER ;