-- Insertar
DELIMITER // 
CREATE PROCEDURE proInsertMaterialAutor(IN v_tbl_material_edu_mat_id INT, IN v_tbl_autores_au_id INT, IN v_descripcion TEXT)
 BEGIN 
 INSERT INTO tbl_material_edu_has_tbl_autores(tbl_material_edu_mat_id, tbl_autores_au_id, descripcion) 
 VALUES (v_tbl_material_edu_mat_id, v_tbl_autores_au_id, v_descripcion); 
 END //
DELIMITER ;

-- Mostrar
DELIMITER //

CREATE PROCEDURE procSelectMaterial_Autores()
BEGIN
      SELECT 
    t.mat_titulo AS tbl_material_edu_mat_id,
    GROUP_CONCAT(ma.id_material_autores SEPARATOR ', ') AS id_material_autores,
    GROUP_CONCAT(CONCAT(a.au_nombre, ' ', a.au_apellido) SEPARATOR ', ') AS tbl_autores_au_id,
    ma.descripcion  AS descripcion
FROM tbl_material_edu_has_tbl_autores ma
INNER JOIN tbl_material_edu t ON ma.tbl_material_edu_mat_id = t.mat_id
INNER JOIN tbl_autores a ON ma.tbl_autores_au_id = a.au_id
GROUP BY t.mat_titulo;

END //

DELIMITER ;

-- Mostrar DDL
DELIMITER //
CREATE PROCEDURE procSelectMaterial_Autor_DDL()
BEGIN
    SELECT tbl_material_edu_mat_id, tbl_autores_au_id, descripcion
    FROM tbl_material_edu_has_tbl_autores;
END//
DELIMITER ;

-- Actualizar
DELIMITER // 
CREATE PROCEDURE procUpdateMaterial_Autor( 
IN v_id_material_autores INT,
IN v_tbl_material_edu_mat_id INT, IN v_tbl_autores_au_id INT, IN v_descripcion TEXT)
BEGIN UPDATE tbl_material_edu_has_tbl_autores
SET  tbl_material_edu_mat_id = v_tbl_material_edu_mat_id, tbl_autores_au_id = v_tbl_autores_au_id,
 descripcion = v_descripcion 
 WHERE id_material_autores = v_id_material_autores;
 END //
DELIMITER ;

-- Eliminar 
DELIMITER // 
CREATE PROCEDURE procDeleteMaterial_Autor( IN v_id_material_autores INT) 
BEGIN  DELETE FROM tbl_material_edu_has_tbl_autores
 WHERE id_material_autores = v_id_material_autores;
 END //
DELIMITER ;

