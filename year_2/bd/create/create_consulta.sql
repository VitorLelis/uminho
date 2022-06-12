CREATE TABLE IF NOT EXISTS `mydb`.`Nutricionista` (
  `email` VARCHAR(45) NOT NULL,
  `nome` VARCHAR(45) NOT NULL,
  `local_trabalho` VARCHAR(45) NOT NULL,
  `Supervisor_email` VARCHAR(45) NULL,
  PRIMARY KEY (`email`),
  INDEX `fk_Nutricionista_Nutricionista_idx` (`Supervisor_email` ASC) VISIBLE,
  CONSTRAINT `fk_Nutricionista_Nutricionista`
    FOREIGN KEY (`Supervisor_email`)
    REFERENCES `mydb`.`Nutricionista` (`email`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `mydb`.`Secretario` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `email` VARCHAR(45) NOT NULL,
  `nome` VARCHAR(45) NOT NULL,
  `Nutricionista_email` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_Secretario_Nutricionista1_idx` (`Nutricionista_email` ASC) VISIBLE,
  CONSTRAINT `fk_Secretario_Nutricionista1`
    FOREIGN KEY (`Nutricionista_email`)
    REFERENCES `mydb`.`Nutricionista` (`email`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `mydb`.`Paciente` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `nome` VARCHAR(45) NOT NULL,
  `email` VARCHAR(45) NOT NULL,
  `data_nascimento` DATE NOT NULL,
  `data_criacao` DATE NOT NULL,
  `foto` VARCHAR(45) NULL,
  `idade` INT GENERATED ALWAYS AS (timestampdiff(YEAR, `data_nascimento`, '2022-04-06')),
  `Nutricionista_email` VARCHAR(45) NOT NULL,
  `Secretario_id` INT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_Paciente_Nutricionista1_idx` (`Nutricionista_email` ASC) VISIBLE,
  INDEX `fk_Paciente_Secretario1_idx` (`Secretario_id` ASC) VISIBLE,
  CONSTRAINT `fk_Paciente_Nutricionista1`
    FOREIGN KEY (`Nutricionista_email`)
    REFERENCES `mydb`.`Nutricionista` (`email`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Paciente_Secretario1`
    FOREIGN KEY (`Secretario_id`)
    REFERENCES `mydb`.`Secretario` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `mydb`.`Consulta` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `data` DATE NOT NULL,
  `hora_inicio` TIME NOT NULL,
  `duracao_minutos` INT NOT NULL,
  `pago` TINYINT NOT NULL DEFAULT 0,
  `online` TINYINT NOT NULL DEFAULT 0,
  `Paciente_id` INT NOT NULL,
  `Nutricionista_email` VARCHAR(45) NOT NULL,
  `Secretario_id` INT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_Consulta_Paciente1_idx` (`Paciente_id` ASC) VISIBLE,
  INDEX `fk_Consulta_Nutricionista1_idx` (`Nutricionista_email` ASC) VISIBLE,
  INDEX `fk_Consulta_Secretario1_idx` (`Secretario_id` ASC) VISIBLE,
  CONSTRAINT `fk_Consulta_Paciente1`
    FOREIGN KEY (`Paciente_id`)
    REFERENCES `mydb`.`Paciente` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Consulta_Nutricionista1`
    FOREIGN KEY (`Nutricionista_email`)
    REFERENCES `mydb`.`Nutricionista` (`email`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Consulta_Secretario1`
    FOREIGN KEY (`Secretario_id`)
    REFERENCES `mydb`.`Secretario` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;