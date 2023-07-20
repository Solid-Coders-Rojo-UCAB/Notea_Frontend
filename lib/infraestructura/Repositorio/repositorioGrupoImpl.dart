import '../../utils/Either.dart';
import 'package:notea_frontend/dominio/agregados/grupo.dart';
import 'package:notea_frontend/dominio/repositorio/repositorioGrupo.dart';
import 'package:notea_frontend/infraestructura/api/remoteDataGrupo.dart';

class RepositorioGrupoImpl implements IGrupoRepository {
  final RemoteDataGrupoImp remoteDataSource;

  RepositorioGrupoImpl({required this.remoteDataSource});

  @override
  Future<Either<List<Grupo>, Exception>> buscarGrupos(String idUsuarioDueno) async {
    final result = await remoteDataSource.buscarGruposApi(idUsuarioDueno);
    return result;
  }

  @override
  Future<Either<int, Exception>> crearGrupo(Map<String, dynamic> grupoDTO) async {
    var result = await remoteDataSource.crearGrupoApi(grupoDTO);
    return result;

  } @override
    Future<Either<int, Exception>> patchGrupo(Map<String, dynamic> grupoDTO,String id) async {
    var result = await remoteDataSource.patchGrupoApi(grupoDTO,id);
    return result;
  }
     @override
    Future<Either<int, Exception>> deleteGrupo(String id) async {
    var result = await remoteDataSource.deleteGrupoApi(id);
    return result;
  }
}

