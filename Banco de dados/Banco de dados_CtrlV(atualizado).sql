CREATE DATABASE CtrlV;

USE CtrlV;

-- CRIAÇÃO DA TABELA USUÁRIO PARA GUARDAR AS INFORMAÇÕES DE CADASTRO E LOGIN
CREATE TABLE Usuario(
idUsuario INT PRIMARY KEY AUTO_INCREMENT,
nome VARCHAR(45) NOT NULL,
email VARCHAR(45) NOT NULL UNIQUE,
telefone VARCHAR(20) UNIQUE,
cargoEmpresa VARCHAR(45)
);

-- CRIAÇÃO DA TABELA EMPRESAS QUE IRÁ ARMAZENAR OS DADOS DAS EMPRESAS QUE CONTRATARAM NOSSOS SERVIÇOS
CREATE TABLE Empresa(
idEmpresa INT PRIMARY KEY AUTO_INCREMENT,
nomeEmpresa VARCHAR (45) NOT NULL,
endereco VARCHAR(60) NOT NULL,
responsavel VARCHAR(45) NOT NULL,
cnpj CHAR(20) NOT NULL UNIQUE,
qtdSensores INT
);

-- CRIAÇÃO DA TABELA SENSOR QUE ARMAZENA A LOCALIZAÇÃO DOS SENSORES
CREATE TABLE Sensor (
idSensor INT pRIMARY KEY AUTO_INCREMENT,
localInstalacao VARCHAR(20),
fkEmpresa INT,
	CONSTRAINT fkSensorEmpresa
    FOREIGN KEY (fkEmpresa)
    REFERENCES Empresa(idEmpresa)
);


-- A TEBELA LEITURAS IRÁ ARMAZENAR AS LEITURAS FEITAS PELOS SENSORES
CREATE TABLE Leituras(
idLeitura INT PRIMARY KEY AUTO_INCREMENT,
temperatura DECIMAL(4,2),
umidade DECIMAL (4,2),
fkSensor INT,
	CONSTRAINT fkLeituraSensor
    FOREIGN KEY (fkSensor)
    REFERENCES Sensor(idSensor)
);


-- A TABELA ALERTA IRÁ COLETAR AS LEITURAS FEITAS PELO SENSOR E IRÁ DETERMINAR SE O ARMAZENAMENTO ESTÁ EM RISCO OU NÃO
CREATE TABLE Alertas(
idAlerta INT PRIMARY KEY AUTO_INCREMENT,
gravidade VARCHAR(25),
	CONSTRAINT chkGravidade
    CHECK(gravidade IN ('Baixa', 'Média', 'Alta')),
dataHora DATETIME DEFAULT CURRENT_TIMESTAMP,
fkLeitura INT,
	CONSTRAINT fkAlertaLeitura
    FOREIGN KEY (fkLeitura)
    REFERENCES Leituras (idLeitura),
fkUsuario INT,
	CONSTRAINT fkLeiturasUsuario
    FOREIGN KEY (fkUsuario)
    REFERENCES Usuario(idUsuario)
);

INSERT INTO Usuario (nome, email) VALUES
	('Everton', 'everton.silva@sptech.school'),
	('Giovana B.', 'giovana.branquinho@sptech.school'),
    ('João Sapia', 'joao.sapia@sptech.school'),
	('Larissa', 'larissa.okamoto@sptech.school'),
	('Leandro', 'leandro.asilvia@sptech.school'),
	('Sabrina', 'sabrina.araujo@sptech.school');
    
INSERT INTO Empresa (nomeEmpresa, endereco, responsavel, cnpj, qtdSensores) VALUES
	('Cappellaro Fruits', 'Unnamed Road, Petrolina - PE', 'Claudia Regina Ceccagno Cappellaro', '18.519.610/0001-61', 3),
	('Dancruz Plantas', 'Rua Alto aguas Verdes - Aguas verdes, Rio do Oeste - SC', 'Giovana Branquinho', '29.200.566/0001-49', 2),
	('CEAGESP', 'Av. Dr. Gastão Vidigal, 1946', 'José Lourenço Pechtoll', '62.463.005/0001-08', 1);
    
INSERT INTO Sensor (localInstalacao, fkEmpresa) VALUES
	('Estufa 1', 1),
	('Estufa 2', 1),
	('Estufa Central', 2),
	('Estufa', 3);
    
INSERT INTO Leituras (temperatura, umidade, fkSensor) VALUES 
	('16.00', '0.60', 1),
	('25.00', '0.70', 2),
	('5.00', '0.94', 3),
	('34.00', '0.50', 4);
    
INSERT INTO Alertas (gravidade, dataHora, fkLeitura) VALUES
	('Baixa', DEFAULT, 1),
	('Baixa', DEFAULT, 2),
	('Média', DEFAULT, 3),
	('Alta',  DEFAULT, 4);
    
SELECT Usuario.nome AS 'Nome do Usuário',
	   Usuario.email AS 'Email do Usuário',
       Usuario.telefone AS 'Contato do Usuário',
       Usuario.cargoEmpresa AS 'Cargo na Empresa'
       FROM Usuario;
       
       
       
SELECT Empresa.nomeEmpresa AS 'Nome da Empresa',
	   Empresa.responsavel AS 'Responsável da empresa',
       Empresa.endereco AS 'Endereço da Empresa',
       Empresa.cnpj AS 'CNPJ da Empresa',
       Empresa.qtdSensores AS 'Quantidades de sensores'
       FROM Empresa;
       
SELECT Sensor.idSensor AS 'Sensor',
	   Sensor.localInstalacao AS 'Localização do sensor',
	   Empresa.nomeEmpresa AS 'Empresa com o Sensor'
	   FROM Sensor
	   LEFT JOIN Empresa
       ON Sensor.fkEmpresa = Empresa.idEmpresa;
       
SELECT leituras.temperatura AS 'Temperatura',
	   leituras.umidade AS 'Umidade',
       leituras.fkSensor AS 'Sensor Da Captura'
       FROM Leituras
       LEFT JOIN Sensor
       ON leituras.fkSensor = Sensor.idSensor;
       
SELECT 
    Empresa.nomeEmpresa,
    CONCAT('Sensor em ', Sensor.localInstalacao) AS 'Local do Sensor',
    Leituras.temperatura AS 'Temperatura',
    Alertas.gravidade AS 'Gravidade do Alerta',
    CASE 
        WHEN Leituras.temperatura < 10 THEN 'Alerta'
        WHEN Leituras.temperatura BETWEEN 10 AND 25 THEN 'OK'
        ELSE 'Crescimento Retardado'
    END AS 'Classificação'
FROM Alertas
JOIN Leituras ON Alertas.fkLeitura = Leituras.idLeitura
JOIN Sensor ON Leituras.fkSensor = Sensor.idSensor
JOIN Empresa ON Sensor.fkEmpresa = Empresa.idEmpresa
WHERE Alertas.gravidade IN ('Média','Alta');