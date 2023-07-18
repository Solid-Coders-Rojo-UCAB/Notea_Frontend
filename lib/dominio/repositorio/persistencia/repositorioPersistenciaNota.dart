import 'package:notea_frontend/dominio/agregados/nota.dart';

abstract class RepositorioPersistenciaNota {
  Future<List<Nota>>  buscarNotas();
  Future<int> insertNota(Nota nota) ;
  Future<Nota?> buscarNotaPorId(String id);         //Revisar para que no devuleva null
  Future<bool> updateNota(Nota nota);
  Future<void> deleteNota(Nota nota);
  Future init();                                    //ESTO ESTA BUENO?
  void close();
}
