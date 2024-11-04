-- DROP DATABASE Alianza;
CREATE DATABASE Alianza;

USE Alianza;
select * from tbUsuario;

CREATE TABLE tbTipoEmpresa (
    idTipoEmpresa INT PRIMARY KEY AUTO_INCREMENT,
    tipo VARCHAR(45)
);

CREATE TABLE tbEmpresa (
    idEmpresa INT PRIMARY KEY AUTO_INCREMENT,
    razaoSocial VARCHAR(45),
    siglaICAO VARCHAR(100),
    cnpj CHAR(14) UNIQUE,
    fkTipoEmpresa INT,
    FOREIGN KEY (fkTipoEmpresa) REFERENCES tbTipoEmpresa(idTipoEmpresa),
    codigoAtivacao varchar(55),
    empresaStatus VARCHAR(20),
    CHECK (empresaStatus IN ('Ativa', 'Desativada'))
);

CREATE TABLE tbTipoUsuario (
    idTipoUsuario INT PRIMARY KEY AUTO_INCREMENT,
    tipo VARCHAR(45)
);

CREATE TABLE tbUsuario (
    idUsuario INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(50) NOT NULL,
    cpf CHAR(11) NOT NULL UNIQUE,
    email VARCHAR(50) NOT NULL UNIQUE,
    senha VARCHAR(10) NOT NULL,
    fkTipoUsuario INT,
    fkEmpresa INT,
    FOREIGN KEY (fkTipoUsuario) REFERENCES tbTipoUsuario(idTipoUsuario),
    FOREIGN KEY (fkEmpresa) REFERENCES tbEmpresa(idEmpresa)
);

CREATE TABLE tbFeedback (
	idFeedback INT PRIMARY KEY AUTO_INCREMENT,
    resumo VARCHAR(100),
	feedback VARCHAR(500),
	dataCriacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    fkUsuario INT,
    FOREIGN KEY(fkUsuario) REFERENCES tbUsuario(idUsuario)
);		

CREATE TABLE tbAeroporto (
    idAeroporto INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(45),
    siglaICAO VARCHAR(100)
);

-- Tabela de companhias aéreas
CREATE TABLE tbCompanhia (
    idCompanhia INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(45),
    siglaICAO VARCHAR(100)
);

CREATE TABLE voo (
    idVoo INT PRIMARY KEY AUTO_INCREMENT,
    fkCompanhia INT,
    FOREIGN KEY (fkCompanhia) REFERENCES tbCompanhia(idCompanhia),
    numeroVoo VARCHAR(100),
    codigoDI CHAR(100),
    codigoTipoLinha CHAR(100),
    fkAeroportoOrigem INT,
    FOREIGN KEY (fkAeroportoOrigem) REFERENCES tbAeroporto(idAeroporto),
    partidaPrevista DATETIME,
    partidaReal DATETIME,
    fkAeroportoDestino INT,
    FOREIGN KEY (fkAeroportoDestino) REFERENCES tbAeroporto(idAeroporto),
    chegadaPrevista DATETIME,
    chegadaReal DATETIME,
    StatusVoo VARCHAR(45)
);


-- INSERTS

-- DROP DATABASE Alianza;
CREATE DATABASE Alianza;

USE Alianza;

CREATE TABLE tbTipoEmpresa (
    idTipoEmpresa INT PRIMARY KEY AUTO_INCREMENT,
    tipo VARCHAR(45)
);

CREATE TABLE tbEmpresa (
    idEmpresa INT PRIMARY KEY AUTO_INCREMENT,
    razaoSocial VARCHAR(45),
    siglaICAO VARCHAR(100),
    cnpj CHAR(14) UNIQUE,
    fkTipoEmpresa INT,
    FOREIGN KEY (fkTipoEmpresa) REFERENCES tbTipoEmpresa(idTipoEmpresa),
    codigoAtivacao varchar(55),
    empresaStatus VARCHAR(20),
    CHECK (empresaStatus IN ('Ativa', 'Desativada'))
);

CREATE TABLE tbTipoUsuario (
    idTipoUsuario INT PRIMARY KEY AUTO_INCREMENT,
    tipo VARCHAR(45)
);

CREATE TABLE tbUsuario (
    idUsuario INT PRIMARY KEY AUTO_INCREMENT,
    Nome VARCHAR(50) NOT NULL,
    CPF CHAR(11) NOT NULL UNIQUE,
    Email VARCHAR(50) NOT NULL UNIQUE,
    Senha VARCHAR(10) NOT NULL,
    fkTipoUsuario INT,
    fkEmpresa INT,
    FOREIGN KEY (fkTipoUsuario) REFERENCES tbTipoUsuario(idTipoUsuario),
    FOREIGN KEY (fkEmpresa) REFERENCES tbEmpresa(idEmpresa)
);

CREATE TABLE tbFeedback (
	idFeedback INT PRIMARY KEY AUTO_INCREMENT,
    resumo VARCHAR(100),
	feedback VARCHAR(500),
	dataCriacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    fkUsuario INT,
    FOREIGN KEY(fkUsuario) REFERENCES tbUsuario(idUsuario)
);		

CREATE TABLE tbAeroporto (
    idAeroporto INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(45),
    siglaICAO VARCHAR(100)
);

-- Tabela de companhias aéreas
CREATE TABLE tbCompanhia (
    idCompanhia INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(45),
    siglaICAO VARCHAR(100)
);

CREATE TABLE voo (
    idVoo INT PRIMARY KEY AUTO_INCREMENT,
    fkCompanhia INT,
    FOREIGN KEY (fkCompanhia) REFERENCES tbCompanhia(idCompanhia),
    numeroVoo VARCHAR(100),
    codigoDI CHAR(100),
    codigoTipoLinha CHAR(100),
    fkAeroportoOrigem INT,
    FOREIGN KEY (fkAeroportoOrigem) REFERENCES tbAeroporto(idAeroporto),
    partidaPrevista DATETIME,
    partidaReal DATETIME,
    fkAeroportoDestino INT,
    FOREIGN KEY (fkAeroportoDestino) REFERENCES tbAeroporto(idAeroporto),
    chegadaPrevista DATETIME,
    chegadaReal DATETIME,
    StatusVoo VARCHAR(45)
);


-- INSERTS
INSERT INTO tbTipoEmpresa VALUES 
(1,'Companhia Aérea'),
(2,'Aeroporto'),
(3,'Outros');

INSERT INTO tbEmpresa (razaoSocial, siglaICAO, cnpj, codigoAtivacao, empresaStatus) VALUES
('AAAAAA', 'AAA', '14228178000190', '123123123', 'Ativa');

insert into tbTipoUsuario values
(1, 'Gerente'),
(2, 'Analista');


INSERT INTO tbUsuario (nome, cpf, email, senha, fkEmpresa, fkTipoUsuario) 
VALUES ('Fernanda', '12312312312', 'fernanda@gmail.com', '1212', 1, 1);


SELECT * FROM voo;
SELECT count(idVoo) as 'Quantidade De Voos' FROM voo;