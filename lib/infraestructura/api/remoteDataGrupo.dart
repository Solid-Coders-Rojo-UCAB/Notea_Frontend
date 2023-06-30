import 'dart:async';
import 'dart:convert';
import 'dart:core';

import 'package:http/http.dart' as http;
import 'package:notea_frontend/dominio/agregados/VOGrupo/nombreGrupo.dart';
import 'package:notea_frontend/dominio/agregados/grupo.dart';


import '../../api_config.dart';
import '../../dominio/agregados/VONota/EstadoEnum.dart';
import '../../dominio/agregados/nota.dart';
import '../../utils/Either.dart';
import '../conectivityChecker/checker.dart';

abstract class RemoteDataGrupo {
  Future<Either<List<Grupo>, Exception>> buscarGruposApi(String idUsuarioDueno);
  Future<Either<int, Exception>> crearGrupoApi(Map<String, dynamic> jsonString);
}

class RemoteDataGrupoImp implements RemoteDataGrupo {
  final http.Client client;
  RemoteDataGrupoImp({required this.client});

  @override
  Future<Either<List<Grupo>, Exception>> buscarGruposApi(String idUsuarioDueno) async {
    print('-entra en remoteDataGrupo');
    if (await const ConectivityCheck().checkConectivity()) {
      final response =
          await client.get(Uri.parse('${ApiConfig.apiBaseUrl}/grupo/usuario/$idUsuarioDueno'));

      if (response.statusCode == 200) {
        return Either.left(parseGrupo(response.body));
      } else {
        return Either.right(Exception("Error al buscar los grupos"));
      }
    } else {
      return  Either.right(Exception(
          "No hay conexion a internet")); //guardado en la base de datos local
    }
  }

  @override
  Future<Either<int, Exception>> crearGrupoApi(
      Map<String, dynamic> jsonString) async {
    if (await const ConectivityCheck().checkConectivity()) {
      final response = await client.post(
        Uri.parse('${ApiConfig.apiBaseUrl}/grupo'),
        body: jsonString,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      if (response.statusCode == 200) {
        return  Either.left(response.statusCode);
      } else {
        return  Either.right(Exception("Error al crear el grupo en el servidor"));
      }
    } else {
      return  Either.right(Exception(
          "No hay conexion a internet")); //guardado en la base de datos local
    }
  }

  List<Grupo> parseGrupo(String responseBody) {
    List<dynamic> decodedResponse = jsonDecode(responseBody);
    List<Grupo> grupos = [];
    for (var item in decodedResponse) {
      Grupo grupo = Grupo(idGrupo: item['id']['id'], nombre: VONombreGrupo(item['nombre']['nombre']), idUsuario: item['usuario']['id']);
      grupos.add(grupo);
      // TODO preguntar si esto se puede hacer
    }
    return grupos;
  }

}

