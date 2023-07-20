import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:provider/provider.dart';
import 'navigation_provider.dart';
import 'menu_drawer.dart';
import 'package:notea_frontend/dominio/agregados/usuario.dart';

class HomeScreenWithDrawer extends StatelessWidget {
  final Usuario usuario;

  HomeScreenWithDrawer({required this.usuario});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => NavigationProvider(usuario: usuario),
      child: Consumer<NavigationProvider>(
        builder: (context, navigationProvider, child) => ZoomDrawer(
          style: DrawerStyle.defaultStyle,
          menuScreen: MENU_SCREEN(usuario:usuario),
          mainScreen: navigationProvider.currentScreen,
          borderRadius: 24.0,
          showShadow: true,
          angle: 0.0,
          menuBackgroundColor: const Color(0XFF21579C),
          slideWidth: MediaQuery.of(context).size.width * 0.5,
        ),
      ),
    );
  }
}
