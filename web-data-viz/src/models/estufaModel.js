var database = require("../database/config");

function buscarEstufasPorEmpresa(idEmpresa) {

  var instrucaoSql = `SELECT * FROM Estufa WHERE fkEstufaEmpresa = ${idEmpresa}`;

  console.log("Executando a instrução SQL: \n" + instrucaoSql);
  return database.executar(instrucaoSql);
}

function cadastrar(idEmpresa, nomeEmpresa) {
  
  var instrucaoSql = `INSERT INTO (nomeEmpresa, fkEmpresa) Estufa VALUES (${nomeEmpresa}, ${idEmpresa})`;

  console.log("Executando a instrução SQL: \n" + instrucaoSql);
  return database.executar(instrucaoSql);
}
function obterFaseAtual(idEstufa) {
    var instrucaoSql = `
        SELECT periodoDesenvolvimento
        FROM Estufa
        WHERE idEstufa = ${idEstufa};
    `;
    console.log("Executando a instrução SQL: \n" + instrucaoSql);
    return database.executar(instrucaoSql);
}


module.exports = {
  buscarEstufasPorEmpresa,
  cadastrar,
  obterFaseAtual
}
