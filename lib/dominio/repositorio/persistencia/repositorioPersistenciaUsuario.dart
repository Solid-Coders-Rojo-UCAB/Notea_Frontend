import 'package:notea_frontend/dominio/agregados/usuario.dart';

abstract class RepositorioPersistenciaUsuario {
  Future<List<Usuario>>  buscarUsuarios();
  Future<Usuario?> buscarUsuarioPorId(String id);         //Revisar para que no devuleva null
  Future<int> insertUsuario(Usuario usuario) ;
  Future<bool> updateUsuario(Usuario usuario);
  Future<void> deleteUsuario(Usuario usuario);
  Future init();                                          //ESTO ESTA BUENO?
  void close();
}
