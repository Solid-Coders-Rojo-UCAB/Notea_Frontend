import 'package:notea_frontend/dominio/agregados/VOEtiqueta/colorEtiqueta.dart';
import 'package:notea_frontend/dominio/agregados/VOEtiqueta/nombreEtiqueta.dart';

class Etiqueta {
  late String idEtiqueta;
  late VONombreEtiqueta nombre;
  late VOColorEtiqueta color;

  late String idUsuario;
  
  //late List<Tarea> tareas;

  Etiqueta({
    required this.idEtiqueta,
    required this.nombre,
    required this.color,
    required this.idUsuario,
  });

  factory Etiqueta.fromJson(Map<String, dynamic> json) {

    return Etiqueta(
      idEtiqueta: json['id']['id'],
      nombre: VONombreEtiqueta.crearNombreEtiqueta(json['nombre']['nombre']),
      color: VOColorEtiqueta.crearcolorEtiqueta(json['color']),
      idUsuario: json['usuario']['id'],
    );
  }

  static Etiqueta crearEtiqueta(String idEtiqueta, String nombre, String color, String idUsuario){
    return Etiqueta(
      idEtiqueta: idEtiqueta,
      nombre: VONombreEtiqueta.crearNombreEtiqueta(nombre),
      color: VOColorEtiqueta.crearcolorEtiqueta(color),
      idUsuario: idUsuario,
    );
  }

  String getNombre() {
    return nombre.getNombreEtiqueta();
  }
  String getNombreEtiqueta() {
    return nombre.getNombreEtiqueta();
  }

  void setNombre(VONombreEtiqueta nombre) {
    this.nombre = nombre;
  }
}
