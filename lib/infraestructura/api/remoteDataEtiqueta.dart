import 'dart:async';
import 'dart:convert';
import 'dart:core';
import 'package:http/http.dart' as http;
import 'package:notea_frontend/dominio/agregados/VOEtiqueta/colorEtiqueta.dart';
import 'package:notea_frontend/dominio/agregados/VOEtiqueta/nombreEtiqueta.dart';
import 'package:notea_frontend/dominio/agregados/etiqueta.dart';

import '../../utils/Either.dart';
import '../../api_config.dart';
import '../conectivityChecker/checker.dart';

abstract class RemoteDataEtiqueta {
  Future<Either<List<Etiqueta>, Exception>> buscarEtiquetasApi(
      String idUsuarioDueno);
  Future<Either<int, Exception>> crearEtiquetaApi(
      Map<String, dynamic> jsonString);
  Future<Either<int, Exception>> deleteEtiquetaApi(String etiquetaId);
}

class RemoteDataEtiquetaImp implements RemoteDataEtiqueta {
  final http.Client client;
  RemoteDataEtiquetaImp({required this.client});

  @override
  Future<Either<List<Etiqueta>, Exception>> buscarEtiquetasApi(
      String idUsuarioDueno) async {
    if (await const ConectivityCheck().checkConectivity()) {
      final response = await client.get(
          Uri.parse('${ApiConfig.apiBaseUrl}/etiqueta/$idUsuarioDueno/all'));

      if (response.statusCode == 200) {
        return Either.left(parseEtiqueta(response.body));
      } else {
        return Either.right(Exception("Error al buscar los grupos"));
      }
    } else {
      return Either.right(Exception(
          "No hay conexion a internet")); //guardado en la base de datos local
    }
  }

  @override
  Future<Either<int, Exception>> crearEtiquetaApi(
      Map<String, dynamic> jsonString) async {
    if (await const ConectivityCheck().checkConectivity()) {
      print(jsonString);
      print(jsonEncode(jsonString));
      final response = await client.post(
        Uri.parse('${ApiConfig.apiBaseUrl}/etiqueta'),
        body: jsonEncode(jsonString),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      if (response.statusCode == 200) {
        return Either.left(response.statusCode);
      } else {
        return Either.right(
            Exception("Error al crear el grupo en el servidor"));
      }
    } else {
      return Either.right(Exception(
          "No hay conexion a internet")); //guardado en la base de datos local
    }
  }

  @override
  Future<Either<int, Exception>> deleteEtiquetaApi(String etiquetaId) async {
    if (await const ConectivityCheck().checkConectivity()) {

      final response = await client.delete(
        Uri.parse('${ApiConfig.apiBaseUrl}/etiqueta/$etiquetaId'),
      );
  
      if (response.statusCode == 200) {
        return Either.left(response.statusCode);
      } else {
        return Either.right(Exception("Error al eliminar la etiqueta"));
      }
    } else {
      return Either.right(Exception("No hay conexión a internet"));
    }
  }

  List<Etiqueta> parseEtiqueta(String responseBody) {
    List<dynamic> decodedResponse = jsonDecode(responseBody);
    List<Etiqueta> etiquetas = [];
    for (var item in decodedResponse) {
      Etiqueta etiqueta = Etiqueta(
        idEtiqueta: item['id']['id'],
        nombre: VONombreEtiqueta(item['nombre']['nombre']),
        color: VOColorEtiqueta(item['color']),
        idUsuario: item['usuarioId']['id'],
      );
      etiquetas.add(etiqueta);
    }
    return etiquetas;
  }
}
