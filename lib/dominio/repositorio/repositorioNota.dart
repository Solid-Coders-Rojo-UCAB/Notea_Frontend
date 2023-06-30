
import 'package:notea_frontend/dominio/agregados/grupo.dart';

import '../../utils/Either.dart';
import '../agregados/nota.dart';

abstract class INotaRepository {
  Future<Either<List<Nota>, Exception>> buscarNotas();
  Future<Either<int, Exception>?> crearNota(String titulo, List<dynamic> listInfoContenido, List<dynamic> etiquetas, Grupo grupo);
}
