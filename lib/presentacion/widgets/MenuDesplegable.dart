import 'package:flutter/material.dart';

class CustomDrawer extends StatelessWidget {
  final String username;
  final String email;
  final VoidCallback onBackButtonPressed;
  final List<MenuItem> menuItems;
  final VoidCallback onLogoutPressed;

  CustomDrawer({
    required this.username,
    required this.email,
    required this.onBackButtonPressed,
    required this.menuItems,
    required this.onLogoutPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Padding(
            padding: const EdgeInsets.only(top: 42.0),
        child: Column(
          children: [
            // Parte de arriba
            Container(
              height: 200,
              width: 200,
              decoration: const BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 50,
                    child: Image.asset(
                      'assets/images/user_icon.png',
                      fit: BoxFit.cover, // Ajusta el tamaño de la imagen dentro del CircleAvata
                      width: 60,
                      height: 60,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    username,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    email,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            // Parte de abajo
            const SizedBox(height: 40),
            Expanded(
              child: ListView.builder(
                itemCount: menuItems.length,
                itemBuilder: (context, index) {
                  final item = menuItems[index];
                  return Column(
                    children: [
                      ListTile(
                        leading: Icon(item.icon),
                        title: Text(item.title),
                        onTap: item.onPressed,
                      ),
                      const Divider(  // Agrega el widget Divider para la separación
                        height: 1,  // Ajusta la altura del Divider según tus necesidades
                        color: Color.fromARGB(78, 204, 203, 203),  // Ajusta el color del Divider según tus necesidades
                      ),
                    ],
                  );
                },
              ),
            ),
            // Botón de salir
            ListTile(
              title: Align(
                alignment: Alignment.centerRight,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: const [
                    Text('Salir'),
                    SizedBox(width: 8),
                    Icon(Icons.logout),
                  ],
                ),
              ),
              onTap: onLogoutPressed,
            ),
          ],
        ),
      ),
    );
  }
}

class MenuItem {
  final IconData icon;
  final String title;
  final VoidCallback onPressed;

  MenuItem({
    required this.icon,
    required this.title,
    required this.onPressed,
  });
}
