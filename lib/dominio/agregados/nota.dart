import 'package:notea_frontend/dominio/agregados/VONota/VOListaEtiquetas.dart';
import 'package:notea_frontend/dominio/agregados/VONota/VOidGrupo.dart';

import 'VONota/EstadoEnum.dart';
import 'VONota/VOContenidoNota.dart';
import 'VONota/VOTituloNota.dart';
import 'VONota/VOUbicacionNota.dart';

class Nota {
  String id;
  late VOTituloNota titulo;
  late VOContenidoNota contenido;     //Se supone que esto es una lista de cosas(CONTENIDOS, IMAGENES, TAREAS)
  late DateTime fechaCreacion;
  late VOUbicacionNota? ubicacion;
  late EstadoEnum estado;
  //late List<Tarea> tareas;
  late VOIdGrupoNota idGrupo;
  late VOIdEtiquetas etiquetas;

  Nota({
    required this.titulo,
    required this.contenido,
    required this.fechaCreacion,
    required this.estado,
    this.ubicacion,
    required this.id,
    /*required this.tareas*/
    required this.idGrupo,
    required this.etiquetas,
  });

  factory Nota.fromJson(Map<String, dynamic> json) {
    return Nota(
      titulo: VOTituloNota.crearTituloNota(json['titulo']['titulo']),
      contenido:
          VOContenidoNota.crearContenidoNota(json['contenido']['contenido']),
      fechaCreacion: DateTime.parse(json['fechaCreacion']),
      estado: EstadoEnum.values.byName(json['estado']),
      ubicacion: VOUbicacionNota.crearUbicacionNota(
          json['ubicacion']['latitud'], json['ubicacion']['longitud']),
      id: json['id']['id'],
      //tareas: json['tareas'],
      idGrupo: VOIdGrupoNota.crearIdGrupoNota(json['idGrupo']['idGrupo']),
      etiquetas: VOIdEtiquetas.crearListaIdEtiquetas(json['etiquetas'])
    );
  }

  static Nota crearNota(String titulo, String contenido, DateTime fechaCreacion,
      EstadoEnum estado, double latitud, double longitud, String id, String idGrupo, List<String> etiquetas) {
    return Nota(
      titulo: VOTituloNota.crearTituloNota(titulo),
      contenido: VOContenidoNota.crearContenidoNota(contenido),
      fechaCreacion: fechaCreacion,
      estado: estado,
      ubicacion: VOUbicacionNota.crearUbicacionNota(latitud, longitud),
      id: id,
      //tareas: [],
      idGrupo: VOIdGrupoNota.crearIdGrupoNota(idGrupo),
      etiquetas: VOIdEtiquetas.crearListaIdEtiquetas(etiquetas)
    );
  }

  String getTitulo() {
    return titulo.getTituloNota();
  }

  String getIdGrupoNota() {
    return idGrupo.getIdGrupoNota();
  }

  String getContenido() {
    return contenido.getContenidoNota();
  }

  DateTime getFechaCreacion() {
    return fechaCreacion;
  }

  String getEstado() {
    return estado.name;
  }

  bool existeUbicacion() {
    return ubicacion != null;
  }

  Map<String, double> getUbicacion() {
    return {
      'latitud': ubicacion!.getLatitud(),
      'longitud': ubicacion!.getLongitud(),
    };
  }

  double getLatitud() {
    return ubicacion!.getLatitud();
  }

  double getLongitud() {
    return ubicacion!.getLongitud();
  }

  List<dynamic> getEtiquetas(){
    return etiquetas.getEtiquetas();
  }

  void setEstado(EstadoEnum estado) {
    this.estado = estado;
  }

  void setTitulo(VOTituloNota titulo) {
    this.titulo = titulo;
  }

  void setContenido(VOContenidoNota contenido) {
    this.contenido = contenido;
  }

  void setIdGrupoNota(VOIdGrupoNota idGrupo) {
    this.idGrupo = idGrupo;
  }
}
