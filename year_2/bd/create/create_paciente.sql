CREATE TABLE IF NOT EXISTS `mydb`.`Objetivo` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `data_limite` DATE NOT NULL,
  `atingido` TINYINT NOT NULL DEFAULT 0,
  `Paciente_id` INT NOT NULL,
  INDEX `fk_Objetivo_Paciente1_idx` (`Paciente_id` ASC) VISIBLE,
  PRIMARY KEY (`id`),
  CONSTRAINT `fk_Objetivo_Paciente1`
    FOREIGN KEY (`Paciente_id`)
    REFERENCES `mydb`.`Paciente` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `mydb`.`Telemovel` (
  `numero` INT NOT NULL,
  `Paciente_id` INT NOT NULL,
  PRIMARY KEY (`numero`, `Paciente_id`),
  INDEX `fk_Telemovel_Paciente1_idx` (`Paciente_id` ASC) VISIBLE,
  CONSTRAINT `fk_Telemovel_Paciente1`
    FOREIGN KEY (`Paciente_id`)
    REFERENCES `mydb`.`Paciente` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `mydb`.`Medicao` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `valor` FLOAT NOT NULL,
  `tipo` VARCHAR(45) NOT NULL,
  `data` DATE NULL,
  `unidade` VARCHAR(45) NULL,
  `Paciente_id` INT NOT NULL,
  `Objetivo_id` INT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_Medicao_Paciente1_idx` (`Paciente_id` ASC) VISIBLE,
  INDEX `fk_Medicao_Objetivo1_idx` (`Objetivo_id` ASC) VISIBLE,
  CONSTRAINT `fk_Medicao_Paciente1`
    FOREIGN KEY (`Paciente_id`)
    REFERENCES `mydb`.`Paciente` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Medicao_Objetivo1`
    FOREIGN KEY (`Objetivo_id`)
    REFERENCES `mydb`.`Objetivo` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `mydb`.`Etiqueta` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `descricao` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `descricao_UNIQUE` (`descricao` ASC) VISIBLE)
ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `mydb`.`EtiquetaPaciente` (
  `Etiqueta_id` INT NOT NULL,
  `Paciente_id` INT NOT NULL,
  `data_associacao` DATE NOT NULL,
  PRIMARY KEY (`Etiqueta_id`, `Paciente_id`),
  INDEX `fk_Etiqueta_has_Paciente_Paciente1_idx` (`Paciente_id` ASC) VISIBLE,
  INDEX `fk_Etiqueta_has_Paciente_Etiqueta1_idx` (`Etiqueta_id` ASC) VISIBLE,
  CONSTRAINT `fk_Etiqueta_has_Paciente_Etiqueta1`
    FOREIGN KEY (`Etiqueta_id`)
    REFERENCES `mydb`.`Etiqueta` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Etiqueta_has_Paciente_Paciente1`
    FOREIGN KEY (`Paciente_id`)
    REFERENCES `mydb`.`Paciente` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;