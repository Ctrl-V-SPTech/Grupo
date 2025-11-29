var estufaModel = require("../models/estufaModel");

function buscarEstufasPorEmpresa(req, res) {
  var idUsuario = req.params.idUsuario;

  estufaModel.buscarEstufasPorEmpresa(idUsuario).then((resultado) => {
    if (resultado.length > 0) {
      res.status(200).json(resultado);
    } else {
      res.status(204).json([]);
    }
  }).catch(function (erro) {
    console.log(erro);
    console.log("Houve um erro ao buscar as estufas: ", erro.sqlMessage);
    res.status(500).json(erro.sqlMessage);
  });
}


function cadastrar(req, res) {
  var nomeEmpresa = req.body.descricao;
  var idUsuario = req.body.idUsuario;

  if (nomeEmpresa == undefined) {
    res.status(400).send("nomeEmpresa está undefined!");
  } else if (idUsuario == undefined) {
    res.status(400).send("idUsuario está undefined!");
  } else {


    estufaModel.cadastrar(nomeEmpresa, idUsuario)
      .then((resultado) => {
        res.status(201).json(resultado);
      }
      ).catch((erro) => {
        console.log(erro);
        console.log(
          "\nHouve um erro ao realizar o cadastro! Erro: ",
          erro.sqlMessage
        );
        res.status(500).json(erro.sqlMessage);
      });
  }
}
var estufaModel = require("../models/estufaModel");

function obterFaseAtual(req, res) {
    var idEstufa = req.params.idEstufa;

    estufaModel.obterFaseAtual(idEstufa)
        .then(resultado => {
            if (resultado.length === 0) {
                res.status(404).json("Estufa não encontrada");
            } else {
                res.status(200).json(resultado[0]);
            }
        })
        .catch(erro => {
            console.log("Erro ao obter fase da estufa:", erro);
            res.status(500).json(erro);
        });
}

module.exports = {
  buscarEstufasPorEmpresa,
  cadastrar,
  obterFaseAtual
}