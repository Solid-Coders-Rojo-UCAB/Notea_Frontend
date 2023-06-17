// ignore: file_names
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:notea_frontend/dominio/agregados/nota.dart';

import '../../dominio/agregados/usuario.dart';
import '../../utils/Either.dart';
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
      if (response.statusCode == 200) {
        final usuariofinal = parseUsuario(response.body);
        return Either.left(usuariofinal);
      } else {
        return Either.right(Exception("Error al buscar los usuarios"));
      }
    } else {
      return Either.right(Exception(
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
        return Either.left(response.statusCode);
      } else {
        return Either.right(Exception("Error al crear el usuario en el servidor"));
      }
    } else {
      return Either.right(Exception(
          "No hay conexion a internet")); //guardado en la base de datos local
    }
  }

  List<Usuario> parseUsuario(String responseBody) {
    // Parse the JSON string to a Map.
    Map<String, dynamic> jsonMap = jsonDecode(responseBody);

    // Get the value list.
    List<dynamic> valueList = jsonMap['value'];

    // iteramos por cada valor de la lista y creamos un objeto Nota para cada valor.
    List<Usuario> usuarios = valueList.map((value) => Usuario.fromJson(value)).toList();

    return usuarios;
  }

} 
