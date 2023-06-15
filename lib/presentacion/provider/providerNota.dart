import 'dart:html';

import 'package:flutter/material.dart';
import 'package:notea_frontend/aplicacion/get_Notas.dart';
import 'package:notea_frontend/dominio/agregados/nota.dart';

import '../../infraestructura/Repositorio/repositorioNotaImpl.dart';
import '../../infraestructura/api/remoteDataNota.dart';

import 'package:http/http.dart' as http;




class NotaProvider extends ChangeNotifier{

final GetNotas getNotesAnswer = GetNotas(RepositorioNotaImpl(
  remoteDataSource: RemoteDataNotaImp(client: http.Client()),
));

  List<Nota> notes = [];


  Future<void> getNotas() async{
    print('Esta ENTRANDO - NOTAS');
    final notesAnswer = await getNotesAnswer.repository.buscarNotas();
    print(notesAnswer);
    print('Esta SALIENDO - NOTAS');
    // notes = [];
    // notes.addAll();
    // notifyListeners();
  }

}