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
  Future<Either<int, Exception>> crearUsuario(Usuario usuario) async {
    //NECESITAMOS UN BODY
    Map<String, dynamic> usuarioDTO = {
      "nombre": usuario.getNombre(),
      "apellido": usuario.getApellido(),
      "email": usuario.getEmail(),
      "clave": usuario.getClave(),
      "suscripcion": usuario.isSuscribed(),
    };
    return await remoteDataSource.crearUsuarioApi(usuarioDTO);
    //   jsonUsuarioToBd(result);
    //   return Right(result);
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
