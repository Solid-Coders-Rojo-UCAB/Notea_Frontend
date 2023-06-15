class VOUbicacionNota {
  int latitud;
  int longitud;

  VOUbicacionNota(this.latitud, this.longitud);

  static VOUbicacionNota crearUbicacionNota(int latitud, int longitud) {
    return VOUbicacionNota(latitud, longitud);
  }

  int getLatitud() {
    return latitud;
  }

  int getLongitud() {
    return longitud;
  }
}