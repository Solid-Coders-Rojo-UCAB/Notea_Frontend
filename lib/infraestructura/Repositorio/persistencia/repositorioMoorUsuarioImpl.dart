// ignore_for_file: unnecessary_null_comparison

import 'dart:async';
import 'package:notea_frontend/dominio/agregados/usuario.dart';
import 'package:notea_frontend/dominio/agregados/usuario.dart';
import 'package:notea_frontend/dominio/repositorio/persistencia/repositorioPersistenciaUsuario.dart';

import '../../moor/moor_db.dart';

class MoorRepositorioUsuarioImpl extends RepositorioPersistenciaUsuario  {
  late NoteaDataBase noteaDatabase;
  // 2
  late UsuarioDao _usuarioDao;

  @override
  Future<List<Usuario>>  buscarUsuarios() {
    //1
    return _usuarioDao.findAllUsuarios()
      //2
      .then<List<Usuario>>((List<MoorUsuarioData> moorUsuarios) {

        final usuarios = <Usuario>[];
        //3
        moorUsuarios.forEach((moorUsuario) async {
          //4
          final usuario = moorUsuarioToUsuario(moorUsuario);
          //5
          usuarios.add(usuario);
        });
        return usuarios;
      }
    );
  }

  @override
  Future<Usuario?> buscarUsuarioPorId(String id) {
    return _usuarioDao.findUsuarioById(id).then((moorUsuario) {
      if (moorUsuario != null) {
        return moorUsuarioToUsuario(moorUsuario[0]);
      } else {
        return null;
      }
    });
  }

  @override
  Future<int> insertUsuario(Usuario usuario) {
    return Future(() async {
      final id = await _usuarioDao.insertUsuario(usuarioToInsertableMoorUsuario(usuario));
      return id;
    });
  }

  @override
  Future<void> deleteUsuario(Usuario usuario) {
    if (usuario.id != null) {
      return _usuarioDao.deleteUsuario(usuario.id);
    } else {
      return Future.value();
    }
  }

  @override
  Future<bool> updateUsuario(Usuario usuario){
    return Future(() async {
      final id = await _usuarioDao.updateUsuario(usuario.id, usuarioToInsertableMoorUsuario(usuario));
      return id;
    });
  }

  @override
  Future init() async {
    noteaDatabase = NoteaDataBase();
    _usuarioDao = noteaDatabase.usuarioDao;
  }

  @override
  void close() {
    noteaDatabase.close();
  }
}