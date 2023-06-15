import 'VOTituloTarea.dart';

class Tarea {
  late String id;
  late VOTituloTarea titulo;
  late bool check;

  Tarea(this.id, VOTituloTarea titulo, this.check) {
    this.titulo = titulo;
  }

  static Tarea crearTarea(String id, String titulo, bool check) {
    return Tarea(id, VOTituloTarea.crearTituloTarea(titulo), check);
  }

  String getTitulo() {
    return titulo.getTituloTarea();
  }

  String getId() {
    return id;
  }

  bool getCheck() {
    return check;
  }

  void CheckUncheck() {
    check = !check;
  }
}
