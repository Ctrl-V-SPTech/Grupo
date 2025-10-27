CREATE DATABASE CtrlV;


DROP DATABASE CtrlV;


USE CtrlV;

CREATE TABLE Empresa (
idEmpresa INT PRIMARY KEY AUTO_INCREMENT,
nomeEmpresa VARCHAR(45),
endereco VARCHAR(100),
cidade VARCHAR (45),
estado CHAR(2),
cnpj CHAR(18),
qtdSensores INT
);

CREATE TABLE Estufa (
idEstufa INT PRIMARY KEY AUTO_INCREMENT,
localizacaoEstufa VARCHAR(25),
	CONSTRAINT chkLocalizacao
		CHECK(localizacaoEstufa IN ('Estufa Norte', 'Estufa Sul', 'Estufa Leste', 'Estufa Oeste', 'Estufa Central')),
fkEstufaEmpresa INT,
	CONSTRAINT fkEmpresaEstufa
		FOREIGN KEY (fkEstufaEmpresa)
			REFERENCES Empresa(idEmpresa)
);

CREATE TABLE Responsavel (
idResponsavel INT PRIMARY KEY AUTO_INCREMENT,
nomeResponsavel VARCHAR(30),
email VARCHAR(45),
telefoneFixo CHAR(11),
telefoneCel CHAR(12),
fkEmpresa INT,
	CONSTRAINT fkResponsavelEmpresa
		FOREIGN KEY (fkEmpresa)
			REFERENCES Empresa(idEmpresa)
);

CREATE TABLE Sensor (
idSensor INT PRIMARY KEY AUTO_INCREMENT,
nomeSensor VARCHAR(20),
localizacaoSensor VARCHAR(25),
	CONSTRAINT chklocalizacaoSensor
		CHECK(localizacaoSensor IN ('Zona Norte', 'Zona Sul', 'Zona Lateral Direita', 'Zona Lateral Esquerda', 'Zona Central')),
fkEstufa INT,
	CONSTRAINT sensorEstufa
		FOREIGN KEY (fkEstufa)
			REFERENCES Estufa(idEstufa)
);

CREATE TABLE Medida (
idMedida INT AUTO_INCREMENT,
medidaTemp DECIMAL (4,2),
medidaUmid FLOAT,
fkSensor INT,
	CONSTRAINT fkMedidaSensor
		FOREIGN KEY (fkSensor)
			REFERENCES Sensor(idSensor),
	PRIMARY KEY (idMedida, fkSensor)
);
    
INSERT INTO Empresa (nomeEmpresa, endereco, cidade, estado, cnpj, qtdSensores) VALUES
	('Fabiano Uvas', 'Rua Haddock Lobo', 'São Paulo', 'SP', '12.345.678/0001-90', 6),
	('Cappellaro Fruits', 'Unnamed Road', 'Petrolina', 'PE', '18.519.610/0001-61', 3),
	('Dancruz Plantas', 'Rua Alto aguas Verdes - Aguas verdes', 'Rio do Oeste', 'SC', '29.200.566/0001-49', 8),
	('CEAGESP', 'Av. Dr. Gastão Vidigal', 'São Paulo', 'SP','62.463.005/0001-08', 10);
    
INSERT INTO Responsavel (nomeResponsavel, email, telefoneFixo, telefoneCel, fkEmpresa) VALUES
	('Fabiano', 'fabiano.silva@gmail.com', '922913-9201', '119912781907', 1),
	('José Bonifácio.', 'jose.bonifacio@gmail.com', '473143-2006', '819536728193', 2),
    ('Amanda Sapia', 'amanda.sapia@gmail.com', '767982-5464', '119772618367', 4),
	('Dantas', 'dantas.okamoto@gmail.com', NULL, '419076543617', 3);
    
INSERT INTO Estufa (localizacaoEstufa, fkEstufaEmpresa) VALUES 
	('Estufa Central', 1),
	('Estufa Sul', 2),
	('Estufa Oeste', 3),
	('Estufa Leste', 4);
    
INSERT INTO Sensor (localizacaoSensor, fkEstufa) VALUES
	('Zona Central', 1),
	('Zona Lateral Direita', 2),
	('Zona Norte', 3),
	('Zona Lateral Esquerda', 4);
    
INSERT INTO Medida (medidaTemp, medidaUmid, fkSensor) VALUES 
	('16.00', '0.60', 1),
	('25.00', '0.70', 2),
	('5.00', '0.94', 3),
	('34.00', '0.50', 4);
    
SELECT 
    e.nomeEmpresa AS 'Nome da Empresa',
    r.nomeResponsavel AS 'Nome do Responsável',
    CONCAT ('Telefone: ', r.telefoneCel, ' ', ' Email: ', r.email) AS 'Contato do Responsável',
    es.localizacaoEstufa AS 'Local da Estufa',
    s.localizacaoSensor AS 'Local do Sensor',
    m.medidaTemp AS 'Medida da Temperatura',
    m.medidaUmid AS 'Medida da Umidade',
    CASE 
        WHEN m.medidaTemp < 15 THEN 'Temperatura Abaixo da Faixa!'
        WHEN m.medidaTemp > 30 THEN 'Temperatura Acima da Faixa!'
        WHEN m.medidaUmid < 0.50 THEN 'Umidade Abaixo da Faixa!'
        WHEN m.medidaUmid > 0.95 THEN 'Umidade Acima da Faixa!'
        ELSE 'Dentro da Faixa Normal'
    END AS 'Status da Medida'
FROM Empresa e
JOIN Responsavel r 
    ON r.fkEmpresa = e.idEmpresa
JOIN Estufa es 
    ON es.fkEstufaEmpresa = e.idEmpresa
JOIN Sensor s 
    ON s.fkEstufa = es.idEstufa
JOIN Medida m 
    ON m.fkSensor = s.idSensor;
