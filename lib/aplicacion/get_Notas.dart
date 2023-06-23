import 'package:notea_frontend/dominio/agregados/nota.dart';
import 'package:notea_frontend/dominio/repositorio/repositorioNota.dart';

import '../utils/Either.dart';


class GetNotas {
  final INotaRepository repository;

  GetNotas(this.repository);


}