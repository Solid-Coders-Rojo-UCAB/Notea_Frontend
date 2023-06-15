// ignore_for_file: unused_local_variable

import 'package:dartz/dartz.dart';

import '../agregados/usuario.dart';

abstract class IUsuarioRepository {
  Future<Either<List<Usuario>, Exception>> buscarUsuario();
  Future<Either<int, Exception>> crearUsuario(Usuario usuario);
}
