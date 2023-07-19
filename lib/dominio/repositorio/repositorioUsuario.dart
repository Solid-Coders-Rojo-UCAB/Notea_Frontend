// ignore_for_file: unused_local_variable

import '../../utils/Either.dart';
import '../agregados/usuario.dart';

abstract class IUsuarioRepository {
  Future<Either<List<Usuario>, Exception>> buscarUsuario();
  Future<Either<String, Exception>> crearUsuario(Usuario usuario);
  Future<Either<Usuario, Exception>> loginUsuario(
      String email, String password);
  Future<Either<String, Exception>> suscriptionusuario(
      String IdUsuario, String Tipo, DateTime? fechaFinal);
  Future<Either<String, Exception>> getSuscribeUsuarioApi(String IdUsuario);
  //Future<Either<int, Exception>> eliminarUsuario(int id);
}
