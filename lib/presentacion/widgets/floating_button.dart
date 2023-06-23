import 'package:flutter/material.dart';


class MyFloatingButton extends StatefulWidget {
  const MyFloatingButton({super.key, required Null Function() onPressed});

  @override
  State<MyFloatingButton> createState() => FloatingButtonState();
}

class FloatingButtonState extends State<MyFloatingButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20, right: 20),
      alignment: Alignment.bottomRight,
      child: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
              context: context,
              builder: (BuildContext context) {
                return const Text('aca se llamaria a la pantalla de creación de Nota');
              });
        },
        // child: const Icon(Icons.addchart_sharp),
        child: const Icon(Icons.post_add_rounded),
      ),
    );
  }
}


