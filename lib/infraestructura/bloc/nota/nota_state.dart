//estado de la
part of 'nota_bloc.dart';

@immutable
abstract class NotaState {
  final bool existNote;
  final Nota? note;

  const NotaState({
    this.existNote = false,
    this.note
  });
}

class NotaInitialState extends NotaState {
  const NotaInitialState() : super(existNote: false, note: null);
}
