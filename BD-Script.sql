CREATE database Alianza;

USE Alianza;

CREATE TABLE Funcionario (
    idFuncionario INT AUTO_INCREMENT PRIMARY KEY,
    Nome VARCHAR(50) NOT NULL,
    CPF CHAR(11) NOT NULL,
    Cargo VARCHAR(50) NOT NULL
);

CREATE TABLE Aeroporto (
    idAeroporto INT AUTO_INCREMENT PRIMARY KEY,
    Nome VARCHAR(45) NOT NULL,
    Sigla VARCHAR(45),
    CNPJ CHAR(14),
    CEP CHAR(9),
    Funcionario_idFuncionario INT,
    FOREIGN KEY (Funcionario_idFuncionario) REFERENCES Funcionario(idFuncionario)
);

CREATE TABLE Companhia (
    idCompanhia INT AUTO_INCREMENT PRIMARY KEY,
    Nome VARCHAR(45) NOT NULL,
    Sigla VARCHAR(45),
    CNPJ CHAR(14),
    Funcionario_idFuncionario INT,
    FOREIGN KEY (Funcionario_idFuncionario) REFERENCES Funcionario(idFuncionario)
);

CREATE TABLE Voo (
    idVoo INT AUTO_INCREMENT PRIMARY KEY,
    Companhia_idCompanhia INT,
    idAeroportoInicial INT,
    idAeroportoFinal INT,
    PrevChegada VARCHAR(45),
    Chegada VARCHAR(45),
    PrevSaida VARCHAR(45),
    Saida VARCHAR(45),
    SituacaoVoo VARCHAR(45),
    FOREIGN KEY (Companhia_idCompanhia) REFERENCES Companhia(idCompanhia),
    FOREIGN KEY (idAeroportoInicial) REFERENCES Aeroporto(idAeroporto),
    FOREIGN KEY (idAeroportoFinal) REFERENCES Aeroporto(idAeroporto)
);

-- Dados de testes

INSERT INTO Funcionario (Nome, CPF, Cargo) VALUES
('João Silva', '12345678901', 'Gerente de Aeroporto'),
('Maria Souza', '98765432100', 'Piloto'),
('Carlos Pereira', '11122233344', 'Gerente de Companhia');

INSERT INTO Aeroporto (Nome, Sigla, CNPJ, CEP, Funcionario_idFuncionario) VALUES
('Aeroporto Internacional de Guarulhos', 'GRU', '12345678000101', '07190000', 1),
('Aeroporto Internacional de Brasília', 'BSB', '98765432000102', '71608900', 1);

INSERT INTO Companhia (Nome, Sigla, CNPJ, Funcionario_idFuncionario) VALUES
('LATAM Airlines', 'LATAM', '11223344000199', 3),
('Gol Linhas Aéreas', 'GOL', '22334455000188', 3);

INSERT INTO Voo (Companhia_idCompanhia, idAeroportoInicial, idAeroportoFinal, PrevChegada, Chegada, PrevSaida, Saida, SituacaoVoo) VALUES
(1, 1, 2, '12:00', '12:15', '10:00', '10:05', 'Concluído'),
(2, 2, 1, '14:30', '14:50', '12:00', '12:10', 'Atrasado');
-- Fim da inserção de dados

-- Teste de selects
SELECT V.idVoo, 
	   C.Nome AS Companhia, 
       A1.Nome AS AeroportoSaida, 
       A2.Nome AS AeroportoChegada, 
       V.PrevSaida, V.Saida, V.PrevChegada, V.Chegada, V.SituacaoVoo
FROM Voo V
JOIN Companhia C ON V.Companhia_idCompanhia = C.idCompanhia
JOIN Aeroporto A1 ON V.idAeroportoInicial = A1.idAeroporto
JOIN Aeroporto A2 ON V.idAeroportoFinal = A2.idAeroporto;

SELECT F.Nome AS Funcionario, F.Cargo, A.Nome AS Aeroporto
FROM Funcionario F
JOIN Aeroporto A ON F.idFuncionario = A.Funcionario_idFuncionario
WHERE F.idFuncionario = 1;

SELECT F.Nome AS Funcionario, F.Cargo, C.Nome AS Companhia
FROM Funcionario F
JOIN Companhia C ON F.idFuncionario = C.Funcionario_idFuncionario
WHERE F.idFuncionario = 3;
-- Fim dos teste de select

-- Deletando dados mocados
SET SQL_SAFE_UPDATES = 0;
DELETE FROM Voo;
DELETE FROM Companhia;
DELETE FROM Aeroporto;
DELETE FROM Funcionario;
SET SQL_SAFE_UPDATES = 1;
