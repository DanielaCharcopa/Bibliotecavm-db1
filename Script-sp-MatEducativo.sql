/*-----MATERIAL EDUCATIVO-----*/

/*INSERTAR*/
DELIMITER //

CREATE PROCEDURE proInsertMaterialEducativo(
    IN p_titulo TEXT,
    IN p_ano_publicacion YEAR,
    IN p_url_descarga TEXT,
    IN p_precio DECIMAL(10,0),
    IN p_keywords TEXT,
    IN p_formato ENUM('PDF', 'Epub', 'Video', 'Audio', 'Otro'),
    IN p_editorial_id INT,
    IN p_categoria_id INT)
BEGIN
    INSERT INTO tbl_material_edu(mat_titulo, mat_ano_publicacion, mat_url_descarga, mat_precio, mat_keywords, mat_formato, tbl_editorial_edi_id, tbl_categorias_cat_id)
    VALUES (p_titulo, p_ano_publicacion, p_url_descarga, p_precio, p_keywords, p_formato, p_editorial_id, p_categoria_id);
END //

DELIMITER ;

/*MOSTRAR*/
DELIMITER //
CREATE PROCEDURE proSelectMaterialEducativo()
BEGIN
    SELECT mat_id, mat_titulo, mat_ano_publicacion, mat_url_descarga,
    mat_precio, mat_keywords, mat_formato, tbl_editorial_edi_id FROM tbl_material_edu;
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
    IN editorial_id INT
)
BEGIN
    UPDATE tbl_material_edu SET mat_titulo = titulo, mat_ano_publicacion = ano_publicacion, mat_url_descarga 
    = url_descarga, mat_precio = precio, mat_keywords 
    = keywords, mat_formato = formato, tbl_editorial_edi_id = editorial_id WHERE mat_id = id;
END //
DELIMITER 

/*ELIMINAR*/
DELIMITER //
CREATE PROCEDURE proDeleteMaterialEducativo (IN id INT)
BEGIN
    DELETE FROM tbl_material_edu WHERE mat_id = id;
END //
DELIMITER 