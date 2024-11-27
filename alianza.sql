DROP DATABASE IF EXISTS alianza;
CREATE DATABASE alianza;

USE alianza;

CREATE TABLE tbTipoEmpresa (
    idTipoEmpresa INT PRIMARY KEY AUTO_INCREMENT,
    tipo VARCHAR(45) -- Permite flexibilidade para diferentes tipos de empresas
);

CREATE TABLE tbEmpresa (
    idEmpresa INT PRIMARY KEY AUTO_INCREMENT,
    razaoSocial VARCHAR(100), -- Nomes de empresas podem ser mais longos
    siglaICAO VARCHAR(4), -- Sigla ICAO de companhias aéreas tem exatamente 3 caracteres
    cnpj CHAR(14) UNIQUE, -- CNPJ tem sempre 14 caracteres
    fkTipoEmpresa INT,
    FOREIGN KEY (fkTipoEmpresa) REFERENCES tbTipoEmpresa(idTipoEmpresa),
    empresaStatus ENUM('Ativa', 'Desativada') -- ENUM é mais eficiente que CHECK para valores limitados
);

CREATE TABLE tbCodigoEmpresa (
    idCodigo INT PRIMARY KEY AUTO_INCREMENT,
    fkEmpresa INT NOT NULL,
    codigo CHAR(8) NOT NULL, -- Ideal para códigos com tamanho fixo
    dataCriacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    dataExpiracao TIMESTAMP, -- Para códigos temporários
    FOREIGN KEY (fkEmpresa) REFERENCES tbEmpresa(idEmpresa)
);

CREATE TABLE tbTipoUsuario (
    idTipoUsuario INT PRIMARY KEY AUTO_INCREMENT,
    tipo VARCHAR(45) -- Para diferentes tipos de usuários
);

CREATE TABLE tbUsuario (
    idUsuario INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(50) NOT NULL,
    cpf CHAR(11) NOT NULL UNIQUE, -- CPF tem sempre 11 caracteres
    email VARCHAR(100) NOT NULL UNIQUE, -- Emails podem variar, mas o limite razoável é 100
    senha CHAR(64) NOT NULL, -- Senha encriptada geralmente usa hash fixo (ex.: SHA-256 = 64 caracteres)
    fkTipoUsuario INT,
    fkEmpresa INT,
    FOREIGN KEY (fkTipoUsuario) REFERENCES tbTipoUsuario(idTipoUsuario),
    FOREIGN KEY (fkEmpresa) REFERENCES tbEmpresa(idEmpresa)
);

CREATE TABLE tbCodigoUsuario (
    idCodigo INT PRIMARY KEY AUTO_INCREMENT,
    fkUsuario INT,
    codigo CHAR(4) NOT NULL, -- Códigos de usuário fixos para maior controle
    dataCriacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    dataExpiracao TIMESTAMP, -- Para códigos temporários
    FOREIGN KEY (fkUsuario) REFERENCES tbUsuario(idUsuario)
);

CREATE TABLE tbFeedback (
    idFeedback INT PRIMARY KEY AUTO_INCREMENT,
    resumo VARCHAR(100), -- Resumo pode ser mais curto
    feedback TEXT, -- Feedbacks podem ser longos, então `TEXT` é mais apropriado
    dataCriacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    fkUsuario INT,
    FOREIGN KEY (fkUsuario) REFERENCES tbUsuario(idUsuario)
);

CREATE TABLE tbAeroporto (
    idAeroporto INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(100), -- Nomes de aeroportos podem ser mais longos
    siglaICAO CHAR(4) -- Sigla ICAO de aeroportos tem exatamente 4 caracteres
);

CREATE TABLE tbCompanhia (
    idCompanhia INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(100), -- Nomes de companhias aéreas podem ser longos
    siglaICAO CHAR(3) -- Sigla ICAO de companhias aéreas tem exatamente 3 caracteres
);

CREATE TABLE voo (
    idVoo INT PRIMARY KEY AUTO_INCREMENT,
    fkCompanhia INT,
    FOREIGN KEY (fkCompanhia) REFERENCES tbCompanhia(idCompanhia),
    numeroVoo VARCHAR(10), -- Número de voo é geralmente curto, mas pode variar
    codigoDI CHAR(2), -- Código DI tem exatamente 2 caracteres
    codigoTipoLinha CHAR(2), -- Código tipo linha tem exatamente 2 caracteres
    fkAeroportoOrigem INT,
    FOREIGN KEY (fkAeroportoOrigem) REFERENCES tbAeroporto(idAeroporto),
    partidaPrevista DATETIME,
    partidaReal DATETIME,
    fkAeroportoDestino INT,
    FOREIGN KEY (fkAeroportoDestino) REFERENCES tbAeroporto(idAeroporto),
    chegadaPrevista DATETIME,
    chegadaReal DATETIME,
    StatusVoo ENUM('REALIZADO', 'CANCELADO', 'NÃO INFORMADO') -- Definição clara dos status de voo
);



-- INSERTS

INSERT INTO tbTipoEmpresa VALUES 
(1,'Companhia Aérea'),
(2,'Aeroporto'),
(3,'Outros');

INSERT INTO tbEmpresa (razaoSocial, siglaICAO, cnpj, empresaStatus) VALUES
('AAAAAA', 'AAA', '14228178000190', 'Ativa'),
('ALIANZA', null, '09988776655488', 'Ativa');

insert into tbTipoUsuario values
(1, 'Gerente'),
(2, 'Analista'),
(3, 'ADM');


INSERT INTO tbUsuario (nome, cpf, email, senha, fkEmpresa, fkTipoUsuario) 
VALUES ('Fernanda', '12312312312', 'fernanda@gmail.com', '1212', 1, 1);

INSERT INTO tbusuario (nome, cpf, email, senha, fkEmpresa, fkTipoUsuario)
VALUES ('Alianza', '09497715897', 'alianza.admin@gmail.com', '1212', 2, 3);


select * from tbEmpresa;
select * from tbUsuario;
select * from tbCompanhia;
select * from tbAeroporto;
select statusVoo from voo GROUP BY statusVoo;

