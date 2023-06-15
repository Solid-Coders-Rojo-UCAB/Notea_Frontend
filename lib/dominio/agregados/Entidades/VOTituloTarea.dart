class VOTituloTarea {
  late String titulo;

  VOTituloTarea(this.titulo);

  static VOTituloTarea crearTituloTarea(String titulo) {
    return VOTituloTarea(titulo);
  }

  String getTituloTarea() {
    return titulo;
  }
}
