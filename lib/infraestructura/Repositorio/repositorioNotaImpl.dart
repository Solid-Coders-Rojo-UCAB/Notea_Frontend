// ignore_for_file: file_names
import '../../dominio/agregados/nota.dart';
import '../../dominio/repositorio/repositorioNota.dart';
import '../../infraestructura/api/remoteDataNota.dart';
import '../../utils/Either.dart';

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
      "getUbicacion": nota.getUbicacion(),
      "idGrupo": nota.getIdGrupoNota(),
    };
    var result = await remoteDataSource.crearNotaApi(notaDTO);
    return result;
  }

  @override
  Future<Either<int, Exception>> modificarEstadoNota(
      String id, String estado) async {
    Map<String, dynamic> notaDTO = {
      "id": id,
      "estado": estado,
    };
    var result = await remoteDataSource.changeStateNotaApi(notaDTO);
    return result;
  }

  @override
  Future<Either<int, Exception>> borrarNota(String id) async {
    Map<String, dynamic> notaDTO = {
      "id": id,
    };
    var result = await remoteDataSource.borrarNotaApi(notaDTO);
    return result;
  }
}
