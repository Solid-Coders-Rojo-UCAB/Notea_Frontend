// ignore: file_names
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:notea_frontend/dominio/agregados/nota.dart';

import '../../api_config.dart';
import '../../dominio/agregados/usuario.dart';
import '../../utils/Either.dart';
import '../conectivityChecker/checker.dart';

abstract class RemoteDataUsuario {
  Future<Either<List<Usuario>, Exception>> buscarUsuarioApi();
  Future<Either<int, Exception>> crearUsuarioApi(
      Map<String, dynamic> jsonString);
  Future<Either<Usuario, Exception>> loginUsuarioApi(
      String email, String password);
  //Future<Either<int, Exception>> eliminarUsuarioApi(int id);

}

class RemoteDataUsuarioImp implements RemoteDataUsuario {
  final http.Client client;
  RemoteDataUsuarioImp({required this.client});

  @override
  Future<Either<List<Usuario>, Exception>> buscarUsuarioApi() async {
    //  deberia devolver un Either
    if (await const ConectivityCheck().checkConectivity()) {
      print('------------------Base URL-----------------');
      print('Base URL -> ${ApiConfig.apiBaseUrl}');
      print('------------------Base URL-----------------');
      final response =
          await client.get(Uri.parse('${ApiConfig.apiBaseUrl}/usuario/all'));
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
      print('------------------Base URL-----------------');
      print('Base URL -> ${ApiConfig.apiBaseUrl}');
      print('------------------Base URL-----------------');
      final response = await client.post(
        Uri.parse('${ApiConfig.apiBaseUrl}/usuario'),
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

  @override
  Future<Either<Usuario, Exception>> loginUsuarioApi(
      String email, String clave) async {
    if (await const ConectivityCheck().checkConectivity()) {
      final response = await client.post(
        Uri.parse('${ApiConfig.apiBaseUrl}/usuario/login'),
        body: jsonEncode(<String, String>{
          'email': email,
          'clave': clave,
        }),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      if (response.statusCode == 200) {
        final usuariofinal = Usuario.fromJson(jsonDecode(response.body));
        print(usuariofinal.getNombre() + " " + usuariofinal.getApellido());
        return Either.left(usuariofinal);
      } else {
        return Either.right(Exception("Error al loguear el usuario"));
      }
    } else {
      return Either.right(Exception("No hay conexion a internet")); //guardado en la base de datos local
    }
  }


  // @override
  // Future<Either<int, Exception>> eliminarUsuarioApi(int id) {}

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
