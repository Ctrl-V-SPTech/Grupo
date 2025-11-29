var database = require("../database/config");

function buscarPorId(idEmpresa) {
  var instrucaoSql = `SELECT * FROM empresa WHERE id = '${idEmpresa}'`;

  return database.executar(instrucaoSql);
}

function listar() {
  var instrucaoSql = `SELECT idEmpresa, nomeEmpresa, cnpj FROM empresa`;

  return database.executar(instrucaoSql);
}

function buscarPorCnpj(cnpj) {
  var instrucaoSql = `SELECT * FROM empresa WHERE cnpj = '${cnpj}'`;

  return database.executar(instrucaoSql);
}

function cadastrar(nomeEmpresa, cnpj) {
  var instrucaoSql = `INSERT INTO empresa (nomeEmpresa, cnpj) VALUES ('${nomeEmpresa}', '${cnpj}')`;

  return database.executar(instrucaoSql);
}

module.exports = { buscarPorCnpj, buscarPorId, cadastrar, listar };
