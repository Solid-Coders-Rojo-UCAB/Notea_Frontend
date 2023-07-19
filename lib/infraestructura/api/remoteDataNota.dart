import 'dart:convert';
import 'dart:core';
import 'dart:io';
import 'package:async/async.dart';

import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:notea_frontend/dominio/agregados/VONota/VOContenidoNota.dart';
import 'package:notea_frontend/dominio/agregados/VONota/VOListaEtiquetas.dart';
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

  Future<Either<List<Nota>, Exception>> buscarNotasByGruposApi(
      List<String> grupos) async {
    if (await const ConectivityCheck().checkConectivity()) {
      final response = await http.patch(
        Uri.parse('${ApiConfig.apiBaseUrl}/nota/grupos'),
        body: jsonEncode(grupos),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      ); //Creo que esto no es lo mejor, porque treemos todas las notas

      // print('RESPONSE BODY______________----------------------');
      // print(response.body);
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
    List<Map<String, dynamic>> decodedResponse = List<Map<String, dynamic>>.from(jsonDecode(responseBody));
    List<Nota> notas = [];
    

    for (var item in decodedResponse) {
      EstadoEnum estado = EstadoEnum.values.byName(item['estado']);
      // print('item[etiquetas]-----------------------------------------');
      // print(item['etiquetas']);
      // Utiliza jsonEncode para convertir el mapa a una cadena JSON
      String contenidoJson = jsonEncode(item['contenido']);

      VOUbicacionNota? ubicacion;
      if (item.containsKey('ubicacion')) {
        ubicacion = VOUbicacionNota(
            item['ubicacion']['latitud'], item['ubicacion']['longitud']);
      }

      Nota nota = Nota(
        titulo: VOTituloNota(item['titulo']),
        contenido: VOContenidoNota(contenidoJson),
        fechaCreacion: DateTime.parse(item['fechaCreacion']),
        estado: estado,
        ubicacion: ubicacion,
        id: item['id'],
        idGrupo: VOIdGrupoNota(item['grupo']),
        etiquetas: VOIdEtiquetas(item['etiquetas']),
      );
      notas.add(nota);
    }
    return notas;
  }

  //Hay que verificar con lo que esta haciendo italo para saber como lo tiene que recibir esto aun no funciona
  Future<Either<int, Exception>> editarNotaApi(Map<String, dynamic> jsonString) async {
    if (await const ConectivityCheck().checkConectivity()) {
      final response = await client.patch(
        Uri.parse('${ApiConfig.apiBaseUrl}/nota'),
        body: jsonEncode(jsonString),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
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
}


void printContent(List<dynamic> data) {
  for (var item in data) {
    print("Titulo: ${item['titulo']}");
    print("Fecha de creación: ${item['fechaCreacion']}");
    print("Estado: ${item['estado']}");
    print("Grupo: ${item['grupo']}");

    print("Ubicación - Latitud: ${item['ubicacion']['latitud']}");
    print("Ubicación - Longitud: ${item['ubicacion']['longitud']}");

    var etiquetas = item['etiquetas'];
    print("Etiquetas:");
    for (var etiqueta in etiquetas) {
      print("- $etiqueta");
    }

    var contenido = item['contenido'];
    print("Contenido:");
    print( {'contenido':contenido});
    for (var contenidoItem in contenido) {
      print("- ID: ${contenidoItem['id']}");
      print("  Orden: ${contenidoItem['orden']}");
      var texto = contenidoItem['texto'];
      print("  Texto - Cuerpo: ${texto['cuerpo']}");
    }

    print("ID: ${item['id']}");
    print("----------------------------");
  }
}