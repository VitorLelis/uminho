CREATE TABLE IF NOT EXISTS `mydb`.`PlanoAlimentar` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `atual` TINYINT NOT NULL DEFAULT 1,
  `data_criacao` DATE NOT NULL,
  `Paciente_id` INT NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_PlanoAlimentar_Paciente1_idx` (`Paciente_id` ASC) VISIBLE,
  CONSTRAINT `fk_PlanoAlimentar_Paciente1`
    FOREIGN KEY (`Paciente_id`)
    REFERENCES `mydb`.`Paciente` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `mydb`.`RecomendacaoPlanoAlimentar` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `descricao` INT NOT NULL,
  `categoria` VARCHAR(45) NOT NULL,
  `PlanoAlimentar_id` INT NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_RecomendacaoPlanoAlimentar_PlanoAlimentar1_idx` (`PlanoAlimentar_id` ASC) VISIBLE,
  CONSTRAINT `fk_RecomendacaoPlanoAlimentar_PlanoAlimentar1`
    FOREIGN KEY (`PlanoAlimentar_id`)
    REFERENCES `mydb`.`PlanoAlimentar` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `mydb`.`EtiquetaPlanoAlimentar` (
  `PlanoAlimentar_id` INT NOT NULL,
  `Etiqueta_id` INT NOT NULL,
  PRIMARY KEY (`PlanoAlimentar_id`, `Etiqueta_id`),
  INDEX `fk_PlanoAlimentar_has_Etiqueta_Etiqueta1_idx` (`Etiqueta_id` ASC) VISIBLE,
  INDEX `fk_PlanoAlimentar_has_Etiqueta_PlanoAlimentar1_idx` (`PlanoAlimentar_id` ASC) VISIBLE,
  CONSTRAINT `fk_PlanoAlimentar_has_Etiqueta_PlanoAlimentar1`
    FOREIGN KEY (`PlanoAlimentar_id`)
    REFERENCES `mydb`.`PlanoAlimentar` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_PlanoAlimentar_has_Etiqueta_Etiqueta1`
    FOREIGN KEY (`Etiqueta_id`)
    REFERENCES `mydb`.`Etiqueta` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `mydb`.`VersaoPlanoAlimentar` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `PlanoAlimentar_id` INT NOT NULL,
  INDEX `fk_VersaoPlanoAlimentar_PlanoAlimentar2_idx` (`PlanoAlimentar_id` ASC) VISIBLE,
  PRIMARY KEY (`id`),
  CONSTRAINT `fk_VersaoPlanoAlimentar_PlanoAlimentar2`
    FOREIGN KEY (`PlanoAlimentar_id`)
    REFERENCES `mydb`.`PlanoAlimentar` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `mydb`.`VersaoPlanoAlimentarDiaDaSemana` (
  `dia_da_semana` INT NOT NULL,
  `VersaoPlanoAlimentar_id` INT NOT NULL,
  PRIMARY KEY (`dia_da_semana`, `VersaoPlanoAlimentar_id`),
  INDEX `fk_VersaoPlanoAlimentarDiaDaSemana_VersaoPlanoAlimentar1_idx` (`VersaoPlanoAlimentar_id` ASC) VISIBLE,
  CONSTRAINT `fk_VersaoPlanoAlimentarDiaDaSemana_VersaoPlanoAlimentar1`
    FOREIGN KEY (`VersaoPlanoAlimentar_id`)
    REFERENCES `mydb`.`VersaoPlanoAlimentar` (`PlanoAlimentar_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `mydb`.`Refeicao` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `hora` TIME NOT NULL,
  `descricao` VARCHAR(45) NOT NULL,
  `VersaoPlanoAlimentar_id` INT NOT NULL,
  INDEX `fk_Refeicao_VersaoPlanoAlimentar1_idx` (`VersaoPlanoAlimentar_id` ASC) VISIBLE,
  PRIMARY KEY (`id`),
  CONSTRAINT `fk_Refeicao_VersaoPlanoAlimentar1`
    FOREIGN KEY (`VersaoPlanoAlimentar_id`)
    REFERENCES `mydb`.`VersaoPlanoAlimentar` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `mydb`.`ComponenteRefeicao` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `descricao` VARCHAR(45) NULL,
  `Refeicao_id` INT NOT NULL,
  PRIMARY KEY (`id`),
  CONSTRAINT `fk_ComponenteRefeicao_Refeicao1`
    FOREIGN KEY (`Refeicao_id`)
    REFERENCES `mydb`.`Refeicao` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `mydb`.`RecomendacaoAlimentar` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `descricao` TEXT NOT NULL,
  `ComponenteRefeicao_id` INT NOT NULL,
  PRIMARY KEY (`id`),
  CONSTRAINT `fk_RecomendacaoAlimentar_ComponenteRefeicao1`
    FOREIGN KEY (`ComponenteRefeicao_id`)
    REFERENCES `mydb`.`ComponenteRefeicao` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;