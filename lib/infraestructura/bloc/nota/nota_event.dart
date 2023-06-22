//acciones que va a recibir el bloc y cambiar el state

part of 'nota_bloc.dart';

@immutable
abstract class NotaEvent {}

class NuevaNota extends NotaEvent {
  final Nota note;

  NuevaNota(this.note);
}
