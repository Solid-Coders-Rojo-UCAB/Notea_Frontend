import 'package:notea_frontend/dominio/agregados/VOGrupo/nombreGrupo.dart';

const String tableGrupoName = 'grupo';
class GrupoColumnas {
  static const String idGrupo = '_idGrupo';
  static const String nombre = 'nombre';
  static const String idUsuario= 'idUsuario';
}

class Grupo {
  late String idGrupo;
  late VONombreGrupo nombre;
  late String idUsuario;
  
  //late List<Tarea> tareas;

  Grupo({
    required this.idGrupo,
    required this.nombre,
    required this.idUsuario,
  });

  factory Grupo.fromJson(Map<String, dynamic> json) {

    return Grupo(
      idGrupo: json['id']['id'],
      nombre: VONombreGrupo.crearNombreGrupo(json['nombre']['nombre']),
      idUsuario: json['usuario']['id'],
    );
  }
  //SQFLITE
  factory Grupo.fromJsonOffLine(Map<String, dynamic> json) {
    return Grupo(
      idGrupo: json['_idGrupo'],
      nombre: VONombreGrupo.crearNombreGrupo(json['nombre']),
      idUsuario: json['idUsuario'],
    );
  }

  Map<String, Object?> toJson() => {
      GrupoColumnas.idGrupo: idGrupo,
      GrupoColumnas.nombre: nombre.getNombreGrupo(),
      GrupoColumnas.idUsuario: idUsuario,
  };

  void setId(String idGrupo) {
    this.idGrupo = idGrupo;
  }
  
  String getId() {
    return idGrupo;
  }

  static Grupo crearGrupo(String idGrupo, String nombre, String idUsuario){
    return Grupo(
      idGrupo: idGrupo,
      nombre: VONombreGrupo.crearNombreGrupo(nombre),
      idUsuario: idUsuario,
    );
  }

  String getNombre() {
    return nombre.getNombreGrupo();
  }

  void setNombre(VONombreGrupo nombre) {
    this.nombre = nombre;
  }
}
