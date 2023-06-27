import 'package:notea_frontend/dominio/agregados/VONota/VOidGrupo.dart';

import 'Entidades/EntidadTarea.dart';
import 'VONota/EstadoEnum.dart';
import 'VONota/VOContenidoNota.dart';
import 'VONota/VOTituloNota.dart';
import 'VONota/VOUbicacionNota.dart';

class Nota {
  String id;
  late VOTituloNota titulo;
  late VOContenidoNota contenido;
  late DateTime fechaCreacion;
  late VOUbicacionNota ubicacion;
  late String estado;
  //late List<Tarea> tareas;
  late VOIdGrupoNota idGrupo;

  Nota({
    required this.titulo,
    required this.contenido,
    required this.fechaCreacion,
    required this.estado,
    required this.ubicacion,
    required this.id,
    /*required this.tareas*/
    required this.idGrupo,
  });

  factory Nota.fromJson(Map<String, dynamic> json) {

    return Nota(
      titulo: VOTituloNota.crearTituloNota(json['titulo']['titulo']),
      contenido: VOContenidoNota.crearContenidoNota(json['contenido']['contenido']),
      fechaCreacion: DateTime.parse(json['fechaCreacion']),
      estado: (json['estado']['estado']),
      ubicacion:
          VOUbicacionNota.crearUbicacionNota(json['ubicacion']['latitud'], json['ubicacion']['longitud']),
      id: json['id']['id'],
      //tareas: json['tareas'],
      idGrupo: VOIdGrupoNota.crearIdGrupoNota(json['idGrupo']['idGrupo']),
    );
  }

  static Nota crearNota(String titulo, String contenido, DateTime fechaCreacion,
      String estado, int latitud, int longitud, String id, String idGrupo) {
    return Nota(
      titulo: VOTituloNota.crearTituloNota(titulo),
      contenido: VOContenidoNota.crearContenidoNota(contenido),
      fechaCreacion: fechaCreacion,
      estado: estado,
      ubicacion: VOUbicacionNota.crearUbicacionNota(latitud, longitud),
      id: id,
      //tareas: [],
      idGrupo: VOIdGrupoNota.crearIdGrupoNota(idGrupo),
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
    return estado;
  }

  Map<String, int> getUbicacion() {
    return {
      'latitud': ubicacion.getLatitud(),
      'longitud': ubicacion.getLongitud(),
    };
  }

  int getLatitud() {
    return ubicacion.getLatitud();
  }

  int getLongitud() {
    return ubicacion.getLongitud();
  }

  void setEstado(String estado) {
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
