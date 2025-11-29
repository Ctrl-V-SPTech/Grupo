var express = require('express');
var router = express.Router();
var sensorController = require('../controllers/sensorController');

// Rota para pegar sensores de uma estufa
router.get('/estufa/:idEstufa', sensorController.listarSensoresPorEstufa);

module.exports = router;
