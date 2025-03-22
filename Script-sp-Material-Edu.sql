/*-----MATERIAL EDUCATIVO-----*/

/*INSERTAR*/
DELIMITER //
CREATE PROCEDURE proInsertMaterialEducativo (
    IN titulo TEXT,
    IN ano_publicacion YEAR,
    IN url_descarga TEXT,
    IN precio DECIMAL(10, 0),
    IN keywords TEXT,
    IN formato ENUM('PDF', 'Epub', 'Video', 'Audio', 'Otro'), 
    IN editorial_id INT,
    IN categoria_id INT  -- Nuevo parámetro para la categoría
)
BEGIN
    INSERT INTO tbl_material_edu (
        mat_titulo, 
        mat_ano_publicacion, 
        mat_url_descarga, 
        mat_precio, 
        mat_keywords, 
        mat_formato, 
        tbl_editorial_edi_id,
        tbl_categorias_cat_id  -- Nueva columna
    ) 
    VALUES (
        titulo, 
        ano_publicacion, 
        url_descarga, 
        precio, 
        keywords, 
        formato, 
        editorial_id,
        categoria_id  -- Nuevo valor
    );
END //
DELIMITER ;

/*MOSTRAR*/
DELIMITER //
CREATE PROCEDURE proSelectMaterialEducativo()
BEGIN
    SELECT 
        m.mat_id, 
        m.mat_titulo, 
        m.mat_ano_publicacion, 
        m.mat_url_descarga,
        m.mat_precio, 
        m.mat_keywords, 
        m.mat_formato, 
        m.tbl_editorial_edi_id,
        m.tbl_categorias_cat_id,
        e.edi_nombre AS editorial_nombre,
        c.cat_nombre AS categoria_nombre
    FROM tbl_material_edu m
    INNER JOIN tbl_editorial e ON m.tbl_editorial_edi_id = e.edi_id
    INNER JOIN tbl_categorias c ON m.tbl_categorias_cat_id = c.cat_id;
END //
DELIMITER ;

/*ACTUALIZAR*/
DELIMITER //
CREATE PROCEDURE proUpdateMaterialEducativo (
    IN id INT,
    IN titulo TEXT,
    IN ano_publicacion YEAR,
    IN url_descarga TEXT,
    IN precio DECIMAL(10, 0),
    IN keywords TEXT,
    IN formato ENUM('PDF', 'Epub', 'Video', 'Audio', 'Otro'), 
    IN editorial_id INT,
    IN categoria_id INT  -- Nuevo parámetro para la categoría
)
BEGIN
    UPDATE tbl_material_edu 
    SET 
        mat_titulo = titulo, 
        mat_ano_publicacion = ano_publicacion, 
        mat_url_descarga = url_descarga, 
        mat_precio = precio, 
        mat_keywords = keywords, 
        mat_formato = formato, 
        tbl_editorial_edi_id = editorial_id,
        tbl_categorias_cat_id = categoria_id  
    WHERE mat_id = id;
END //
DELIMITER ;

/*ELIMINAR*/
DELIMITER //
CREATE PROCEDURE proDeleteMaterialEducativo (IN id INT)
BEGIN
    DELETE FROM tbl_material_edu WHERE mat_id = id;
END //
DELIMITER ;

