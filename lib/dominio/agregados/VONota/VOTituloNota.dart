class VOTituloNota {
  String tituloNota;

  VOTituloNota(this.tituloNota);

  static VOTituloNota crearTituloNota(String titulo) {
    return VOTituloNota(titulo);
  }

  String getTituloNota() {
    return tituloNota;
  }
}
