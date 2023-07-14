import 'package:notea_frontend/dominio/agregados/etiqueta.dart';
import 'package:notea_frontend/dominio/repositorio/repositorioEtiqueta.dart';
import 'package:notea_frontend/infraestructura/api/remoteDataEtiqueta.dart';

import '../../utils/Either.dart';
import 'package:notea_frontend/dominio/agregados/grupo.dart';

class RepositorioEtiquetaImpl implements IEtiquetaRepository {
  final RemoteDataEtiqueta remoteDataSource;

  RepositorioEtiquetaImpl({required this.remoteDataSource});

  @override
  Future<Either<List<Etiqueta>, Exception>> buscarEtiquetas(String idUsuarioDueno) async {
    final result = await remoteDataSource.buscarEtiquetasApi(idUsuarioDueno);
    return result;
  }

  @override
  Future<Either<int, Exception>> crearEtiqueta(Etiqueta grupo) {
    // TODO: implement crearEtiqueta
    throw UnimplementedError();
  }

  // @override
  // Future<Either<int, Exception>> crearEtiqueta(Grupo grupo) async {
  //   Map<String, dynamic> grupoDTO = {
  //     "idUsuario": grupo.idUsuario,
  //     "nombre": grupo.getNombre(),
  //   };
  //   var result = await remoteDataSource.crearEtiquetaApi(grupoDTO);
  //   return result;
  // }
}
