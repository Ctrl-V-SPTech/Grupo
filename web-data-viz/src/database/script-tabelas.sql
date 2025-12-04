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
nome VARCHAR(30),
email VARCHAR(45),
senha VARCHAR(45),
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
    AlertaUmid VARCHAR(10),
    mensagem VARCHAR(255) NULL,
    dtHrInicialAlerta DATETIME DEFAULT CURRENT_TIMESTAMP,
    dtHrFinalAlerta DATETIME DEFAULT CURRENT_TIMESTAMP,
    fkSensorMedida INT,
    CONSTRAINT fkMSensorMedida
        FOREIGN KEY (fkSensorMedida)
            REFERENCES Sensor(idSensor),
    PRIMARY KEY (idAlerta, fkSensorMedida)
);

CREATE TABLE aviso (
	idAviso INT PRIMARY KEY AUTO_INCREMENT,
	titulo VARCHAR(100),
	descricao VARCHAR(150),
	fkUsuario INT,
	FOREIGN KEY (fkUsuario) REFERENCES usuario(idUsuario)
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
    
INSERT INTO Usuario (nome, email, senha, fkEmpresa, fkUsuarioResponsavel) VALUES
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
	('Zona Leste', 1),
    ('Zona Leste', 1),
    ('Zona Leste', 1),
    ('Zona Leste', 1),
    ('Zona Leste', 1),
	('Zona Central', 1),
    ('Zona Central', 1),
    ('Zona Central', 1),
    ('Zona Central', 1),
	('Zona Oeste', 1),
    ('Zona Oeste', 1),
    ('Zona Oeste', 1),
    ('Zona Oeste', 1),
    ('Zona Oeste', 1);

SELECT * FROM estufa WHERE fkEmpresa = 1;

CREATE EVENT inserir_medidas_automaticamente
ON SCHEDULE EVERY 5 SECOND
STARTS CURRENT_TIMESTAMP
DO
INSERT INTO Medida (
    medidaTemp,
    medidaUmid,
    fkSensor
) VALUES (
    20 + (RAND() * 10),  
    40 + (RAND() * 40), 
    1                  
);


drop EVENT inserir_medidas_automaticamente;

CREATE EVENT inserir_medidas_automaticamente_varios_mesmo_mesmo
ON SCHEDULE EVERY 5 SECOND
STARTS CURRENT_TIMESTAMP
DO
INSERT INTO Medida (medidaTemp, medidaUmid, fkSensor)
VALUES
    (20 + (RAND() * 10), 40 + (RAND() * 40), 1),
    (20 + (RAND() * 10), 40 + (RAND() * 40), 2),
    (20 + (RAND() * 10), 40 + (RAND() * 40), 3);

    DELIMITER $$

CREATE EVENT atualizar_fase_uva_uva
ON SCHEDULE EVERY 20 SECOND
STARTS CURRENT_TIMESTAMP
DO
BEGIN
    UPDATE estufa
    SET periodoDesenvolvimento = CASE periodoDesenvolvimento
        WHEN 'Dormência' THEN 'Brotação'
        WHEN 'Brotação' THEN 'Floração'
        WHEN 'Floração' THEN 'Crescimento'
        WHEN 'Crescimento' THEN 'Maturação'
        WHEN 'Maturação' THEN 'Colheita'
        WHEN 'Colheita' THEN 'Dormência'
        ELSE 'Dormência'
    END;
END $$

DELIMITER ;

SELECT 
    s.idSensor,
    s.nomeSensor,
    s.localizacaoSensor,
    m.medidaTemp,
    m.medidaUmid,
    DATE_FORMAT(m.dataHora, '%d/%m %H:%i') AS dataHora
FROM Sensor s
LEFT JOIN Medida m
    ON m.idMedida = (
        SELECT MAX(idMedida)
        FROM Medida
        WHERE fkSensor = s.idSensor
    )
ORDER BY s.idSensor;

SELECT *
FROM Medida
ORDER BY idMedida DESC
LIMIT 10;

SELECT * FROM alerta;

SET GLOBAL event_scheduler = ON;
SHOW EVENTS FROM CtrlV;
SELECT * from alerta;




