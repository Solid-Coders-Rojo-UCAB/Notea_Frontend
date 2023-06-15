import 'package:dartz/dartz.dart';

import '../agregados/nota.dart';

abstract class INotaRepository {
  Future<Either<List<Nota>, Exception>> buscarNotas();
  Future<Either<int, Exception>> crearNota(Nota nota);
}
