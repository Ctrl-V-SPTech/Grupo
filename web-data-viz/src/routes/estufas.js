var express = require("express");
var router = express.Router();

var estufaController = require("../controllers/estufaController");

router.get("/:idEmpresa", function (req, res) {
  estufaController.buscarEstufasPorEmpresa(req, res);
});

router.post("/cadastrar", function (req, res) {
  estufaController.cadastrar(req, res);
})

router.get("/:idEstufa/fase-atual", function(req, res) {
    estufaController.obterFaseAtual(req, res);
});

module.exports = router;