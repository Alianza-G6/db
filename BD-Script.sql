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

INSERT INTO tbEmpresa (razaoSocial, siglaICAO, cnpj) VALUES
('ABAETE', 'ABJ', '14228178000154'),
('ATA BRASIL', 'ABZ', '04432348000104'),
('AIR MINAS', 'AMG', '05853938000122'),
('AZUL', 'AZU', '09296295000160'),
('BRASMEX', 'BCA', '10432228000157'),
('BETA', 'BET', '02671848000162'),
('TAM-TRANSPORTE AEREOS MERIDIONAIS', 'BLC', '92501072000160'),
('BRA', 'BRB', '01141392000132'),
('ITAPEMIRIM TRANSPORTES REGIONAIS SA', 'ITI', '34042788000167'),
('ITAPEMIRIM TRANSPORTES AEREOS S.A.', 'ITM', '31088059000183'),
('INTERBRASIL', 'ITB', '00189307000199'),
('GOL', 'GLO', '07575651000159'),
('MAP LINHAS AEREAS', 'PAM', '10480008000150'),
('PENTA', 'PEP', '10624466000108'),
('PUMA AIR', 'PLY', '08846856000152'),
('PASSAREDO', 'PTB', '01320867000179'),
('PANTANAL', 'PTN', '62276453000133'),
('RIO LINHAS AEREAS', 'RIO', '08518308000139'),
('RICO', 'RLE', '04911920000101'),
('SOL', 'SBA', '09145431000153'),
('SKYMASTER', 'SKC', '00673685000120'),
('SETE', 'SLX', '05256938000191'),
('AMÉRICA DO SUL LINHAS AÉREAS', 'SUL', '05253938000191'),
('TAM', 'TAM', '02012862000160'),
('TRANSBRASIL', 'TBA', '33222828000188'),
('TAF', 'TSD', '02614549000168'),
('TOTAL', 'TTL', '09458685000102'),
('ABSA', 'TUS', '67004223000166'),
('TAVAJ', 'TVJ', '09073989000168'),
('VARIG LOG', 'VLO', '02253387000162'),
('VRG LINHAS AÉREAS', 'VRG', '07572651000159'),
('VRG LINHAS AÉREAS', 'VRN', '09573739000101'),
('VASP', 'VSP', '61366751000170'),
('WEBJET', 'WEB', '09069570000187');

insert into tbTipoUsuario values
(1, 'Gerente'),
(2, 'Analista');


INSERT INTO tbUsuario (nome, cpf, email, senha, fkEmpresa, fkTipoUsuario) 
VALUES ('Fernanda', '12312312312', 'fernanda@gmail.com', '1212', 1, 1);


SELECT * FROM voo;
SELECT count(idVoo) as 'Quantidade De Voos' FROM voo;