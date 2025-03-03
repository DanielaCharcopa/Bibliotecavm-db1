-- Insertar un nuevo usuario en la tabla tbl_usuarios
DELIMITER //
CREATE PROCEDURE procInsertUsers(
    IN v_nombre VARCHAR(50),
    IN v_apellido VARCHAR(50),
    IN v_correo VARCHAR(80),
    IN v_contrasena TEXT, 
    IN v_salt TEXT,
    IN v_rol ENUM('Administrador', 'Docente', 'Estudiante'),
    IN v_nivel_estudios ENUM('Primaria', 'Secundaria', 'Bachillerato', 'Técnico', 'Tecnólogo', 'Pregrado', 'Especialización', 'Maestría', 'Doctorado', 'Postdoctorado'))
BEGIN
    -- Verificar si el correo electrónico ya existe en la base de datos
    DECLARE email_count INT;
    SELECT COUNT(*) INTO email_count 
    FROM tbl_usuarios-- Insertar un nuevo usuario en la tabla tbl_usuarios
DELIMITER //
CREATE PROCEDURE procInsertUsers(
    IN v_nombre VARCHAR(50),
    IN v_apellido VARCHAR(50),
    IN v_correo VARCHAR(80),
    IN v_contrasena TEXT, 
    IN v_salt TEXT,
    IN v_rol ENUM('Administrador', 'Docente', 'Estudiante'),
    IN v_nivel_estudios ENUM('Primaria', 'Secundaria', 'Bachillerato', 'Técnico', 'Tecnólogo', 'Pregrado', 'Especialización', 'Maestría', 'Doctorado', 'Postdoctorado'))
BEGIN
    -- Verificar si el correo electrónico ya existe en la base de datos
    DECLARE email_count INT;
    SELECT COUNT(*) INTO email_count 
    FROM tbl_usuarios 
    WHERE usu_correo = v_correo;

    -- Si el correo no existe, se inserta el nuevo usuario
    IF email_count = 0 THEN
        INSERT INTO tbl_usuarios(
            usu_nombre, 
            usu_apellido, 
            usu_correo, 
            usu_contrasena, 
            usu_salt, 
            usu_rol, 
            usu_nivel_estudios) 
        VALUES (
            v_nombre, 
            v_apellido, 
            v_correo, 
            v_contrasena, 
            v_salt, 
            v_rol, 
            v_nivel_estudios);
    ELSE
        -- Si el correo ya está registrado, se lanza un error
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'El correo electrónico ya está registrado.';
    END IF;
END//
DELIMITER ;

-- Obtener todos los usuarios con sus datos básicos
DELIMITER //
CREATE PROCEDURE procSelectUsers()
BEGIN
    SELECT 
        usu_id, 
        usu_nombre, 
        usu_apellido, 
        usu_correo, 
        usu_rol, 
        usu_nivel_estudios
    FROM tbl_usuarios;
END//
DELIMITER ;

-- Obtener solo el ID y nombre completo de los usuarios (útil para listas desplegables)
DELIMITER //
CREATE PROCEDURE procSelectUsersDDL()
BEGIN
    SELECT 
        usu_id, 
        CONCAT(usu_nombre, ' ', usu_apellido) AS nombre
    FROM tbl_usuarios;
END//
DELIMITER ;

-- Actualizar los datos de un usuario específico
DELIMITER //
CREATE PROCEDURE procUpdateUsers(
    IN v_id INT, 
    IN v_nombre VARCHAR(50),
    IN v_apellido VARCHAR(50),
    IN v_correo VARCHAR(80),
    IN v_contrasena TEXT, 
    IN v_salt TEXT,
    IN v_rol ENUM('Administrador', 'Docente', 'Estudiante'),
    IN v_nivel_estudios ENUM('Primaria', 'Secundaria', 'Bachillerato', 'Técnico', 'Tecnólogo', 'Pregrado', 'Especialización', 'Maestría', 'Doctorado', 'Postdoctorado'))
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
            usu_contrasena = v_contrasena,
            usu_salt = v_salt,
            usu_rol = v_rol,
            usu_nivel_estudios = v_nivel_estudios
        WHERE usu_id = v_id;
    ELSE
        -- Si el correo ya está en uso, se lanza un error
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'El correo electrónico ya está registrado en otro usuario.';
    END IF;
END//
DELIMITER ;

-- Eliminar un usuario por su ID
DELIMITER //
CREATE PROCEDURE procDeleteUsers(IN v_id INT)
BEGIN 
    DELETE FROM tbl_usuarios 
    WHERE usu_id = v_id;
END//
DELIMITER ;

-- Validar el inicio de sesión comprobando correo y contraseña
DELIMITER //
CREATE PROCEDURE procValidateUserLogin(
    IN v_correo VARCHAR(80), 
    IN v_contrasena_hash TEXT) -- Contraseña ya hasheada proporcionada por la aplicación
BEGIN 
    -- Seleccionar los datos del usuario si el correo y la contraseña hasheada coinciden
    SELECT 
        usu_id, 
        CONCAT(usu_nombre, ' ', usu_apellido) AS nombre_completo, -- Concatenar nombre y apellido
        usu_correo,
        usu_contrasena,
        usu_salt,
        usu_rol
    FROM tbl_usuarios 
    WHERE usu_correo = v_correo;

