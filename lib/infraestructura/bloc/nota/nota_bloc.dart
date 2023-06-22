//tiene la informacion del estado actual y de quien procesa los eventos

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

import '../../../dominio/agregados/nota.dart';

part 'nota_event.dart';
part 'nota_state.dart';

class NotaBloc extends Bloc<NotaEvent, NotaState> {
  NotaBloc() : super(NotaInitialState()) {
    on<NuevaNota>((event, emit) {
      
    });
  }
}
