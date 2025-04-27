-- Insertar una nueva solicitud de compra
DELIMITER //
CREATE PROCEDURE procInsertPurchase_request(
    IN v_solic_ticket VARCHAR(45),
    IN v_solic_fecha DATE,
    IN v_tbl_usuarios_usu_id INT,
    IN v_solic_cantidad TINYINT,
    IN v_tbl_material_edu_mat_id INT
)
BEGIN
    DECLARE v_precio DECIMAL(10, 0);
    DECLARE v_valor_total DECIMAL(10, 0);

    -- Obtener el precio del material educativo
    SELECT mat_precio INTO v_precio
    FROM tbl_material_edu
    WHERE mat_id = v_tbl_material_edu_mat_id;

    -- Calcular el valor total
    SET v_valor_total = v_solic_cantidad * v_precio;

    -- Insertar la solicitud de compra
    INSERT INTO tbl_solicitud_compra(
        solic_ticket, 
        solic_fecha, 
        tbl_usuarios_usu_id,
        solic_cantidad,
        tbl_material_edu_mat_id,
        solic_valor_total 
    )
    VALUES(
        v_solic_ticket, 
        v_solic_fecha, 
        v_tbl_usuarios_usu_id,
        v_solic_cantidad,
        v_tbl_material_edu_mat_id,
        v_valor_total  
    );
END//
DELIMITER ;

-- Mostrar todas las solicitudes de compra
DELIMITER //
CREATE PROCEDURE procSelectPurchase_request()
BEGIN
    SELECT 
        sc.solic_id, 
        sc.solic_ticket, 
        sc.solic_fecha, 
        CONCAT(u.usu_nombre, ' ', u.usu_apellido) AS usuario_nombre,
        sc.solic_cantidad,
        m.mat_titulo AS material_titulo,
        m.mat_precio AS precio_unitario, 
        sc.solic_valor_total  
    FROM 
        tbl_solicitud_compra sc
    INNER JOIN 
        tbl_usuarios u ON sc.tbl_usuarios_usu_id = u.usu_id
    INNER JOIN 
        tbl_material_edu m ON sc.tbl_material_edu_mat_id = m.mat_id
   ORDER BY 
        sc.solic_fecha DESC, sc.solic_id DESC;
END //
DELIMITER ;

-- Mostrar solicitudes de compra para DDL
DELIMITER //
CREATE PROCEDURE procSelectPurchase_requestDDL()
BEGIN
    SELECT 
        solic_id, 
        solic_ticket 
    FROM tbl_solicitud_compra;
END //
DELIMITER ;

-- Actualizar una solicitud de compra
DELIMITER //
CREATE PROCEDURE procUpdatePurchase_request(
    IN v_solic_id INT,
    IN v_solic_ticket VARCHAR(45),
    IN v_solic_fecha DATE,
    IN v_tbl_usuarios_usu_id INT,
    IN v_solic_cantidad TINYINT,
    IN v_tbl_material_edu_mat_id INT
)
BEGIN
    DECLARE v_precio DECIMAL(10, 0);
    DECLARE v_valor_total DECIMAL(10, 0);

    -- Obtener el precio del material educativo
    SELECT mat_precio INTO v_precio
    FROM tbl_material_edu
    WHERE mat_id = v_tbl_material_edu_mat_id;

    -- Calcular el valor total
    SET v_valor_total = v_solic_cantidad * v_precio;

    -- Actualizar la solicitud de compra
    UPDATE tbl_solicitud_compra 
    SET 
        solic_ticket = v_solic_ticket,
        solic_fecha = v_solic_fecha,
        tbl_usuarios_usu_id = v_tbl_usuarios_usu_id,
        solic_cantidad = v_solic_cantidad,
        tbl_material_edu_mat_id = v_tbl_material_edu_mat_id,
        solic_valor_total = v_valor_total  
    WHERE solic_id = v_solic_id;
END//
DELIMITER ;


-- Eliminar una solicitud de compra
DELIMITER //
CREATE PROCEDURE procDeletePurchase_request(IN v_solic_id INT)
BEGIN
    DELETE FROM tbl_solicitud_compra 
    WHERE solic_id = v_solic_id;
END //
DELIMITER ;

-- Contador de solicitudes de compra
DELIMITER //
CREATE PROCEDURE procCountPurchaseRequests()
BEGIN
    SELECT COUNT(*) AS total_solicitudes
    FROM tbl_solicitud_compra;
END //
DELIMITER ;


-- Solicitudes de compra por usuario logueado
DELIMITER //
CREATE PROCEDURE procSelectPurchaseRequestsByUser(
    IN v_user_id INT
)
BEGIN  
    SELECT 
        sc.solic_id,
        sc.solic_ticket,
        sc.solic_fecha,
        CONCAT(u.usu_nombre, ' ', u.usu_apellido) AS usuario_nombre,
        m.mat_titulo AS material_titulo,
		sc.tbl_material_edu_mat_id, 
        sc.solic_cantidad,
        m.mat_precio AS precio_unitario,
        sc.solic_valor_total  
    FROM 
        tbl_solicitud_compra sc
    INNER JOIN 
        tbl_usuarios u ON sc.tbl_usuarios_usu_id = u.usu_id
    INNER JOIN 
        tbl_material_edu m ON sc.tbl_material_edu_mat_id = m.mat_id
    WHERE 
        sc.tbl_usuarios_usu_id = v_user_id
        ORDER BY 
        sc.solic_fecha DESC, 
        sc.solic_id DESC;
END//
DELIMITER ;

    -- Seleccionar el ID y el título de los materiales educativos
DELIMITER //
CREATE PROCEDURE procGetMaterials()
BEGIN
    SELECT mat_id, mat_titulo, mat_precio
    FROM tbl_material_edu;
END //
DELIMITER ;


-- Alternar estado de completado
DELIMITER //
CREATE PROCEDURE proc_toggle_completada(
    IN p_solic_id INT
)
BEGIN
    DECLARE v_ticket VARCHAR(45);
    
    -- Obtener el ticket actual
    SELECT solic_ticket INTO v_ticket
    FROM tbl_solicitud_compra
    WHERE solic_id = p_solic_id;
    
    -- Alternar estado
    IF v_ticket LIKE '✓%' THEN
        -- Quitar checkmark si existe
        UPDATE tbl_solicitud_compra
        SET solic_ticket = SUBSTRING(v_ticket, 2)
        WHERE solic_id = p_solic_id;
    ELSE
        -- Agregar checkmark si no existe
        UPDATE tbl_solicitud_compra
        SET solic_ticket = CONCAT('✓', v_ticket)
        WHERE solic_id = p_solic_id;
    END IF;
    
    SELECT ROW_COUNT() AS resultado;
END //
DELIMITER ;


DELIMITER //
CREATE PROCEDURE procGetMaterialById(IN p_mat_id INT)
BEGIN
    SELECT mat_id, mat_titulo, mat_precio, mat_formato
    FROM tbl_material_edu
    WHERE mat_id = p_mat_id;
END //
DELIMITER ;
