-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema bibliotecavm-db
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema bibliotecavm-db
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `bibliotecavm-db` DEFAULT CHARACTER SET utf8mb3 ;
USE `bibliotecavm-db` ;

-- -----------------------------------------------------
-- Table `bibliotecavm-db`.`tbl_autores`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `bibliotecavm-db`.`tbl_autores` (
  `au_id` INT NOT NULL AUTO_INCREMENT,
  `au_nombre` VARCHAR(50) NOT NULL,
  `au_apellido` VARCHAR(50) NOT NULL,
  `au_municipio` VARCHAR(25) NOT NULL,
  PRIMARY KEY (`au_id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `bibliotecavm-db`.`tbl_categorias`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `bibliotecavm-db`.`tbl_categorias` (
  `cat_id` INT NOT NULL AUTO_INCREMENT,
  `cat_nombre` ENUM('Libro', 'Cartilla', 'Folleto', 'Guía Didactica', 'Juego Lúdico', 'Pendón', 'Multimedia') NOT NULL,
  `cat_descripcion` TEXT NOT NULL,
  PRIMARY KEY (`cat_id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `bibliotecavm-db`.`tbl_editorial`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `bibliotecavm-db`.`tbl_editorial` (
  `edi_id` INT NOT NULL AUTO_INCREMENT,
  `edi_nombre` VARCHAR(45) NOT NULL,
  `edi_ciudad` VARCHAR(45) NOT NULL,
  `edi_telefono` INT NOT NULL,
  `edi_correo` VARCHAR(80) NOT NULL,
  PRIMARY KEY (`edi_id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `bibliotecavm-db`.`tbl_usuarios`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `bibliotecavm-db`.`tbl_usuarios` (
  `usu_id` INT NOT NULL AUTO_INCREMENT,
  `usu_nombre` VARCHAR(50) NOT NULL,
  `usu_apellido` VARCHAR(50) NOT NULL,
  `usu_correo` VARCHAR(80) NOT NULL,
  `usu_contrasena` TEXT NOT NULL,
  `usu_salt` TEXT NOT NULL,
  `usu_rol` ENUM('Administrador', 'Docente', 'Estudiante') NOT NULL,
  `usu_nivel_estudios` ENUM('Primaria', 'Secundaria', 'Bachillerato', 'Técnico', 'Tecnólogo', 'Pregrado', 'Especialización', 'Maestría', 'Doctorado', 'Postdoctorado') NOT NULL,
  PRIMARY KEY (`usu_id`),
  UNIQUE INDEX `usu_correo_UNIQUE` (`usu_correo` ASC) )
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `bibliotecavm-db`.`tbl_encuesta`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `bibliotecavm-db`.`tbl_encuesta` (
  `en_id` INT NOT NULL AUTO_INCREMENT,
  `en_descripcion_pregunta` TEXT NOT NULL,
  `tbl_usuarios_usu_id` INT NOT NULL,
  PRIMARY KEY (`en_id`, `tbl_usuarios_usu_id`),
  INDEX `fk_tbl_encuesta_tbl_usuarios1_idx` (`tbl_usuarios_usu_id` ASC) ,
  CONSTRAINT `fk_tbl_encuesta_tbl_usuarios1`
    FOREIGN KEY (`tbl_usuarios_usu_id`)
    REFERENCES `bibliotecavm-db`.`tbl_usuarios` (`usu_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `bibliotecavm-db`.`tbl_material_edu`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `bibliotecavm-db`.`tbl_material_edu` (
  `mat_id` INT NOT NULL AUTO_INCREMENT,
  `mat_titulo` TEXT NOT NULL,
  `mat_ano_publicacion` YEAR NOT NULL,
  `mat_url_descarga` TEXT NOT NULL,
  `mat_precio` DECIMAL(10,0) NOT NULL,
  `mat_keywords` TEXT NULL DEFAULT NULL,
  `mat_formato` ENUM('PDF', 'Epub', 'Video', 'Audio', 'Otro') NOT NULL,
  `tbl_editorial_edi_id` INT NOT NULL,
  `tbl_categorias_cat_id` INT NOT NULL,
  PRIMARY KEY (`mat_id`),
  INDEX `fk_tbl_material_edu_tbl_editorial1_idx` (`tbl_editorial_edi_id` ASC) ,
  INDEX `fk_tbl_material_edu_tbl_categorias1_idx` (`tbl_categorias_cat_id` ASC) ,
  CONSTRAINT `fk_tbl_material_edu_tbl_categorias1`
    FOREIGN KEY (`tbl_categorias_cat_id`)
    REFERENCES `bibliotecavm-db`.`tbl_categorias` (`cat_id`),
  CONSTRAINT `fk_tbl_material_edu_tbl_editorial1`
    FOREIGN KEY (`tbl_editorial_edi_id`)
    REFERENCES `bibliotecavm-db`.`tbl_editorial` (`edi_id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `bibliotecavm-db`.`tbl_material_edu_has_tbl_autores`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `bibliotecavm-db`.`tbl_material_edu_has_tbl_autores` (
  `tbl_material_edu_mat_id` INT NOT NULL,
  `tbl_autores_au_id` INT NOT NULL,
  PRIMARY KEY (`tbl_material_edu_mat_id`, `tbl_autores_au_id`),
  INDEX `fk_tbl_material_edu_has_tbl_autores_tbl_autores1_idx` (`tbl_autores_au_id` ASC) ,
  INDEX `fk_tbl_material_edu_has_tbl_autores_tbl_material_edu_idx` (`tbl_material_edu_mat_id` ASC) ,
  CONSTRAINT `fk_tbl_material_edu_has_tbl_autores_tbl_autores1`
    FOREIGN KEY (`tbl_autores_au_id`)
    REFERENCES `bibliotecavm-db`.`tbl_autores` (`au_id`),
  CONSTRAINT `fk_tbl_material_edu_has_tbl_autores_tbl_material_edu`
    FOREIGN KEY (`tbl_material_edu_mat_id`)
    REFERENCES `bibliotecavm-db`.`tbl_material_edu` (`mat_id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `bibliotecavm-db`.`tbl_respuestas`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `bibliotecavm-db`.`tbl_respuestas` (
  `res_id` INT NOT NULL AUTO_INCREMENT,
  `res_respuesta` TEXT NOT NULL,
  `tbl_encuesta_en_id` INT NOT NULL,
  `tbl_encuesta_tbl_usuarios_usu_id` INT NOT NULL,
  PRIMARY KEY (`res_id`, `tbl_encuesta_en_id`, `tbl_encuesta_tbl_usuarios_usu_id`),
  INDEX `fk_tbl_respuestas_tbl_encuesta1_idx` (`tbl_encuesta_en_id` ASC, `tbl_encuesta_tbl_usuarios_usu_id` ASC) ,
  CONSTRAINT `fk_tbl_respuestas_tbl_encuesta1`
    FOREIGN KEY (`tbl_encuesta_en_id` , `tbl_encuesta_tbl_usuarios_usu_id`)
    REFERENCES `bibliotecavm-db`.`tbl_encuesta` (`en_id` , `tbl_usuarios_usu_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `bibliotecavm-db`.`tbl_solicitud_compra`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `bibliotecavm-db`.`tbl_solicitud_compra` (
  `solic_id` INT NOT NULL AUTO_INCREMENT,
  `solic_ticket` VARCHAR(45) NOT NULL,
  `solic_fecha` DATE NOT NULL,
  `solic_cantidad` TINYINT NOT NULL,
  `solic_valor_total` DECIMAL(10,0) NOT NULL,
  `tbl_usuarios_usu_id` INT NOT NULL,
  `tbl_material_edu_mat_id` INT NOT NULL,
  PRIMARY KEY (`solic_id`),
  INDEX `fk_tbl_solicitud_compra_tbl_usuarios1_idx` (`tbl_usuarios_usu_id` ASC) ,
  INDEX `fk_tbl_solicitud_compra_tbl_material_edu1_idx` (`tbl_material_edu_mat_id` ASC) ,
  CONSTRAINT `fk_tbl_solicitud_compra_tbl_material_edu1`
    FOREIGN KEY (`tbl_material_edu_mat_id`)
    REFERENCES `bibliotecavm-db`.`tbl_material_edu` (`mat_id`),
  CONSTRAINT `fk_tbl_solicitud_compra_tbl_usuarios1`
    FOREIGN KEY (`tbl_usuarios_usu_id`)
    REFERENCES `bibliotecavm-db`.`tbl_usuarios` (`usu_id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `bibliotecavm-db`.`tbl_visitas`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `bibliotecavm-db`.`tbl_visitas` (
  `vis_id` INT NOT NULL AUTO_INCREMENT,
  `vis_fecha_ingreso` DATE NOT NULL,
  `vis_duracion` TIME NOT NULL,
  `vis_dispositivo` ENUM('Computadora', 'Móvil', 'Tableta', 'Otro') NOT NULL,
  `tbl_usuarios_usu_id` INT NOT NULL,
  `tbl_material_edu_mat_id` INT NOT NULL,
  PRIMARY KEY (`vis_id`),
  INDEX `fk_tbl_visitas_tbl_usuarios1_idx` (`tbl_usuarios_usu_id` ASC) ,
  INDEX `fk_tbl_visitas_tbl_material_edu1_idx` (`tbl_material_edu_mat_id` ASC) ,
  CONSTRAINT `fk_tbl_visitas_tbl_material_edu1`
    FOREIGN KEY (`tbl_material_edu_mat_id`)
    REFERENCES `bibliotecavm-db`.`tbl_material_edu` (`mat_id`),
  CONSTRAINT `fk_tbl_visitas_tbl_usuarios1`
    FOREIGN KEY (`tbl_usuarios_usu_id`)
    REFERENCES `bibliotecavm-db`.`tbl_usuarios` (`usu_id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
