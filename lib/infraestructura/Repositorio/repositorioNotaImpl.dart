import 'package:dartz/dartz.dart';

import '../../dominio/agregados/nota.dart';
import '../../dominio/repositorio/repositorioNota.dart';
import '../../infraestructura/api/remoteDataNota.dart';

class RepositorioNotaImpl implements INotaRepository {
  final RemoteDataNotaImp remoteDataSource;
  RepositorioNotaImpl({required this.remoteDataSource});

  @override
  Future<Either<List<Nota>, Exception>> buscarNotas() async {
    final result = await remoteDataSource.buscarNotasApi();
    //Aca se guardaria en la base de datos local
    return result;
  }

//exactooo
  @override
  Future<Either<int, Exception>> crearNota(Nota nota) async {
    Map<String, dynamic> notaDTO = {
      "titulo": nota.getTitulo(),
      "contenido": nota.getContenido(),
      "fechaCreacion": nota.getFechaCreacion(),
      "getEstado": nota.getEstado(),
      "getUbicacion": nota.getUbicacion()
    };
    var result = await remoteDataSource.crearNotaApi(notaDTO);
    return result;
  }
}
