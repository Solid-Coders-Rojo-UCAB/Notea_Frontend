// ignore_for_file: unnecessary_null_comparison

import 'dart:async';
import 'package:notea_frontend/dominio/agregados/nota.dart';
import 'package:notea_frontend/dominio/repositorio/persistencia/repositorioPersistenciaNota.dart';

import '../../moor/moor_db.dart';

class MoorRepositorioNotaImpl extends RepositorioPersistenciaNota  {
  late NoteaDataBase noteaDatabase;
  // 2
  late NotaDao _notaDao;

  @override
  Future<List<Nota>>  buscarNotas() {
    //1
    return _notaDao.findAllNotas()
      //2
      .then<List<Nota>>((List<MoorNotaData> moorNotas) {

        final notas = <Nota>[];
        //3
        moorNotas.forEach((moorNota) async {
          //4
          final nota = moorNotaToNota(moorNota);
          //5
          notas.add(nota);
        });
        return notas;
      }
    );
  }

  @override
  Future<Nota?> buscarNotaPorId(String id) {
    return _notaDao.findNotaById(id).then((moorNota) {
      if (moorNota != null) {
        return moorNotaToNota(moorNota[0]);
      } else {
        return null;
      }
    });
  }

  @override
  Future<int> insertNota(Nota nota) {
    return Future(() async {
      final id = await _notaDao.insertNota(notaToInsertableMoorNota(nota));
      return id;
    });
  }

  @override
  Future<void> deleteNota(Nota nota) {
    if (nota.id != null) {
      return _notaDao.deleteNota(nota.id);
    } else {
      return Future.value();
    }
  }

  @override
  Future<bool> updateNota(Nota nota){
    return Future(() async {
      final id = await _notaDao.updateNota(nota.id, notaToInsertableMoorNota(nota));
      return id;
    });
  }

  @override
  Future init() async {
    noteaDatabase = NoteaDataBase();
    _notaDao = noteaDatabase.notaDao;
  }

  @override
  void close() {
    noteaDatabase.close();
  }
}