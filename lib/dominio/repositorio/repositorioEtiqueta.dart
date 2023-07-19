import 'package:notea_frontend/dominio/agregados/etiqueta.dart';

import '../../utils/Either.dart';

abstract class IEtiquetaRepository {
  Future<Either<List<Etiqueta>, Exception>> buscarEtiquetas(
      String idUsuarioDueno);
  Future<Either<int, Exception>> crearEtiqueta(
      Map<String, dynamic> etiquetaDTO);
  Future<Either<int, Exception>> deleteEtiqueta(String etiquetaId);
}
