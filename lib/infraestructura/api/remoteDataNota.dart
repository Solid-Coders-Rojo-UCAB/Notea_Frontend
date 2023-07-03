import 'dart:convert';
import 'dart:core';
import 'dart:io';
import 'package:async/async.dart';

import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:notea_frontend/dominio/agregados/VONota/VOContenidoNota.dart';
import 'package:notea_frontend/dominio/agregados/VONota/VOTituloNota.dart';
import 'package:notea_frontend/dominio/agregados/VONota/VOUbicacionNota.dart';
import 'package:notea_frontend/dominio/agregados/VONota/VOidGrupo.dart';
import 'package:notea_frontend/dominio/agregados/grupo.dart';

import '../../api_config.dart';
import '../../dominio/agregados/VONota/EstadoEnum.dart';
import '../../dominio/agregados/nota.dart';
import '../../utils/Either.dart';
import '../conectivityChecker/checker.dart';

abstract class RemoteDataNota {
  Future<Either<List<Nota>, Exception>> buscarNotasApi();
  crearNotaApi(Map<String, dynamic> jsonString, List<File> listaImages);
  Future<Either<int, Exception>> changeStateNotaApi(
      Map<String, dynamic> jsonString);
  Future<Either<int, Exception>> borrarNotaApi(Map<String, dynamic> jsonString);
}

class RemoteDataNotaImp implements RemoteDataNota {
  final http.Client client;
  RemoteDataNotaImp({required this.client});

  @override
  Future<Either<List<Nota>, Exception>> buscarNotasApi() async {
    if (await const ConectivityCheck().checkConectivity()) {
      final response = await client.get(Uri.parse(
          '${ApiConfig.apiBaseUrl}/nota/all')); //Creo que esto no es lo mejor, porque treemos todas las notas
      if (response.statusCode == 200) {
        return Either.left(parseNota(response.body));
      } else {
        return Either.right(Exception("Error al buscar las notas"));
      }
    } else {
      return Either.right(Exception(
          "No hay conexion a internet")); //guardado en la base de datos local
    }
  }

  Future<Either<List<Nota>, Exception>> buscarNotasByUserApi(
      List<String> grupos) async {
    if (await const ConectivityCheck().checkConectivity()) {
      final response = await http.patch(
        Uri.parse('${ApiConfig.apiBaseUrl}/nota/grupos'),
        body: jsonEncode(grupos),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      ); //Creo que esto no es lo mejor, porque treemos todas las notas
      if (response.statusCode == 200) {
        return Either.left(parseNota(response.body));
      } else {
        return Either.right(Exception("Error al buscar las notas"));
      }
    } else {
      return Either.right(Exception(
          "No hay conexion a internet")); //guardado en la base de datos local
    }
  }

  Future<Either<int, Exception>> crearNotaApiTareas(
      Map<String, dynamic> jsonString) async {
    if (await const ConectivityCheck().checkConectivity()) {
      final response = await http.post(
        Uri.parse('${ApiConfig.apiBaseUrl}/nota'),
        body: json.encode(jsonString),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        return Either.left(response.statusCode);
      } else {
        return Either.right(Exception("Error al crear la nota en el servidor"));
      }
    } else {
      return Either.right(Exception(
          "No hay conexion a internet")); //guardado en la base de datos local
    }
  }

  @override
  Future<Either<int, Exception>> crearNotaApi(
      Map<String, dynamic> jsonString, List<File> listaImages) async {
    if (await const ConectivityCheck().checkConectivity()) {
      final request = http.MultipartRequest(
          'POST', Uri.parse('${ApiConfig.apiBaseUrl}/nota'))
        ..fields['titulo'] = jsonString['titulo']
        ..fields['contenido'] = jsonString['contenido']
        ..fields['fechaCreacion'] = jsonString['fechaCreacion'].toString()
        ..fields['latitud'] = jsonString['latitud']
        ..fields['longitud'] = jsonString['longitud'];

      // for (var item in listaImages) {
      //   // open a bytestream
      //   var stream = item.readAsBytes().asStream();
      //   // get file length
      //   var length = item.lengthSync();
      //   request.files.add(MultipartFile('imagen',stream,length, filename: item.path));
      // }
      final response = await request.send();

      if (response.statusCode == 200) {
        return Either.left(response.statusCode);
      } else {
        return Either.right(Exception("Error al crear la nota en el servidor"));
      }
    } else {
      return Either.right(Exception(
          "No hay conexion a internet")); //guardado en la base de datos local
    }
  }

  @override
  Future<Either<int, Exception>> changeStateNotaApi(
      Map<String, dynamic> jsonString) async {
    if (await const ConectivityCheck().checkConectivity()) {
      final response = await client.patch(
        Uri.parse('${ApiConfig.apiBaseUrl}/nota/cambiarEstado'),
        body: jsonEncode(jsonString),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      if (response.statusCode == 200) {
        return Either.left(response.statusCode);
      } else {
        return Either.right(
            Exception("Error al modificar la nota en el servidor"));
      }
    } else {
      return Either.right(Exception(
          "No hay conexion a internet")); //guardado en la base de datos local
    }
  }

  @override
  Future<Either<int, Exception>> borrarNotaApi(
      //para eliminar nota de la papelera permanentemente
      Map<String, dynamic> jsonString) async {
    if (await const ConectivityCheck().checkConectivity()) {
      final response = await client.delete(
        Uri.parse('${ApiConfig.apiBaseUrl}/nota'),
        body: jsonEncode(jsonString),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      if (response.statusCode == 200) {
        return Either.left(response.statusCode);
      } else {
        return Either.right(
            Exception("Error al elminar la nota en el servidor"));
      }
    } else {
      return Either.right(Exception(
          "No hay conexion a internet")); //guardado en la base de datos local
    }
  }

  List<Nota> parseNota(String responseBody) {
    List<dynamic> decodedResponse = jsonDecode(responseBody);
    List<Nota> notas = [];
    for (var item in decodedResponse) {
      EstadoEnum estado = EstadoEnum.values.byName(item['estado']);

      //hay que usar la funcion Nota.FromJson que lo hace de una
      Nota nota = Nota(
          titulo: VOTituloNota(item['titulo']['titulo']),
          contenido: VOContenidoNota(item['contenido']['contenido']),
          fechaCreacion: DateTime.parse(item['fechaCreacion']),
          estado: estado,
          ubicacion: VOUbicacionNota(111, -11111),
          id: item['id']['id'],
          idGrupo: VOIdGrupoNota(item['grupo']['id']));
      notas.add(nota);
    }
    return notas;
  }
}
