class VOColorEtiqueta {
  String color;

  VOColorEtiqueta(this.color);


  static VOColorEtiqueta crearcolorEtiqueta(String color) {
    return VOColorEtiqueta(color);
  }

  String getcolorEtiqueta() {
    return color;
  }
}
