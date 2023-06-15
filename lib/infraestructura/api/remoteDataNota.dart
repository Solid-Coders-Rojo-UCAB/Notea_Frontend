import 'dart:async';
import 'dart:convert';
import 'dart:core';

import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;

import '../../dominio/agregados/VONota/EstadoEnum.dart';
import '../../dominio/agregados/nota.dart';
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




          print('NOTAS de la API -> ');
          print(response.body);






        
        return Left(parseNota(response.body));
      } else {
        return Right(Exception("Error al buscar las notas"));
      }
    } else {
      return Right(Exception(
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
        return Left(response.statusCode);
      } else {
        return Right(Exception("Error al crear la nota en el servidor"));
      }
    } else {
      return Right(Exception(
          "No hay conexion a internet")); //guardado en la base de datos local
    }
  }

  List<Nota> parseNota(String responseBody) {
    final json = jsonDecode(responseBody);
    final valueList = json['value'] as List;
     final item = valueList[0];

      final id = item['id']['id'];
      final titulo = item['titulo']['titulo'];
      final contenido = item['contenido']['contenido'];
      final fechaCreacion = item['fechaCreacion'];
      final estado = item['estado'];
      final latitud = item['ubicacion']['latitud'];
      final longitud = item['ubicacion']['longitud'];
    EstadoEnum est;
    if(estado == "GUARDADO"){
      est  = EstadoEnum.GUARDADO;
    }else if(estado == "POR_GUARDAR"){      //TODO cambiar esto se ve fe  (●'◡'●)
      est = EstadoEnum.POR_GUARDAR;
    }else {
      est = EstadoEnum.PAPELERA;
    }
    DateTime fromString = DateTime.parse(fechaCreacion);
    final nota = Nota.crearNota(titulo, contenido, fromString, est,
    latitud, longitud, id);  //CAMB
    print('object');
    //debemos usar el metodo fromJson
    final lista = <Nota>[];
    lista.add(nota);

      return lista;
      //// return item.map((json) => Usuario.fromJson(json)).toList();
   }
}

// errors.dart:266 Uncaught (in promise) Error: Expected a value of type 'int', but got one of type 'String'
//     at Object.throw_ [as throw] (errors.dart:266:49)
//     at Object.castError (errors.dart:99:3)
//     at Object.cast [as as] (operations.dart:485:10)
//     at int.as (core_patch.dart:269:17)
//     at remoteDataNota.RemoteDataNotaImp.new.parseNota
