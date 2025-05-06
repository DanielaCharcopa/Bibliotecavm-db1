-- 1. Procedimiento para Insertar un Nuevo Usuario
DELIMITER //
CREATE PROCEDURE procInsertUsers(
    IN v_nombre VARCHAR(50),
    IN v_apellido VARCHAR(50),
    IN v_correo VARCHAR(80),
    IN v_contrasena TEXT, 
    IN v_salt TEXT,
    IN v_rol ENUM('Administrador', 'Docente', 'Estudiante'),
    IN v_nivel_estudios ENUM('Primaria', 'Secundaria', 'Bachillerato', 'Técnico', 'Tecnólogo', 'Pregrado', 'Especialización', 'Maestría', 'Doctorado', 'Postdoctorado')
)
BEGIN
    DECLARE email_count INT;
    SELECT COUNT(*) INTO email_count 
    FROM tbl_usuarios 
    WHERE usu_correo = v_correo;

    IF email_count = 0 THEN
        INSERT INTO tbl_usuarios(
            usu_nombre, 
            usu_apellido, 
            usu_correo, 
            usu_contrasena, 
            usu_salt, 
            usu_rol, 
            usu_nivel_estudios,
            usu_estado  -- Se añade el campo estado con valor por defecto 'Activo'
        ) 
        VALUES (
            v_nombre, 
            v_apellido, 
            v_correo, 
            v_contrasena, 
            v_salt, 
            v_rol, 
            v_nivel_estudios,
            'Activo'  -- Valor explícito para mayor claridad
        );
    ELSE
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'El correo electrónico ya está registrado.';
    END IF;
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
        usu_nivel_estudios,
        usu_estado,  -- Nuevo campo
        usu_fecha_creacion,  -- Nuevo campo
        usu_fecha_ultima_modificacion  -- Nuevo campo
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
    IN v_nivel_estudios ENUM('Primaria', 'Secundaria', 'Bachillerato', 'Técnico', 'Tecnólogo', 'Pregrado', 'Especialización', 'Maestría', 'Doctorado', 'Postdoctorado'),
    IN v_estado ENUM('Activo', 'Inactivo')  -- Nuevo parámetro para el estado
)
BEGIN
    -- Verificar si el nuevo correo ya existe en otro usuario distinto al actual
    DECLARE email_count INT;
    SELECT COUNT(*) INTO email_count 
    FROM tbl_usuarios 
    WHERE usu_correo = v_correo AND usu_id != v_id;

    -- Si el correo no está en uso por otro usuario, se actualizan los datos
    IF email_count = 0 THEN
        UPDATE tbl_usuarios 
        SET 
            usu_nombre = v_nombre,
            usu_apellido = v_apellido,
            usu_correo = v_correo,
            usu_contrasena = CASE 
                              WHEN v_contrasena IS NOT NULL AND v_contrasena != '' THEN v_contrasena
                              ELSE usu_contrasena  -- Mantiene el valor actual si no se proporciona nueva contraseña
                            END,
            usu_salt = CASE 
                        WHEN v_salt IS NOT NULL AND v_salt != '' THEN v_salt
                        ELSE usu_salt  -- Mantiene el valor actual si no se proporciona nuevo salt
                      END,
            usu_rol = v_rol,
            usu_nivel_estudios = v_nivel_estudios,
            usu_estado = v_estado,  -- Actualiza el estado
            usu_fecha_ultima_modificacion = CURRENT_TIMESTAMP  -- Actualiza automáticamente la fecha
        WHERE usu_id = v_id;
        
        -- Retorna el número de filas afectadas
        SELECT ROW_COUNT() AS filas_afectadas;
    ELSE
        -- Si el correo ya está en uso, se lanza un error
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'El correo electrónico ya está registrado en otro usuario.';
    END IF;
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

-- 6. Procedimiento para Validar el Inicio de Sesión comprobando correo y contraseña
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
        usu_estado  -- Importante para verificar si puede iniciar sesión
    FROM tbl_usuarios 
    WHERE usu_correo = v_correo;
END//
DELIMITER ;


-- 7. Procedimiento para Seleccionar un Usuario por su Correo
DELIMITER //
CREATE PROCEDURE procSelectUsersMail(IN p_mail VARCHAR(80))
BEGIN
    -- Seleccionar los datos del usuario por su correo
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

-- 10 Buscar por correo a los usuarios: 
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
        usu_nivel_estudios,
        usu_estado  -- Asegurando incluir el estado
    FROM tbl_usuarios
    WHERE usu_correo LIKE CONCAT('%', p_correo, '%')
    ORDER BY usu_nombre, usu_apellido;  -- Ordenar resultados
END//
DELIMITER ;

-- procedimiento para activar usuarios.

DELIMITER //
CREATE PROCEDURE procActiveUser(IN p_usu_id INT)
BEGIN
    UPDATE tbl_usuarios SET usu_estado = 'Activo' WHERE usu_id = p_usu_id;
END //
DELIMITER ;

-- procedimiento para desactivar usuarios.

DELIMITER //
CREATE PROCEDURE procDeactivateUser(IN p_usu_id INT)
BEGIN
    UPDATE tbl_usuarios SET usu_estado = 'Inactivo' WHERE usu_id = p_usu_id;
END //
DELIMITER ;


--  procedimiento para obtener solo usuarios activos
DELIMITER //
CREATE PROCEDURE procSelectActiveUsers()
BEGIN
    SELECT 
        usu_id, 
        usu_nombre, 
        usu_apellido, 
        usu_correo, 
        usu_rol, 
        usu_nivel_estudios
    FROM tbl_usuarios
    WHERE usu_estado = 'Activo';
END//
DELIMITER ;

--  procedimiento para búsqueda con filtro de estado

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
            usu_nivel_estudios,
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
            usu_nivel_estudios,
            usu_estado
        FROM tbl_usuarios
        WHERE usu_correo LIKE CONCAT('%', p_correo, '%')
        AND usu_estado = p_estado;
    END IF;
END//
DELIMITER ;


