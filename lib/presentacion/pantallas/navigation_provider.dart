import 'package:flutter/material.dart';
import '../../dominio/agregados/grupo.dart';
import 'papelera_screen.dart';
import 'home_screen.dart';
import 'package:notea_frontend/dominio/agregados/usuario.dart';

class NavigationProvider with ChangeNotifier {
  final Usuario usuario;
  Widget _currentScreen;

  int _reloadCounter = 0;

  NavigationProvider({required this.usuario}) : _currentScreen = MessagesScreen(usuario: usuario);

  Widget get currentScreen => _currentScreen;
  int get reloadCounter => _reloadCounter;

  set currentScreen(Widget screen) {
    _currentScreen = screen;
    notifyListeners();
  }

  void toMessagesScreen() {
    _currentScreen = MessagesScreen(usuario: usuario);
    notifyListeners();
  }
  
  void toPapelera(List<Grupo> grupos) {
    _currentScreen = Papelera(grupos: grupos, usuario: usuario);
    notifyListeners();
  }

  void reloadCurrentScreen() {
    _reloadCounter++;
    print('Reloading screen, counter: $_reloadCounter'); 
    notifyListeners();
  }
}