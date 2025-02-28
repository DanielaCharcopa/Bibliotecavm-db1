/*-----EDITORIAL-----*/
-- Insertar
DELIMITER // 
create procedure procInsertEditorial(IN v_nombre VARCHAR(45),IN v_ciudad VARCHAR(25), IN v_telefono INT,IN v_correo varchar(80) )
begin 
     insert into tbl_editorial(edi_nombre, edi_ciudad, edi_telefono, edi_correo) values (v_nombre, v_ciudad, v_telefono, v_correo );
end//
DELIMITER ;

-- Mostrar
DELIMITER //
create procedure procSelectEditorial()
begin
select edi_nombre, edi_ciudad, edi_telefono, edi_correo from tbl_editorial;
end//
DELIMITER ;

-- Actualizar
DELIMITER // 
CREATE PROCEDURE procUpdateEditorial(
    IN v_id INT, 
    IN v_nombre VARCHAR(45),IN v_ciudad VARCHAR(25), IN v_telefono INT,IN v_correo varchar(80)
)
BEGIN
    UPDATE tbl_editorial
    SET edi_nombre = v_nombre, edi_ciudad =  v_ciudad, edi_telefono = v_telefono, edi_correo = v_correo
    WHERE edi_id = v_id;
END//
DELIMITER ;

-- Eliminar
DELIMITER // 
create procedure procDeleteEditorial( IN v_id INT)
begin
  delete from tbl_editorial where edi_id = v_id;
end// 
DELIMITER ;