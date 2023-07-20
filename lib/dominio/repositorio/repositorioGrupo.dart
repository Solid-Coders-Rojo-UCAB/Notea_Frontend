import '../../utils/Either.dart';
import 'package:notea_frontend/dominio/agregados/grupo.dart';

abstract class IGrupoRepository {
  Future<Either<List<Grupo>, Exception>> buscarGrupos(String idUsuarioDueno);
  Future<Either<int, Exception>> crearGrupo(Map<String, dynamic> grupoDTO);
  Future<Either<int, Exception>> patchGrupo(
      Map<String, dynamic> grupoDTO, String id);
  Future<Either<int, Exception>> deleteGrupo(String id);
}
