DROP DATABASE IF EXISTS alianza;
CREATE DATABASE alianza;

USE alianza;

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
    fkEmpresa INT,
    FOREIGN KEY (fkTipoEmpresa) REFERENCES tbTipoEmpresa(idTipoEmpresa),
    empresaStatus VARCHAR(20),
    CHECK (empresaStatus IN ('Ativa', 'Desativada'))
);

CREATE TABLE tbCodigoEmpresa (
    idCodigo INT PRIMARY KEY AUTO_INCREMENT,
    fkEmpresa INT NOT NULL,
    codigo VARCHAR(55) NOT NULL,
    dataCriacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    dataExpiracao TIMESTAMP, -- Para códigos temporários
    FOREIGN KEY (fkEmpresa) REFERENCES tbEmpresa(idEmpresa)
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

CREATE TABLE tbCodigoUsuario (
    idCodigo INT PRIMARY KEY AUTO_INCREMENT,
    fkUsuario INT NOT NULL,
    codigo VARCHAR(55) NOT NULL,
    dataCriacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    dataExpiracao TIMESTAMP, -- Para códigos temporários
    FOREIGN KEY (fkUsuario) REFERENCES tbUsuario(idUsuario)
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
(2, 'Analista'),
(3, 'ADM');


INSERT INTO tbUsuario (nome, cpf, email, senha, fkEmpresa, fkTipoUsuario) 
VALUES ('Fernanda', '12312312312', 'fernanda@gmail.com', '1212', 1, 1);
INSERT INTO tbusuario (nome, cpf, email, senha, fkEmpresa, fkTipoUsuario)
VALUES ('Ellen', '09497715897', 'ellen.admin@gmail.com', '1212', 1, 3);


SELECT * FROM voo;
SELECT count(idVoo) as 'Quantidade De Voos' FROM voo;
SELECT * from tbUsuario;

-- média de atrasos por voo de uma companhia aerea especifica
SELECT 
    c.nome,  -- Nome da companhia aérea
    round(AVG(TIMESTAMPDIFF(MINUTE, p.partidaPrevista, p.partidaReal)), 2) AS mediaAtraso
FROM 
    voo p
JOIN 
    tbCompanhia c ON p.fkCompanhia = c.idCompanhia
WHERE 
    p.fkCompanhia = 1  -- Aqui você coloca o id da companhia que você deseja
    AND p.partidaReal IS NOT NULL
    AND p.partidaPrevista IS NOT NULL
GROUP BY 
    c.nome;
    
    
-- percentual de voos atrasados dessa companhia
SELECT 
    c.nome,
    round((COUNT(CASE 
              WHEN TIMESTAMPDIFF(MINUTE, p.partidaPrevista, p.partidaReal) > 0 THEN 1
              ELSE NULL
          END) / COUNT(p.idVoo)) * 100, 2) AS percentualAtrasados
FROM 
    voo p
JOIN 
    tbCompanhia c ON p.fkCompanhia = c.idCompanhia
WHERE 
    p.fkCompanhia = 9 -- Aqui você coloca o id da companhia que você deseja
    AND p.partidaReal IS NOT NULL
    AND p.partidaPrevista IS NOT NULL
GROUP BY 
    c.nome;


-- percentual voos pontuais
SELECT 
    c.nome,
    round((COUNT(CASE 
              WHEN TIMESTAMPDIFF(MINUTE, p.partidaPrevista, p.partidaReal) = 0 THEN 1
              ELSE NULL
          END) / COUNT(p.idVoo)) * 100, 2) AS percentualPontuais
FROM 
    voo p
JOIN 
    tbCompanhia c ON p.fkCompanhia = c.idCompanhia
WHERE 
    p.fkCompanhia = 1  -- Aqui você coloca o id da companhia que você deseja
    AND p.partidaReal IS NOT NULL
    AND p.partidaPrevista IS NOT NULL
GROUP BY 
    c.nome;


-- numero de rotas problematicas

SELECT 
    COUNT(*) AS quantidadeAtrasos
FROM 
    voo p
WHERE 
    TIMESTAMPDIFF(MINUTE, p.partidaPrevista, p.partidaReal) > 30  -- Atraso na partida
    AND TIMESTAMPDIFF(MINUTE, p.chegadaPrevista, p.chegadaReal) > 30
    AND fkCompanhia = 10 -- Atraso na chegada
GROUP BY 
    p.fkCompanhia
HAVING 
    COUNT(*) > 1;  -- Considera a rota como problemática se houver mais de um atraso


--  listar todas as rotas problemáticas agupada pelos seus dadose mostrando a quantidade de vezes que essa rota deu problema

SELECT 
    p.numeroVoo, 
    p.fkCompanhia,
    c.siglaICAO AS companhia, 
    p.fkAeroportoOrigem,
    o.siglaICAO AS aeroportoOrigem,
    p.fkAeroportoDestino,
    d.siglaICAO AS aeroportoDestino,
    COUNT(*) AS quantidadeAtrasos,
    ROUND(AVG(TIMESTAMPDIFF(MINUTE, p.partidaPrevista, p.partidaReal)), 0) AS mediaAtrasoPartida,
    ROUND(AVG(TIMESTAMPDIFF(MINUTE, p.chegadaPrevista, p.chegadaReal)), 0) AS mediaAtrasoChegada
FROM 
    voo p
JOIN 
    tbCompanhia c ON p.fkCompanhia = c.idCompanhia
JOIN 
    tbAeroporto o ON p.fkAeroportoOrigem = o.idAeroporto
JOIN 
    tbAeroporto d ON p.fkAeroportoDestino = d.idAeroporto
WHERE 
    TIMESTAMPDIFF(MINUTE, p.partidaPrevista, p.partidaReal) > 30  -- Atraso na partida
    AND TIMESTAMPDIFF(MINUTE, p.chegadaPrevista, p.chegadaReal) > 30  -- Atraso na chegada
    AND fkCompanhia = 1  -- ID da companhia específica
GROUP BY 
    p.numeroVoo, p.fkCompanhia, c.siglaICAO, p.fkAeroportoOrigem, o.siglaICAO, 
    p.fkAeroportoDestino, d.siglaICAO
HAVING 
    COUNT(*) > 1  -- Considera a rota como problemática se houver mais de um atraso
ORDER BY 
    quantidadeAtrasos DESC;

    

SELECT 
    c.nome AS nomeCompanhia,  -- Nome da companhia aérea
    ROUND(AVG(GREATEST(TIMESTAMPDIFF(MINUTE, p.partidaPrevista, p.partidaReal), 0)), 2) AS mediaAtraso
FROM 
    voo p
JOIN 
    tbCompanhia c ON p.fkCompanhia = c.idCompanhia
WHERE 
    p.fkCompanhia = 1  -- ID da companhia que você deseja
    AND p.partidaReal IS NOT NULL
    AND p.partidaPrevista IS NOT NULL
GROUP BY 
    c.nome;


SELECT 
    c.nome AS nomeCompanhia,
    ROUND(
        AVG(
            CASE WHEN TIMESTAMPDIFF(MINUTE, p.partidaPrevista, p.partidaReal) > 0 
                THEN TIMESTAMPDIFF(MINUTE, p.partidaPrevista, p.partidaReal) 
                ELSE 0 
            END +
            CASE WHEN TIMESTAMPDIFF(MINUTE, p.chegadaPrevista, p.chegadaReal) > 0 
                THEN TIMESTAMPDIFF(MINUTE, p.chegadaPrevista, p.chegadaReal) 
                ELSE 0 
            END
        ), 2
    ) AS mediaAtraso
FROM 
    voo p
JOIN 
    tbCompanhia c ON p.fkCompanhia = c.idCompanhia
WHERE 
    p.fkCompanhia = 1  -- Especifique o ID da companhia desejada
    AND p.partidaReal IS NOT NULL
    AND p.partidaPrevista IS NOT NULL
    AND p.chegadaReal IS NOT NULL
    AND p.chegadaPrevista IS NOT NULL
GROUP BY 
    c.nome;

-- atraso na saida
SELECT 
    c.nome AS nomeCompanhia,
    ROUND(AVG(
        CASE 
            WHEN TIMESTAMPDIFF(SECOND, p.partidaPrevista, p.partidaReal) > 0 
                THEN TIMESTAMPDIFF(SECOND, p.partidaPrevista, p.partidaReal) 
            ELSE 0 
        END
    ), 2) AS mediaAtrasoPartida
FROM 
    voo p
JOIN 
    tbCompanhia c ON p.fkCompanhia = c.idCompanhia
WHERE 
    p.fkCompanhia = 1  -- ID da companhia desejada
    AND p.partidaReal IS NOT NULL
    AND p.partidaPrevista IS NOT NULL
GROUP BY 
    c.nome;



-- atraso da chegada
SELECT 
    c.nome AS nomeCompanhia,
    ROUND(AVG(
        CASE 
            WHEN TIMESTAMPDIFF(MINUTE, p.chegadaPrevista, p.chegadaReal) > 0 
                THEN TIMESTAMPDIFF(MINUTE, p.chegadaPrevista, p.chegadaReal) 
            ELSE 0 
        END
    ), 2) AS mediaAtrasoChegada
FROM 
    voo p
JOIN 
    tbCompanhia c ON p.fkCompanhia = c.idCompanhia
WHERE 
    p.fkCompanhia = 1  -- ID da companhia desejada
    AND p.chegadaReal IS NOT NULL
    AND p.chegadaPrevista IS NOT NULL
GROUP BY 
    c.nome;
    
    
    
    
    SELECT 
    p.numeroVoo,
    p.fkCompanhia,
    c.siglaICAO AS companhia, 
    p.fkAeroportoOrigem,
    o.siglaICAO AS aeroportoOrigem,
    p.fkAeroportoDestino,
    d.siglaICAO AS aeroportoDestino,
    p.partidaPrevista,
    p.partidaReal,
    p.chegadaPrevista,
    p.chegadaReal,
    TIMESTAMPDIFF(MINUTE, p.partidaPrevista, p.partidaReal) AS atrasoPartida,
    TIMESTAMPDIFF(MINUTE, p.chegadaPrevista, p.chegadaReal) AS atrasoChegada,
    -- Cálculo do status do voo
    CASE 
        WHEN p.partidaReal IS NULL AND p.chegadaReal IS NULL THEN 'Cancelado'
        WHEN TIMESTAMPDIFF(MINUTE, p.partidaPrevista, p.partidaReal) > 30 
             OR TIMESTAMPDIFF(MINUTE, p.chegadaPrevista, p.chegadaReal) > 30 THEN 'Atrasado'
        ELSE 'Pontual'
    END AS statusVoo
FROM 
    voo p
JOIN 
    tbCompanhia c ON p.fkCompanhia = c.idCompanhia
JOIN 
    tbAeroporto o ON p.fkAeroportoOrigem = o.idAeroporto
JOIN 
    tbAeroporto d ON p.fkAeroportoDestino = d.idAeroporto
WHERE 
     p.numeroVoo = '904'  -- Substitua pelo número do voo desejado
    AND DATE(p.partidaPrevista) = '2022-11-01'  -- Substitua pela data desejada
ORDER BY 
    p.partidaPrevista ASC;

