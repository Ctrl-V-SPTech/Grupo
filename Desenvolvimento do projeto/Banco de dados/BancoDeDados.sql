CREATE DATABASE CtrlV;

USE CtrlV;

CREATE TABLE Endereco (
idEndereco INT PRIMARY KEY AUTO_INCREMENT,
logradouro VARCHAR(45) NOT NULL,
numero INT NOT NULL,
bairro VARCHAR(20) NOT NULL,
cidade VARCHAR (25) NOT NULL,
estado CHAR(2) NOT NULL,
cep CHAR(9) NOT NULL
);

CREATE TABLE Empresa (
idEmpresa INT PRIMARY KEY AUTO_INCREMENT,
nomeEmpresa VARCHAR(45),
cnpj CHAR(18),
fkEndereco INT,
	CONSTRAINT fkEnderecoEmpresa
		FOREIGN KEY (fkEndereco)
			REFERENCES Endereco(idEndereco)
);

CREATE TABLE Usuario (
idUsuario INT PRIMARY KEY AUTO_INCREMENT,
nomeUsuario VARCHAR(30),
email VARCHAR(45),
senhaUsuario VARCHAR(45),
fkEmpresa INT,
	CONSTRAINT fkResponsavelEmpresa
		FOREIGN KEY (fkEmpresa)
			REFERENCES Empresa(idEmpresa),
fkUsuarioResponsavel INT,
	CONSTRAINT fkResponsavel
		FOREIGN KEY (fkUsuarioResponsavel)
			REFERENCES Usuario(idUsuario)
);

CREATE TABLE Estufa (
idEstufa INT PRIMARY KEY AUTO_INCREMENT,
nomeEstufa VARCHAR(30),
periodoDesenvolvimento VARCHAR(15),
	CONSTRAINT chkPeriodo
		CHECK (periodoDesenvolvimento IN('Brotação', 'Floração', 'Crescimento', 'Maturação', 'Colheita', 'Dormência')),
fkEstufaEmpresa INT,
	CONSTRAINT fkEmpresaEstufa
		FOREIGN KEY (fkEstufaEmpresa)
			REFERENCES Empresa(idEmpresa)
);

CREATE TABLE Sensor (
idSensor INT PRIMARY KEY AUTO_INCREMENT,
nomeSensor VARCHAR(20),
localizacaoSensor VARCHAR(25),
	CONSTRAINT chklocalizacaoSensor
		CHECK(localizacaoSensor IN ('Zona Leste', 'Zona Oeste', 'Zona Central')),
fkEstufa INT,
	CONSTRAINT sensorEstufa
		FOREIGN KEY (fkEstufa)
			REFERENCES Estufa(idEstufa)
);

CREATE TABLE Medida (
idMedida INT AUTO_INCREMENT,
medidaTemp DECIMAL (4,2),
medidaUmid FLOAT,
dataHora DATETIME DEFAULT CURRENT_TIMESTAMP,
fkSensor INT,
	CONSTRAINT fkMedidaSensor
		FOREIGN KEY (fkSensor)
			REFERENCES Sensor(idSensor),
	PRIMARY KEY (idMedida, fkSensor)
);

CREATE TABLE Alerta (
    idAlerta INT AUTO_INCREMENT,
    AlertaTemp VARCHAR(10),
    CONSTRAINT chkStatusTemp CHECK(AlertaTemp IN('CRÍTICO', 'MODERADO')),
    AlertaUmid VARCHAR(10),
    CONSTRAINT chkStatusUmid CHECK(AlertaUmid IN('CRÍTICO', 'MODERADO')),
    dtHrInicialAlerta DATETIME DEFAULT CURRENT_TIMESTAMP,
    dtHrFinalAlerta DATETIME DEFAULT CURRENT_TIMESTAMP,
    fkSensorMedida INT,
    CONSTRAINT fkMSensorMedida
        FOREIGN KEY (fkSensorMedida)
            REFERENCES Sensor(idSensor),
    PRIMARY KEY (idAlerta, fkSensorMedida)
);
    
INSERT Endereco (logradouro, numero, bairro, cidade, estado, cep) VALUES
	('Rua Haddock Lobo', 2000, 'Cerqueira César', 'São Paulo', 'SP', '01414-010'),
    ('Unnamed Road', 52, 'Vila Arara-Azul', 'Petrolina', 'PE', '56300-992'),
    ('Rua Alto aguas Verdes', 298, 'Águas verdes', 'Rio do Oeste', 'SC', '89180-000'),
    ('Av. Dr. Gastão Vidigal', 1597, 'Vila Leopoldina','São Paulo', 'SP', '05314-010');
    
INSERT INTO Empresa (nomeEmpresa, cnpj, fkEndereco) VALUES
	('Fabiano Uvas', '12.345.678/0001-90', 1),
	('Cappellaro Fruits', '18.519.610/0001-61', 2),
	('Dancruz Plantas', '29.200.566/0001-49', 3),
	('CEAGESP', '62.463.005/0001-08', 4);
    
