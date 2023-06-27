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
  late EstadoEnum estado;
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
      contenido:
          VOContenidoNota.crearContenidoNota(json['contenido']['contenido']),
      fechaCreacion: DateTime.parse(json['fechaCreacion']),
      estado: EstadoEnum.values.byName(json['estado']),
      ubicacion: VOUbicacionNota.crearUbicacionNota(
          json['ubicacion']['latitud'], json['ubicacion']['longitud']),
      id: json['id']['id'],
      //tareas: json['tareas'],
      idGrupo: VOIdGrupoNota.crearIdGrupoNota(json['idGrupo']['idGrupo']),
    );
  }

  static Nota crearNota(String titulo, String contenido, DateTime fechaCreacion,
      EstadoEnum estado, int latitud, int longitud, String id, String idGrupo) {
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
    return estado.name;
  }

  bool isEstado(String estado) {
    bool isEqual = false;
    for (EstadoEnum value in EstadoEnum.values) {
      if (value.name == estado) {
        isEqual = true;
        return isEqual;
      }
    }
    return isEqual;
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
