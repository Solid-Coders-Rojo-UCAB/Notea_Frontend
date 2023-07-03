// ignore_for_file: use_key_in_widget_constructors, library_private_types_in_public_api, file_names
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:notea_frontend/presentacion/pantallas/Speech_to_Text_Screen.dart';

class TextBlockPrueba extends StatefulWidget {

  //hay que pasarle el texto de la nota

  @override
  _TextBlockPruebaState createState() => _TextBlockPruebaState();
}

class _TextBlockPruebaState extends State<TextBlockPrueba> {
  TextEditingController textEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.0),
            border: Border.all(
              color: Colors.grey,
              width: 1.0,
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: TextField(
                  controller: textEditingController,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.all(16.0),
                  ),
                  maxLines: null, // Permite que el TextField crezca verticalmente
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: PopupMenuButton<String>(
                  itemBuilder: (context) => [
                    const PopupMenuItem<String>(
                      value: 'cameraToText',
                      child: Text('Cámara a Texto'),
                    ),
                    const PopupMenuItem<String>(
                      value: 'audioToText',
                      child: Text('Audio a Texto'),
                    ),
                    const PopupMenuItem<String>(
                      value: 'changeStyle',
                      child: Text('Cambiar Estilo'),
                    ),
                  ],
                  onSelected: (value) {
                    // Aquí puedes manejar las distintas funcionalidades según lo seleccionado en el menú
                    switch (value) {
                      case 'cameraToText':
                        // Acción para la cámara a texto
                        break;
                      case 'audioToText':
                        // Navigator.push(context, 
                        // MaterialPageRoute(builder: (context) => 
                        //   SpeechToTextScreen(textoNota: )))
                        //   .then((value) => setState(() { 
                        //     //nos devuelve el texto de la nota
                        //    }));
                        break;
                      case 'changeStyle':
                        // Acción para cambiar el estilo
                        break;
                    }
                  },
                ),
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 20,
        ),
      ],
    );
  }

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }
}
