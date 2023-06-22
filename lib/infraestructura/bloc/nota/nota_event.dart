part of 'nota_bloc.dart';

@immutable
abstract class NotaEvent  {}

//generamos los distintos eventos que puede tener el bloc
class NotaCatchEvent extends NotaEvent {
  NotaCatchEvent();
}