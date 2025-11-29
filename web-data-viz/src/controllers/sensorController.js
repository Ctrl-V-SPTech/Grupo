var sensorModel = require("../models/sensorModel");

function listarSensoresPorEstufa(req, res) {
    var idEstufa = req.params.idEstufa;

    sensorModel.listarPorEstufa(idEstufa)
        .then(resultado => {
            res.json(resultado);
        })
        .catch(erro => {
            console.error("Erro ao listar sensores: ", erro);
            res.status(500).json({ error: erro.message });
        });
}

module.exports = {
    listarSensoresPorEstufa
};
