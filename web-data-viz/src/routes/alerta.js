var express = require("express");
var router = express.Router();

var alertaController = require("../controllers/alertaController");

// Registrar um alerta
router.post("/registrar", function (req, res) {
    alertaController.registrar(req, res);
});

// Listar últimos 50 alertas
router.get("/listar", function (req, res) {
    alertaController.listar(req, res);
});

// Listar alertas por sensor (passar idSensor na URL)
router.get("/sensor/:idSensor", function (req, res) {
    alertaController.listarPorSensor(req, res);
});

router.get("/estufa/:idEstufa", function (req, res) {
    alertaController.listarPorEstufa(req, res);
});


module.exports = router;
