class VONombreEtiqueta {
  String nombre;

  VONombreEtiqueta(this.nombre);


  static VONombreEtiqueta crearNombreEtiqueta(String nombre) {
    return VONombreEtiqueta(nombre);
  }

  String getNombreEtiqueta() {
    return nombre;
  }
}
