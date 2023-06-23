// ignore_for_file: file_names

import 'package:flutter/material.dart';
class BottomBar extends StatelessWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;

  const BottomBar({Key? key, required this.scaffoldKey}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      color: const Color(0xFF21579C), // Establece el color deseado
      child: SizedBox(
        height: 60,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              icon: const Icon(
                Icons.book,
                size: 30,
                color: Colors.white,
              ), onPressed: () {  },
            ),
            IconButton(
              icon: const Icon(
                Icons.delete,
                size: 30,
                color: Colors.white,
              ), onPressed: () {  },
            ),
            IconButton(
              icon: const Icon(
                Icons.person,
                size: 30,
                color: Colors.white,
              ), onPressed: () { scaffoldKey.currentState?.openDrawer(); },
            )
          ],
        ),
      ),
    );
  }
}
