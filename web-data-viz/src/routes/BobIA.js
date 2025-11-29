var express = require("express");
var router = express.Router();

var BobIAController = require("../controllers/BobIAController");

router.post("/perguntar", function (req, res) {
    BobIAController.perguntar(req, res)
});

module.exports = router;