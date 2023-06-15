class VOContenidoNota {
  String contenidoNota;

  VOContenidoNota(this.contenidoNota);

  static VOContenidoNota crearContenidoNota(String contenido) {
    return VOContenidoNota(contenido);
  }

  String getContenidoNota() {
    return contenidoNota;
  }
}