INSERT INTO Usuario (nomeUsuario, email, senhaUsuario, fkEmpresa, fkUsuarioResponsavel) VALUES
	('Fabiano', 'fabiano.silva@gmail.com', '1234@5678', 1, NULL),
	('José Bonifácio.', 'jose.bonifacio@gmail.com', 'joseLindoMarilhoso@123', 2, NULL),
    ('Amanda Sapia', 'amanda.sapia@gmail.com', 'urubu100', 4, NULL),
	('Dantas', 'dantas.okamoto@gmail.com', 'urubu200',3, NULL),
    ('Samara Santos', 'samara.sa@gmail.com', 'urubu300', 1, 4),
    ('Cleiton Rasta', 'cleiton.rasta@gamil.com', 'urubu400',2, 3),
    ('Larissa Araujo', 'larissaArjo@gmail.com', 'urubu500',3, 2),
    ('Bianca Azevedo', 'bianca.zevedo@gmail.com', 'urubu600',4, 1);
    
INSERT INTO Estufa (nomeEstufa, periodoDesenvolvimento,fkEstufaEmpresa) VALUES 
	('Estufa Central', 'Brotação', 1),
	('Estufa Sul', 'Floração', 2),
	('Estufa Oeste', 'Maturação', 3),
	('Estufa Leste', 'Dormência', 4);
    
INSERT INTO Sensor (localizacaoSensor, fkEstufa) VALUES
	('Zona Central', 1),
	('Zona Leste', 2),
	('Zona Central', 3),
	('Zona Oeste', 4);
    
INSERT INTO Alerta (alertaTemp, alertaUmid, dtHrInicialAlerta, dtHrFinalAlerta, fkSensorMedida) VALUES
    ('CRÍTICO', NULL, '2025-11-06 08:00:00', '2025-11-06 9:30:00', 1),
    (NULL, 'CRÍTICO', '2025-11-06 09:15:00', '2025-11-06 10:45:00', 2),
    ('MODERADO', NULL, '2025-11-06 07:00:00', '2025-11-06 08:10:00', 3);


SELECT 
	e.nomeEmpresa AS 'Nome da Empresa',
	r.nomeUsuario AS 'UsuárioAdm',  
    u.nomeUsuario AS 'Usuário',
    CONCAT('Email: ', r.email) AS 'Contato do Responsável',
    es.nomeEstufa AS 'Nome da Estufa',
    s.localizacaoSensor AS 'Local do Sensor',
    m.medidaTemp AS 'Medida da Temperatura',
    m.medidaUmid AS 'Medida da Umidade',
    m.dataHora AS 'Data e Hora da Medida',
    IFNULL(a.AlertaTemp, 'Ok') AS 'Status de Temperatura',
    IFNULL(a.AlertaUmid, 'Ok') AS 'Status de Umidade',
    DATE_FORMAT(SEC_TO_TIME(TIMESTAMPDIFF(SECOND, a.dtHrInicialAlerta, a.dtHrFinalAlerta)), '%H:%i') AS 'Tempo em Alerta',
    CASE 
		WHEN es.periodoDesenvolvimento = 'Brotação' AND m.medidaTemp < 15 OR m.medidaTemp > 25 THEN 'Temperatura Fora do ideal para a Brotação!'
        WHEN es.periodoDesenvolvimento = 'Crescimento' AND m.medidaTemp < 20 OR m.medidaTemp > 25 THEN 'Temperatura Fora do ideal para o Crescimento dos Bagos!'
        WHEN es.periodoDesenvolvimento = 'Dormência' AND m.medidaTemp < 5 OR m.medidaTemp > 15 THEN 'Temperatura Fora do ideal para o periodo de Dormência!'
        WHEN es.periodoDesenvolvimento = 'Floração' AND m.medidaTemp < 18 OR m.medidaTemp > 25 THEN 'Temperatura Fora do ideal para a Floração!'
        WHEN es.periodoDesenvolvimento = 'Maturação' AND m.medidaTemp < 20 OR m.medidaTemp > 30 THEN 'Temperatura Fora do ideal para a Maturação!'
        WHEN es.periodoDesenvolvimento = 'Colheita' AND m.medidaTemp < 10 OR m.medidaTemp > 20 THEN 'Temperatura Fora do ideal para a Colheita!'
        WHEN es.periodoDesenvolvimento = 'Brotação' AND m.medidaUmid < 0.60 OR m.medidaUmid > 0.80 THEN 'Umidade Fora do ideal para a Brotação!'
        WHEN es.periodoDesenvolvimento = 'Crescimento' AND m.medidaUmid < 0.60 OR m.medidaUmid > 0.80 THEN 'Umidade Fora do ideal para o Crescimento dos Bagos!'
        WHEN es.periodoDesenvolvimento = 'Dormência' AND m.medidaUmid < 0.50 OR m.medidaUmid > 0.70 THEN 'Umidade Fora do ideal para a Dormência!'
        WHEN es.periodoDesenvolvimento = 'Floração' AND m.medidaUmid < 0.50 OR m.medidaUmid > 0.70 THEN 'Umidade Fora do ideal para a Floração!'
        WHEN es.periodoDesenvolvimento = 'Maturação' AND m.medidaUmid < 0.40 OR m.medidaUmid > 0.60 THEN 'Umidade Fora do ideal para a Maturação!'
        WHEN es.periodoDesenvolvimento = 'Colheita' AND m.medidaUmid < 0.80 OR m.medidaUmid > 0.90 THEN 'Umidade Fora do ideal para a Colheita!'
        ELSE 'Dentro da Faixa Normal'
    END AS 'Status da Medida'
