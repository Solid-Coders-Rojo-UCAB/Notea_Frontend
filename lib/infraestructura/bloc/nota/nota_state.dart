// ignore_for_file: overridden_fields

part of 'nota_bloc.dart';

@immutable
abstract class NotaState {
  final bool existeNota;
  final List<Nota>? notas;
  final Nota? nota;

  const NotaState({this.existeNota = false, this.nota, this.notas});
}

class NotaInitialState extends NotaState {
  const NotaInitialState() : super(existeNota: false, nota: null);
}

class NotasSuccessState extends NotaState {
  @override
  final List<Nota> notas;
  const NotasSuccessState({required this.notas}) : super(existeNota: true);
}

class NotasFailureState extends NotaState {
  const NotasFailureState() : super(existeNota: false, notas: null);
}