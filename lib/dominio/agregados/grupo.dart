import 'package:notea_frontend/dominio/agregados/VOGrupo/nombreGrupo.dart';

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
