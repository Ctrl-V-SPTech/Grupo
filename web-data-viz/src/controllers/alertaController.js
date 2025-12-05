var alertaModel = require("../models/alertaModel");

function registrar(req, res) {
    var { alertaTemp, alertaUmid, fkSensorMedida, mensagem, dataHora } = req.body;

    alertaModel.registrar(alertaTemp, alertaUmid, fkSensorMedida, mensagem, dataHora)
        .then(resultado => res.json(resultado))
        .catch(erro => {
            console.error("Erro ao registrar alerta:", erro);
            res.status(500).json({ erro: erro.message });
        });
}

function listarPorSensor(req, res) {
    var idSensor = req.params.idSensor;
    alertaModel.listarPorSensor(idSensor)
        .then(resultado => res.json(resultado))
        .catch(erro => {
            console.error("Erro ao listar alertas:", erro);
            res.status(500).json({ erro: erro.message });
        });
}

function listarPorEstufa(req, res) {
    var idEstufa = req.params.idEstufa;

    alertaModel.listarPorEstufa(idEstufa)
        .then(resultado => res.json(resultado))
        .catch(erro => {
            console.error("Erro ao listar alertas por estufa:", erro);
            res.status(500).json({ erro: erro.message });
        });
}


module.exports = {
    registrar,
    listarPorSensor,
    listarPorEstufa
};
