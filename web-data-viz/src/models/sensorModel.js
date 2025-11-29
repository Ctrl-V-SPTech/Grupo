var database = require("../database/config");

function listarPorEstufa(idEstufa) {
    var instrucaoSql = `
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
ORDER BY s.idSensor;`;

    console.log("Executando a instrução SQL: \n" + instrucaoSql);
    return database.executar(instrucaoSql);
}

function listarTodos() {
    var instrucaoSql = `SELECT * FROM Sensor;`;
    console.log("Executando a instrução SQL: \n" + instrucaoSql);
    return database.executar(instrucaoSql);
}

module.exports = {
    listarPorEstufa,
    listarTodos
};
