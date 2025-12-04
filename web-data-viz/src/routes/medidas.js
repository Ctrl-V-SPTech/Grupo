// src/routes/medidas.js
var express = require("express");
var router = express.Router();

var medidaController = require("../controllers/medidaController");

// últimas medidas de um sensor específico da estufa
router.get("/ultimas/:idEstufa/:idSensor", function (req, res) {
  medidaController.buscarUltimasMedidas(req, res);
});

// tempo real de um sensor específico da estufa
router.get("/tempo-real/:idEstufa/:idSensor", function (req, res) {
  medidaController.buscarMedidasEmTempoReal(req, res);
});

// medidas atuais (última leitura) de TODOS os sensores da estufa
router.get("/estufa/:idEstufa/atuais", function (req, res) {
  medidaController.listarMedidasAtuaisPorEstufa(req, res);
});


module.exports = router;
