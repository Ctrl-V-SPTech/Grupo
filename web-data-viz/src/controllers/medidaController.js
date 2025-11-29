// src/controllers/medidaController.js
var medidaModel = require("../models/medidaModel");

function buscarUltimasMedidas(req, res) {
    const limite_linhas = 7;

    var idEstufa = req.params.idEstufa;
    var idSensor = req.params.idSensor;

    console.log(`Recuperando as ultimas ${limite_linhas} medidas da estufa ${idEstufa}, sensor ${idSensor}`);

    medidaModel.buscarUltimasMedidas(idEstufa, idSensor, limite_linhas)
        .then(function (resultado) {
            if (resultado.length > 0) {
                res.status(200).json(resultado);
            } else {
                res.status(204).send("Nenhum resultado encontrado!");
            }
        })
        .catch(function (erro) {
            console.log(erro);
            console.log("Houve um erro ao buscar as ultimas medidas.", erro.sqlMessage);
            res.status(500).json(erro.sqlMessage);
        });
}

function buscarMedidasEmTempoReal(req, res) {
    var idEstufa = req.params.idEstufa;
    var idSensor = req.params.idSensor;

    console.log(`Recuperando medidas em tempo real da estufa ${idEstufa}, sensor ${idSensor}`);

    medidaModel.buscarMedidasEmTempoReal(idEstufa, idSensor)
        .then(function (resultado) {
            if (resultado.length > 0) {
                res.status(200).json(resultado);
            } else {
                res.status(204).send("Nenhum resultado encontrado!");
            }
        })
        .catch(function (erro) {
            console.log(erro);
            console.log("Houve um erro ao buscar medidas em tempo real.", erro.sqlMessage);
            res.status(500).json(erro.sqlMessage);
        });
}

function listarMedidasAtuaisPorEstufa(req, res) {
    var idEstufa = req.params.idEstufa;

    console.log(`Listando medidas atuais da estufa ${idEstufa}`);

    // AQUI é medidaModel (sem s)
    medidaModel.listarMedidasAtuaisPorEstufa(idEstufa)
        .then(function (resultado) {
            if (resultado.length > 0) {
                res.status(200).json(resultado);
            } else {
                res.status(204).send("Nenhuma medida encontrada");
            }
        })
        .catch(function (erro) {
            console.log("Erro ao listar medidas atuais:", erro.sqlMessage);
            res.status(500).json(erro.sqlMessage);
        });
}

module.exports = {
    buscarUltimasMedidas,
    buscarMedidasEmTempoReal,
    listarMedidasAtuaisPorEstufa
}
