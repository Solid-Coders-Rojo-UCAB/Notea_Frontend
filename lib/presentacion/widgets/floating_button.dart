import 'package:flutter/material.dart';


class MyFloatingButton extends StatefulWidget {
  final Function callback;
  const MyFloatingButton({super.key, required this.callback});

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
                return const Text('hola');
              });
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}


