import 'dart:async';
import 'dart:convert';
import 'dart:core';

import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;

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
          await client.get(Uri.parse('http://localhost:3000/notas/all'));
      if (response.statusCode == 200) {
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
        Uri.parse('http://localhost:3000/notas'),
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
    final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<Nota>((json) => Nota.fromJson(json)).toList();
  }
}
