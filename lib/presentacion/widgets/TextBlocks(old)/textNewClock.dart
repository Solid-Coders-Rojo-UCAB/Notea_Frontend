// ignore_for_file: use_key_in_widget_constructors, must_be_immutable

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;

class TextBlocPrueba2 extends StatefulWidget {

  String? cuerpo;
  TextBlocPrueba2({Key? key, this.cuerpo});
  @override
  State<TextBlocPrueba2> createState() => _TextBlocPrueba2();
}


class _TextBlocPrueba2 extends State<TextBlocPrueba2> {

  final quill.QuillController _controller = quill.QuillController.basic();


var postContent = "<h2>My short post</h2><p>This is a <strong>really, really</strong> short post.</p>";
  @override
  void initState() {
    super.initState();
        var json = jsonEncode(_controller.document.toDelta().toJson());
        print('-------');
        print(json);
        print('-------');
    if (widget.cuerpo == null) {
    }
  }



  void customAction(String action) {

    if (action == 'action1') {
      print('Accion 1');

      // getEditorValue()!.then((textoNota) {
      //   String text = htmlParser.parse(textoNota).documentElement!.text;
      //   Navigator.push(
      //     context,
      //     MaterialPageRoute(
      //       builder: (context) => SpeechToTextScreen(textoNota: text),
      //     ),
      //   ).then((value) {
      //     if (value != null) {
      //       setState(() {
      //         // Lógica para actualizar el estado con el valor devuelto de SpeechToTextScreen
      //         widget._editorKey.currentState!
      //             .setHtml(value); //nO SE POR QUE NO FUNCIONA
      //       });
      //     }
      //   });
      // });
    } else if (action == 'action2') {
      print('Accion 2');

    //   setState(() async {
    //     Future<String> future = imagenATexto().EscanearTexto(
    //         await ImagePicker().pickImage(source: ImageSource.gallery));
    //     String textoEscaneado = await future;
    //     widget._editorKey.currentState!.setHtml(textoEscaneado);
    //   });
    // } else if (action == 'action3') {
    //   print('Accion 3');
    //   setState(() async {
    //     Future<String> future = imagenATexto().EscanearTexto(
    //         await ImagePicker().pickImage(source: ImageSource.camera));
    //     String textoEscaneado = await future;
    //     widget._editorKey.currentState!.setHtml(textoEscaneado);
    //   });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return SingleChildScrollView(
            child: Container(
              width: constraints.maxWidth * 1, // Establece el ancho al 90% del padre
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.grey,
                  width: 1.0,
                ),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(top: 38),
                      ),
                      PopupMenuButton<String>(
                        icon: const Icon(Icons.blur_on),
                        itemBuilder: (context) => [
                          const PopupMenuItem<String>(
                            value: 'action1',
                            child: Text('Audio a texto'),
                          ),
                          const PopupMenuItem<String>(
                            value: 'action2',
                            child: Text('Escanear imagen'),
                          ),
                          const PopupMenuItem<String>(
                            value: 'action3',
                            child: Text('Escanear una foto'),
                          ),
                        ],
                        onSelected: customAction,
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: const Color.fromARGB(64, 158, 158, 158),
                                width: 1.0,
                              ),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: FractionallySizedBox(
                              widthFactor: 0.9, // Establece el ancho al 90% del padre
                              child: quill.QuillEditor.basic(
                                controller: _controller,
                                readOnly: false,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10, // Ajusta la altura restando el espacio ocupado por otros elementos
                    width: constraints.maxWidth,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: 1, // Para que el ListView tenga solo un elemento
                      itemBuilder: (context, index) {
                        return SizedBox(
                          width: constraints.maxWidth , // Establece el ancho al 90% del padre
                          child: quill.QuillToolbar.basic(
                            controller: _controller,
                            iconTheme: const quill.QuillIconTheme(
                              borderRadius: 10,
                              iconSelectedFillColor: Colors.orange,
                              // iconUnselectedFillColor: Colors.red,
                              // iconUnselectedColor: Colors.red
                            ),
                            // customButtons:  [
                            //   quill.QuillCustomButton(
                            //     icon: Icons.delete, onTap: () {},        para usar botones  propios
                            //   )
                            // ],
                            multiRowsDisplay: false,
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

}