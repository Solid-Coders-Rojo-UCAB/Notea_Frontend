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
          await client.get(Uri.parse('http://localhost:3000/usuario/all'));
      print('------');
      print('Luego de la peticion');
      print('------');
      
      print('------');
      print(response.body);
      print('------');
      if (response.statusCode == 200) {
        print('------');
        print('Todo kuls');
        print('------');
        final data = jsonDecode(response.body);
        print('------');
        print(data);
        print('------');
        final usuarioeeeee = parseUsuario(data);
        final usuarioList = parseUsuarioList(data);
        print('----');
        print(usuarioeeeee);
        print('----');
        return Left(usuarioList);
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
        Uri.parse('http://localhost:3000/usuario'),
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

  // List<Usuario> parseUsuario(String responseBody) {
  //   final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();
  //   return parsed.map<Usuario>((json) => Usuario.fromJson(json)).toList();
  // }

  List<Usuario> parseUsuarioList(dynamic data) {
    final valueList = data['value'] as List<dynamic>;
    return valueList.map((value) => Usuario.fromJson(value)).toList();
  }
  Usuario parseUsuario(dynamic data) {
    final usuario = Usuario.fromJson(data);
    return usuario;
  }
}
