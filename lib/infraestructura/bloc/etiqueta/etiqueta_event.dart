part of 'etiqueta_bloc.dart';

@immutable
abstract class EtiquetaEvent  {}

class EtiquetaCatchEvent extends EtiquetaEvent {
  final String idUsuarioDueno;

  EtiquetaCatchEvent({required this.idUsuarioDueno});
}

class EtiquetaReload extends EtiquetaEvent {
  EtiquetaReload();
}