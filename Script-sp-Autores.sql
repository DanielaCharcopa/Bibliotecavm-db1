
/*-----AUTORES-----*/
-- Insertar
DELIMITER // 
CREATE PROCEDURE proInsertAuthors(IN v_au_nombre varchar(15), IN v_au_apellido varchar(15), IN v_au_municipio varchar(25))
 BEGIN 
 INSERT INTO tbl_autores(au_nombre, au_apellido, au_municipio) VALUES (v_au_nombre, v_au_apellido, v_au_municipio); 
 END //
DELIMITER ;

-- Mostrar
DELIMITER //
CREATE PROCEDURE procSelectAuthors() 
BEGIN 
Select au_id, au_nombre, au_apellido, au_municipio
FROM tbl_autores; 
END //



-- Actualizar
DELIMITER // 
CREATE PROCEDURE procUpdateAuthor( 
IN v_au_id INT,
IN v_au_nombre varchar(15), IN v_au_apellido varchar(15), IN v_au_municipio varchar(25)) 
BEGIN UPDATE tbl_autores
SET  au_nombre = v_au_nombre, au_apellido = v_au_apellido, au_municipio = v_au_municipio 
 WHERE au_id = v_au_id;
 END //
DELIMITER ;


DELIMITER // 
CREATE PROCEDURE procDeleteAuthors( IN v_au_id INT) 
BEGIN  DELETE FROM tbl_autores
 WHERE au_id = v_au_id;
 END //
DELIMITER ;














