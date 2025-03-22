/*-----CATEROGIAS-----*/
-- Insertar
DELIMITER // 
create procedure procInsertCategory(IN v_description TEXT, IN v_nombre ENUM ('Libro', 'Cartilla', 'Folleto', 'Guía Didactica', 'Juego Lúdico', 'Pendón', 'Multimedia') )
begin 
 insert into tbl_categorias(cat_nombre, cat_descripcion) values (v_nombre, v_description );
end//
DELIMITER ;

-- Mostrar
DELIMITER //
create procedure procSelectCategory()
begin
select cat_id,cat_nombre,cat_descripcion from tbl_categorias;
end//
DELIMITER ;
-- Mostrar DDL (ID y Nombre)
DELIMITER //
CREATE PROCEDURE procSelectCategoryDDL()
BEGIN
    SELECT cat_id, cat_nombre 
    FROM tbl_categorias;
END//
DELIMITER ;

-- Actualizar
DELIMITER // 
CREATE PROCEDURE procUpdateCategory(
    IN v_id INT, 
    IN v_nombre ENUM ('Libro', 'Cartilla', 'Folleto', 'Guía Didactica', 'Juego Lúdico', 'Pendón', 'Multimedia'),
    IN v_descripcion TEXT
)
BEGIN
    UPDATE tbl_categorias
    SET cat_id = v_id, cat_nombre = v_nombre, cat_descripcion = v_descripcion
    WHERE cat_id = v_id;
END//
DELIMITER ;

-- Eliminar
DELIMITER // 
create procedure procDeleteCategory( IN v_id INT)
begin
  delete from tbl_categorias where cat_id = v_id;
end// 
DELIMITER ;