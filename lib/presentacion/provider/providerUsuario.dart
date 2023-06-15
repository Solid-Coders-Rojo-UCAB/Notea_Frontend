import 'dart:html';

import 'package:flutter/material.dart';
import 'package:notea_frontend/aplicacion/get_Usuarios.dart';
import 'package:notea_frontend/dominio/agregados/usuario.dart';
import 'package:notea_frontend/infraestructura/Repositorio/repositorioUsuarioImpl.dart';
import 'package:notea_frontend/infraestructura/api/remoteDataUsuario.dart';


import 'package:http/http.dart' as http;




class UsuarioProvider extends ChangeNotifier{

  final GetUsuarios getUsuariosAnswer = GetUsuarios(RepositorioUsuarioImpl(
    remoteDataSource: RemoteDataUsuarioImp(client: http.Client()),
  ));

  List<Usuario> usuarios = [];


  Future<void> getUsuarios() async{
    final usuariosAnswer = await getUsuariosAnswer.repository.buscarUsuario();
    print(usuariosAnswer);

    // usuarios = [];
    // usuarios.addAll();
    // notifyListeners();
  }

}