import 'package:flutter/material.dart';
import 'package:notea_frontend/dominio/agregados/VOEtiqueta/colorEtiqueta.dart';
import 'package:notea_frontend/dominio/agregados/VOEtiqueta/nombreEtiqueta.dart';
import 'package:notea_frontend/dominio/agregados/etiqueta.dart';
import 'package:notea_frontend/presentacion/pantallas/etiquetas_screen.dart';
import '../../dominio/agregados/grupo.dart';
import 'papelera_screen.dart';
import 'home_screen.dart';
import 'package:notea_frontend/dominio/agregados/usuario.dart';

class NavigationProvider with ChangeNotifier {
  final Usuario usuario;
  Widget _currentScreen;



  NavigationProvider({required this.usuario}) : _currentScreen = MessagesScreen(usuario: usuario);

  Widget get currentScreen => _currentScreen;


  set currentScreen(Widget screen) {
    _currentScreen = screen;
    notifyListeners();
  }

  void toMessagesScreen() {
    _currentScreen = MessagesScreen(usuario: usuario);
    notifyListeners();
  }
  
  void toPapelera(List<Grupo> grupos) {
    _currentScreen = Papelera(grupos: grupos, usuario: usuario, etiquetas: [Etiqueta(idEtiqueta: 'idEtiqueta', nombre: VONombreEtiqueta('Etiqueta'), color: VOColorEtiqueta('AMBER'), idUsuario: '2912iuuui')],);
    notifyListeners();
  }
    void toEtiquetasScreen() {
    _currentScreen = EtiquetasScreen();
    notifyListeners();
  }

}