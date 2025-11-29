var database = require("../database/config");

function obterDataHoraMySQL() {
    const agora = new Date();
    const ano = agora.getFullYear();
    const mes = String(agora.getMonth() + 1).padStart(2, "0");
    const dia = String(agora.getDate()).padStart(2, "0");
    const hora = String(agora.getHours()).padStart(2, "0");
    const min = String(agora.getMinutes()).padStart(2, "0");
    const seg = String(agora.getSeconds()).padStart(2, "0");

    return `${ano}-${mes}-${dia} ${hora}:${min}:${seg}`;
}

// Registrar alerta
function registrar(alertaTemp, alertaUmid, fkSensorMedida, mensagem, dataHora) {
    const dtHr = dataHora && typeof dataHora === "string" ? dataHora : obterDataHoraMySQL();

    const instrucaoSql = `
        INSERT INTO Alerta
            (AlertaTemp, AlertaUmid, fkSensorMedida, Mensagem, dtHrInicialAlerta)
        VALUES ('${alertaTemp}', '${alertaUmid}', ${fkSensorMedida}, '${mensagem}', '${dtHr}');
    `;

    console.log("Executando a instrução SQL: \n" + instrucaoSql);
    return database.executar(instrucaoSql);
}

// Listar alertas
function listar(limite = 50) {
    const instrucaoSql = `
        SELECT * FROM Alerta
        ORDER BY dtHrInicialAlerta DESC
        LIMIT ${limite};
    `;
    console.log("Executando a instrução SQL: \n" + instrucaoSql);
    return database.executar(instrucaoSql);
}

// Listar alertas por sensor
function listarPorSensor(idSensor) {
    const instrucaoSql = `
        SELECT *
        FROM Alerta
        WHERE fkSensorMedida = ${idSensor}
          AND (AlertaTemp IN ('MODERADO','CRÍTICO') OR AlertaUmid IN ('MODERADO','CRÍTICO'))
        ORDER BY dtHrInicialAlerta DESC;
    `;
    console.log("Executando a instrução SQL: \n" + instrucaoSql);
    return database.executar(instrucaoSql);
}

module.exports = {
    registrar,
    listar,
    listarPorSensor
};
