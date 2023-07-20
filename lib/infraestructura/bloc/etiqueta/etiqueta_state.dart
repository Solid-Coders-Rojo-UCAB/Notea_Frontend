// ignore_for_file: overridden_fields

part of 'etiqueta_bloc.dart';

@immutable
abstract class EtiquetaState {
  final bool existeEtiqueta;
  final List<Etiqueta>? etiquetas;

  const EtiquetaState({this.existeEtiqueta = false, this.etiquetas});
}

class EtiquetaInitialState extends EtiquetaState {
  const EtiquetaInitialState() : super(existeEtiqueta: false, etiquetas: null);
}


class EtiquetasSuccessState extends EtiquetaState {
  @override
  final List<Etiqueta> etiquetas;
  const EtiquetasSuccessState({required this.etiquetas}) : super(existeEtiqueta: true);
}

class EtiquetasFailureState extends EtiquetaState {
  const EtiquetasFailureState() : super(existeEtiqueta: false, etiquetas: null);
}

class EtiquetaDeleteSuccessState extends EtiquetaState {
  const EtiquetaDeleteSuccessState() : super(existeEtiqueta: false, etiquetas: null);
}

class EtiquetaDeleteFailureState extends EtiquetaState {
  final String message;

  const EtiquetaDeleteFailureState({required this.message}) : super(existeEtiqueta: false, etiquetas: null);
}


class EtiquetaCreateSuccessState extends EtiquetaState {


}
class EtiquetaCreateFailureState extends EtiquetaState {

  
}
