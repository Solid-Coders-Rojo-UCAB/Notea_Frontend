// ignore_for_file: library_private_types_in_public_api, unused_element

import 'package:flutter/material.dart';
import 'package:notea_frontend/presentacion/pantallas/angel/container.dart';



class WrapperWidget extends StatefulWidget {
  const WrapperWidget({Key? key}) : super(key: key);

  @override
  _WrapperWidgetState createState() => _WrapperWidgetState();
}

class _WrapperWidgetState extends State<WrapperWidget> {
  String receivedData = '';

  void handleDataReceived(String data) {
    setState(() {
      receivedData = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Wrapper Widget'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Dato recibido: $receivedData',
            style: const TextStyle(fontSize: 18),
          ),
          Expanded(  // Envuelve ContainerPro con Expanded
            child: ContainerPro(
              onDataReceived: handleDataReceived,
            ),
          ),
        ],
      ),
    );
  }
}
