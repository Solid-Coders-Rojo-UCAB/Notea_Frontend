import 'package:notea_frontend/dominio/agregados/usuario.dart';
import 'package:notea_frontend/dominio/repositorio/repositorioUsuario.dart';

import '../utils/Either.dart';


class GetUsuarios {
  final IUsuarioRepository repository;

  GetUsuarios(this.repository);

  Future<Either<List<Usuario>, Exception>> execute() {
    return repository.buscarUsuario();
  }
}