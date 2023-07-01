// ignore: file_names

import '../../dominio/repositorio/repositorioUsuario.dart';
import '../../utils/Either.dart';
import '../api/remoteDataUsuario.dart';
import '/dominio/agregados/usuario.dart';             //Esto es de dominio, se pude tener aca?

class RepositorioUsuarioImpl implements IUsuarioRepository {
  final RemoteDataUsuarioImp remoteDataSource;

  RepositorioUsuarioImpl({required this.remoteDataSource});

  @override
  Future<Either<List<Usuario>, Exception>> buscarUsuario() async {
    final result = await remoteDataSource.buscarUsuarioApi();
    return result;
  }

  @override
  Future<Either<String, Exception>> crearUsuario(Usuario usuario) async {
    //NECESITAMOS UN BODY
    Map<String, dynamic> usuarioDTO = {
      "nombre": usuario.getNombre(),
      "apellido": usuario.getApellido(),
      "email": usuario.getEmail(),
      "clave": usuario.getClave(),
      "suscripcion": usuario.isSuscribed(),
    };
    
    final respuesta = await remoteDataSource.crearUsuarioApi(usuarioDTO);
    if (respuesta.isLeft()) {
      return Either.left(respuesta.left!["id"]["id"]);
    }
    return Either.right(respuesta.right!);
  }

  @override
  Future<Either<Usuario, Exception>> loginUsuario(
      String email, String clave) async {
    final result = await remoteDataSource.loginUsuarioApi(email, clave);
    return result;
  }


  // @override
  // Future<Either<int, Exception>> eliminarUsuario(int id) async {
  //   return await remoteDataSource.eliminarUsuarioApi(id);
  // }
}
