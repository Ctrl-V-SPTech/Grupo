// src/models/medidaModel.js
var database = require("../database/config");

function buscarUltimasMedidas(idEstufa, idSensor, limite_linhas) {
    var instrucaoSql = `
        SELECT 
            m.medidaUmid AS medidaUmid,
            m.medidaTemp AS medidaTemp,
            DATE_FORMAT(m.dataHora, '%d/%m %H:%i:%s') AS dataHora,
            s.fkEstufa,
            m.fkSensor 
        FROM Medida m
        JOIN Sensor s
            ON m.fkSensor = s.idSensor
        WHERE s.fkEstufa = ${idEstufa}
          AND m.fkSensor = ${idSensor}
        ORDER BY m.dataHora DESC
        LIMIT ${limite_linhas};
    `;

    console.log("Executando a instrução SQL: \n" + instrucaoSql);
    return database.executar(instrucaoSql);
}

function buscarMedidasEmTempoReal(idEstufa, idSensor) {
    var instrucaoSql = `
    SELECT 
    m.medidaUmid AS medidaUmid,
    m.medidaTemp AS medidaTemp,
    DATE_FORMAT(m.dataHora, '%d/%m %H:%i:%s') AS dataHora,
    s.fkEstufa,
    m.fkSensor
        FROM Medida m
        JOIN Sensor s
            ON m.fkSensor = s.idSensor
        WHERE s.fkEstufa = ${idEstufa}
          AND m.fkSensor = ${idSensor}
        ORDER BY m.idMedida DESC
        LIMIT 1;
    `;

    console.log("Executando a instrução SQL: \n" + instrucaoSql);
    return database.executar(instrucaoSql);
}

function listarMedidasAtuaisPorEstufa(idEstufa) {
    console.log("Acessando medidaModel listarMedidasAtuaisPorEstufa()");

    var instrucaoSql = `
        SELECT 
            s.idSensor,
            m.medidaUmid AS medidaUmid,
            m.medidaTemp AS medidaTemp,
            DATE_FORMAT(m.dataHora, '%d/%m %H:%i') AS dataHora
        FROM Sensor s
        JOIN Medida m 
            ON m.fkSensor = s.idSensor
        WHERE s.fkEstufa = ${idEstufa}
          AND m.idMedida = (
              SELECT MAX(m2.idMedida)
              FROM Medida m2
              WHERE m2.fkSensor = s.idSensor
          )
        ORDER BY s.idSensor;
    `;
    console.log("Executando instrução SQL:\n", instrucaoSql);

    return database.executar(instrucaoSql);
}

module.exports = {
    buscarUltimasMedidas,
    buscarMedidasEmTempoReal,
    listarMedidasAtuaisPorEstufa
}
