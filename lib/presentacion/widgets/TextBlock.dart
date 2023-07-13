// ignore_for_file: use_key_in_widget_constructors, must_be_immutable

import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:quill_html_editor/quill_html_editor.dart';
import 'package:html/parser.dart' as htmlParser;
import 'package:image_picker/image_picker.dart';

import 'package:notea_frontend/presentacion/pantallas/Speech_to_Text_Screen.dart';
import 'package:notea_frontend/aplicacion/ImagenATexto.dart';

class TextBlocPrueba3 extends StatefulWidget {
  String? cuerpo;
  TextBlocPrueba3({Key? key, this.cuerpo});
  @override
  State<TextBlocPrueba3> createState() => _TextBlocPrueba3();
  final QuillEditorController _editorKey = QuillEditorController();
  QuillEditorController get editorKey => _editorKey;
}

class _TextBlocPrueba3 extends State<TextBlocPrueba3> {
  @override
  void initState() {
    super.initState();
  }

  Future<String?>? getEditorValue() async {
    String? htmlText = await widget._editorKey.getText();
    return htmlText;
  }

  void customAction(String action) {
    if (action == 'action1') {
      getEditorValue()!.then((textoNota) {
        String text = htmlParser.parse(textoNota).documentElement!.text;
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SpeechToTextScreen(textoNota: text),
          ),
        ).then((value) {
          if (value != null) {
            setState(() {
              // Lógica para actualizar el estado con el valor devuelto de SpeechToTextScreen
              widget._editorKey.setText(value);
            });
          }
        });
      });
    } else if (action == 'action2') {
      setState(() async {
        Future<String> future = imagenATexto().EscanearTexto(
            await ImagePicker().pickImage(source: ImageSource.gallery));
        String textoEscaneado = await future;
        widget._editorKey.setText(textoEscaneado);
      });
    } else if (action == 'action3') {
      setState(() async {
        Future<String> future = imagenATexto().EscanearTexto(
            await ImagePicker().pickImage(source: ImageSource.camera));
        String textoEscaneado = await future;
        widget._editorKey.setText(textoEscaneado);
      });
    }
  }

  final customToolBarList = [
    ToolBarStyle.bold,
    ToolBarStyle.italic,
    ToolBarStyle.underline,
    ToolBarStyle.strike,
    ToolBarStyle.size,
    ToolBarStyle.blockQuote,
    ToolBarStyle.align,
    ToolBarStyle.listBullet,
    ToolBarStyle.listOrdered,
    ToolBarStyle.color,
    ToolBarStyle.background,
    ToolBarStyle.link,
    ToolBarStyle.clean,
    ToolBarStyle.headerOne,
    ToolBarStyle.headerTwo,
    ToolBarStyle.undo,
    ToolBarStyle.redo,
  ];

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.only(bottom: 20),
        child: Scaffold(
          body: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              return Container(
                height: 320,
                width: constraints.maxWidth *
                    1, // Establece el ancho al 90% del padre
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Color.fromARGB(255, 158, 158, 158),
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
                                  color:
                                      const Color.fromARGB(64, 158, 158, 158),
                                  width: 1.0,
                                ),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              child: FractionallySizedBox(
                                widthFactor:
                                    0.9, // Establece el ancho al 90% del padre
                                child: ConstrainedBox(
                                  constraints:
                                      const BoxConstraints(maxHeight: 255),
                                  child: QuillHtmlEditor(
                                    text: widget.cuerpo ?? '',
                                    hintText:
                                        'Ingrese el contenido de su nota...',
                                    controller: widget._editorKey,
                                    isEnabled: true,
                                    minHeight: 255,
                                    hintTextAlign: TextAlign.start,
                                    padding: const EdgeInsets.all(2),
                                    hintTextPadding: EdgeInsets.zero,
                                    // onFocusChanged: (hasFocus) => debugPrint('has focus $hasFocus'),
                                    // onTextChanged: (text) => debugPrint('widget text change $text'),
                                    // onEditorCreated: () => debugPrint('Editor has been loaded'),
                                    // onEditorResized: (height) =>
                                    // debugPrint('Editor resized $height'),
                                    // onSelectionChanged: (sel) =>
                                    // debugPrint('${sel.index},${sel.length}')
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 41,
                      width: constraints.maxWidth,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: [
                          SizedBox(
                            width: constraints.maxWidth * 2.1,
                            child: ToolBar(
                              controller: widget._editorKey,
                              toolBarConfig: customToolBarList,
                              activeIconColor: Colors.blue,
                              runSpacing: BorderSide.strokeAlignCenter,
                              runAlignment: WrapAlignment.center,
                              direction: Axis.horizontal,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