END //
DELIMITER ;
-- Selecciona un usuario por su correo
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
END //
DELIMITER ;

-- Verificar si existe al menos un usuario con rol de administrador
DELIMITER // 
CREATE PROCEDURE procCheckAdminExists()
BEGIN
    SELECT COUNT(*) 
    FROM tbl_usuarios 
    WHERE usu_rol = 'Administrador';
END //
DELIMITER ;

-- Verificar si un correo electrónico ya está registrado en la base de datos
DELIMITER // 
CREATE PROCEDURE procCheckEmailExists(IN v_correo VARCHAR(80))
BEGIN
    SELECT COUNT(*) 
    FROM tbl_usuarios 
    WHERE usu_correo = v_correo;
END //
DELIMITER ;
 
    WHERE usu_correo = v_correo;

    -- Si el correo no existe, se inserta el nuevo usuario
    IF email_count = 0 THEN
        INSERT INTO tbl_usuarios(
            usu_nombre, 
            usu_apellido, 
            usu_correo, 
            usu_contrasena, 
            usu_salt, 
            usu_rol, 
            usu_nivel_estudios) 
        VALUES (
            v_nombre, 
            v_apellido, 
            v_correo, 
            v_contrasena, 
            v_salt, 
            v_rol, 
            v_nivel_estudios);
    ELSE
        -- Si el correo ya está registrado, se lanza un error
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'El correo electrónico ya está registrado.';
    END IF;
END//
DELIMITER ;

-- Obtener todos los usuarios con sus datos básicos
DELIMITER //
CREATE PROCEDURE procSelectUsers()
BEGIN
    SELECT 
        usu_id, 
        usu_nombre, 
        usu_apellido, 
        usu_correo, 
        usu_rol, 
        usu_nivel_estudios
    FROM tbl_usuarios;
END//
DELIMITER ;

-- Obtener solo el ID y nombre completo de los usuarios (útil para listas desplegables)
DELIMITER //
CREATE PROCEDURE procSelectUsersDDL()
BEGIN
    SELECT 
        usu_id, 
        CONCAT(usu_nombre, ' ', usu_apellido) AS nombre
    FROM tbl_usuarios;
END//
DELIMITER ;

-- Actualizar los datos de un usuario específico
DELIMITER //
CREATE PROCEDURE procUpdateUsers(
    IN v_id INT, 
    IN v_nombre VARCHAR(50),
    IN v_apellido VARCHAR(50),
    IN v_correo VARCHAR(80),
    IN v_contrasena TEXT, 
    IN v_salt TEXT,
    IN v_rol ENUM('Administrador', 'Docente', 'Estudiante'),
    IN v_nivel_estudios ENUM('Primaria', 'Secundaria', 'Bachillerato', 'Técnico', 'Tecnólogo', 'Pregrado', 'Especialización', 'Maestría', 'Doctorado', 'Postdoctorado'))
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
            usu_contrasena = v_contrasena,
            usu_salt = v_salt,
            usu_rol = v_rol,
            usu_nivel_estudios = v_nivel_estudios
        WHERE usu_id = v_id;
    ELSE
        -- Si el correo ya está en uso, se lanza un error
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'El correo electrónico ya está registrado en otro usuario.';
    END IF;
END//
DELIMITER ;

-- Eliminar un usuario por su ID
DELIMITER //
CREATE PROCEDURE procDeleteUsers(IN v_id INT)
BEGIN 
    DELETE FROM tbl_usuarios 
    WHERE usu_id = v_id;
END//
DELIMITER ;

-- Validar el inicio de sesión comprobando correo y contraseña
DELIMITER //
CREATE PROCEDURE procValidateUserLogin(
    IN v_correo VARCHAR(80), 
    IN v_contrasena TEXT) -- Contraseña en texto plano proporcionada por el usuario
BEGIN 
    -- Seleccionar los datos del usuario si el correo y la contraseña (hash + salt) coinciden
    SELECT 
        usu_id, 
        usu_nombre, 
        usu_apellido, 
        usu_rol,
        usu_contrasena, -- Hash de la contraseña almacenado
        usu_salt        -- Salt almacenado
    FROM tbl_usuarios 
    WHERE usu_correo = v_correo 
    AND usu_contrasena = SHA2(CONCAT(v_contrasena, usu_salt), 256); -- Validación con salt
END //
DELIMITER ;

-- Verificar si existe al menos un usuario con rol de administrador
DELIMITER // 
CREATE PROCEDURE procCheckAdminExists()
BEGIN
    SELECT COUNT(*) 
    FROM tbl_usuarios 
    WHERE usu_rol = 'Administrador';
END //
DELIMITER ;

-- Verificar si un correo electrónico ya está registrado en la base de datos
DELIMITER // 
CREATE PROCEDURE procCheckEmailExists(IN v_correo VARCHAR(80))
BEGIN
    SELECT COUNT(*) 
    FROM tbl_usuarios 
    WHERE usu_correo = v_correo;
END //
DELIMITER ;