FROM Empresa e
JOIN Usuario u 
    ON u.fkEmpresa = e.idEmpresa
JOIN Usuario r 
    ON u.fkUsuarioResponsavel = r.idUsuario
JOIN Estufa es 
    ON es.fkEstufaEmpresa = e.idEmpresa
JOIN Sensor s 
    ON s.fkEstufa = es.idEstufa
JOIN Medida m 
    ON m.fkSensor = s.idSensor
LEFT JOIN Alerta a
	ON a.fkSensorMedida = s.idSensor;

CREATE VIEW vw_alertas AS 
	SELECT
	e.nomeEmpresa AS 'Nome da Empresa',
	r.nomeUsuario AS 'UsuárioAdm',  
    u.nomeUsuario AS 'Usuário',
    CONCAT('Email: ', r.email) AS 'Contato do Responsável',
    es.nomeEstufa AS 'Nome da Estufa',
    s.localizacaoSensor AS 'Local do Sensor',
    m.medidaTemp AS 'Medida da Temperatura',
    m.medidaUmid AS 'Medida da Umidade',
    m.dataHora AS 'Data e Hora da Medida',
    IFNULL(a.AlertaTemp, 'Ok') AS 'Status de Temperatura',
    IFNULL(a.AlertaUmid, 'Ok') AS 'Status de Umidade',
    DATE_FORMAT(SEC_TO_TIME(TIMESTAMPDIFF(SECOND, a.dtHrInicialAlerta, a.dtHrFinalAlerta)), '%H:%i') AS 'Tempo em Alerta',
    CASE 
		WHEN es.periodoDesenvolvimento = 'Brotação' AND m.medidaTemp < 15 OR m.medidaTemp > 25 THEN 'Temperatura Fora do ideal para a Brotação!'
        WHEN es.periodoDesenvolvimento = 'Crescimento' AND m.medidaTemp < 20 OR m.medidaTemp > 25 THEN 'Temperatura Fora do ideal para o Crescimento dos Bagos!'
        WHEN es.periodoDesenvolvimento = 'Dormência' AND m.medidaTemp < 5 OR m.medidaTemp > 15 THEN 'Temperatura Fora do ideal para o periodo de Dormência!'
        WHEN es.periodoDesenvolvimento = 'Floração' AND m.medidaTemp < 18 OR m.medidaTemp > 25 THEN 'Temperatura Fora do ideal para a Floração!'
        WHEN es.periodoDesenvolvimento = 'Maturação' AND m.medidaTemp < 20 OR m.medidaTemp > 30 THEN 'Temperatura Fora do ideal para a Maturação!'
        WHEN es.periodoDesenvolvimento = 'Colheita' AND m.medidaTemp < 10 OR m.medidaTemp > 20 THEN 'Temperatura Fora do ideal para a Colheita!'
        WHEN es.periodoDesenvolvimento = 'Brotação' AND m.medidaUmid < 0.60 OR m.medidaUmid > 0.80 THEN 'Umidade Fora do ideal para a Brotação!'
        WHEN es.periodoDesenvolvimento = 'Crescimento' AND m.medidaUmid < 0.60 OR m.medidaUmid > 0.80 THEN 'Umidade Fora do ideal para o Crescimento dos Bagos!'
        WHEN es.periodoDesenvolvimento = 'Dormência' AND m.medidaUmid < 0.50 OR m.medidaUmid > 0.70 THEN 'Umidade Fora do ideal para a Dormência!'
        WHEN es.periodoDesenvolvimento = 'Floração' AND m.medidaUmid < 0.50 OR m.medidaUmid > 0.70 THEN 'Umidade Fora do ideal para a Floração!'
        WHEN es.periodoDesenvolvimento = 'Maturação' AND m.medidaUmid < 0.40 OR m.medidaUmid > 0.60 THEN 'Umidade Fora do ideal para a Maturação!'
        WHEN es.periodoDesenvolvimento = 'Colheita' AND m.medidaUmid < 0.80 OR m.medidaUmid > 0.90 THEN 'Umidade Fora do ideal para a Colheita!'
        ELSE 'Dentro da Faixa Normal'
    END AS 'Status da Medida'
FROM Empresa e
JOIN Usuario u 
    ON u.fkEmpresa = e.idEmpresa
JOIN Usuario r 
    ON u.fkUsuarioResponsavel = r.idUsuario
JOIN Estufa es 
    ON es.fkEstufaEmpresa = e.idEmpresa
JOIN Sensor s 
    ON s.fkEstufa = es.idEstufa
JOIN Medida m 
    ON m.fkSensor = s.idSensor
LEFT JOIN Alerta a
	ON a.fkSensorMedida = s.idSensor;

select * from vw_alertas;