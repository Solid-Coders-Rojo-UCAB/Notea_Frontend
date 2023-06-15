// ignore: file_names
import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;

import '../../dominio/agregados/usuario.dart';
import '../conectivityChecker/checker.dart';

abstract class RemoteDataUsuario {
  Future<Either<List<Usuario>, Exception>> buscarUsuarioApi();
  Future<Either<int, Exception>> crearUsuarioApi(
      Map<String, dynamic> jsonString);
}

class RemoteDataUsuarioImp implements RemoteDataUsuario {
  final http.Client client;
  RemoteDataUsuarioImp({required this.client});

  @override
  Future<Either<List<Usuario>, Exception>> buscarUsuarioApi() async {
    //  deberia devolver un Either
    if (await const ConectivityCheck().checkConectivity()) {
      final response =
          await client.get(Uri.parse('http://localhost:3000/usuarios/all'));
      if (response.statusCode == 200) {
        return Left(parseUsuario(response.body));
      } else {
        return Right(Exception("Error al buscar los usuarios"));
      }
    } else {
      return Right(Exception(
          "No hay conexion a internet")); //guardado en la base de datos local
    }
  }

  @override
  Future<Either<int, Exception>> crearUsuarioApi(
      Map<String, dynamic> jsonString) async {
    //deberia devolver un Either
    if (await const ConectivityCheck().checkConectivity()) {
      final response = await client.post(
        Uri.parse('http://localhost:3000/usuarios'),
        body: jsonString,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      if (response.statusCode == 200) {
        return Left(response.statusCode);
      } else {
        return Right(Exception("Error al crear el usuario en el servidor"));
      }
    } else {
      return Right(Exception(
          "No hay conexion a internet")); //guardado en la base de datos local
    }
  }

  List<Usuario> parseUsuario(String responseBody) {
    final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<Usuario>((json) => Usuario.fromJson(json)).toList();
  }
}
