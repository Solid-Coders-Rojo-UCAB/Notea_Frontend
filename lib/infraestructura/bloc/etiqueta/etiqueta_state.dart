// ignore_for_file: overridden_fields

part of 'etiqueta_bloc.dart';

@immutable
abstract class EtiquetaState {
  final bool existeEtiqueta;
  final List<dynamic>? etiquetas;

  const EtiquetaState({this.existeEtiqueta = false, this.etiquetas});
}

class EtiquetaInitialState extends EtiquetaState {
  const EtiquetaInitialState() : super(existeEtiqueta: false, etiquetas: null);
}


class EtiquetasSuccessState extends EtiquetaState {
  @override
  final List<dynamic> etiquetas;
  const EtiquetasSuccessState({required this.etiquetas}) : super(existeEtiqueta: true);
}

class EtiquetasFailureState extends EtiquetaState {
  const EtiquetasFailureState() : super(existeEtiqueta: false, etiquetas: null);
}