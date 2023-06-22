import 'dart:async';
import 'dart:convert';
import 'dart:core';

import 'package:http/http.dart' as http;


import '../../dominio/agregados/VONota/EstadoEnum.dart';
import '../../dominio/agregados/nota.dart';
import '../../utils/Either.dart';
import '../conectivityChecker/checker.dart';

abstract class RemoteDataNota {
  Future<Either<List<Nota>, Exception>> buscarNotasApi();
  Future<Either<int, Exception>> crearNotaApi(Map<String, dynamic> jsonString);
}

class RemoteDataNotaImp implements RemoteDataNota {
  final http.Client client;
  RemoteDataNotaImp({required this.client});

  @override
  Future<Either<List<Nota>, Exception>> buscarNotasApi() async {
    if (await const ConectivityCheck().checkConectivity()) {
      final response =
          await client.get(Uri.parse('http://localhost:3000/nota/all'));
      if (response.statusCode == 200) {
        return Either.left(parseNota(response.body));
      } else {
        return Either.right(Exception("Error al buscar las notas"));
      }
    } else {
      return  Either.right(Exception(
          "No hay conexion a internet")); //guardado en la base de datos local
    }
  }

  @override
  Future<Either<int, Exception>> crearNotaApi(
      Map<String, dynamic> jsonString) async {
    if (await const ConectivityCheck().checkConectivity()) {
      final response = await client.post(
        Uri.parse('http://localhost:3000/nota'),
        body: jsonString,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      if (response.statusCode == 200) {
        return  Either.left(response.statusCode);
      } else {
        return  Either.right(Exception("Error al crear la nota en el servidor"));
      }
    } else {
      return  Either.right(Exception(
          "No hay conexion a internet")); //guardado en la base de datos local
    }
  }

 List<Nota> parseNota(String responseBody) {

    List<dynamic> jsonMap = jsonDecode(responseBody);

    // iteramos por cada valor de la lista y creamos un objeto Nota para cada valor.
    List<Nota> notas = jsonMap.map((value) => Nota.fromJson(value)).toList();

    return notas;
 }

}

