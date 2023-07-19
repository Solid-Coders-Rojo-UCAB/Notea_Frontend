import 'package:notea_frontend/dominio/agregados/usuario.dart';

abstract class RepositorioPersistenciaUsuario {
  Future<List<Usuario>> getAllUsuarios();
  Future<int> update(Usuario usuario);
  Future<int> delete(String id) ;
  Future<bool> login(String email, String clave);
}
