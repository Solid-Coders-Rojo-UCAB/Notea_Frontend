// ignore_for_file: use_key_in_widget_constructors, library_private_types_in_public_api, file_names

import 'package:flutter/material.dart';
import 'package:notea_frontend/aplicacion/ImagenATexto.dart';
import 'package:notea_frontend/presentacion/pantallas/Speech_to_Text_Screen.dart';
import 'package:rich_editor/rich_editor.dart';
import 'package:image_picker/image_picker.dart';
import 'package:html/parser.dart' as htmlParser;

class TextBlockPrueba1 extends StatefulWidget {
  TextBlockPrueba1({Key? key});

  final GlobalKey<RichEditorState> _editorKey = GlobalKey<RichEditorState>();

  GlobalKey<RichEditorState> get editorKey => _editorKey;

  @override
  _TextBlockPrueba1State createState() => _TextBlockPrueba1State();
}

class _TextBlockPrueba1State extends State<TextBlockPrueba1> {
  @override
  void dispose() {
    super.dispose();
  }

  Future<String?>? getEditorValue() async {
    if (widget._editorKey.currentState != null) {
      String? html = await widget._editorKey.currentState?.getHtml();
      return html;
    }
    return null;
  }

  String hola = 'holaasa';

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
              widget._editorKey.currentState!
                  .setHtml(value); //nO SE POR QUE NO FUNCIONA
            });
          }
        });
      });
    } else if (action == 'action2') {
      print('Accion 2');

      setState(() async {
        Future<String> future = imagenATexto().EscanearTexto(
            await ImagePicker().pickImage(source: ImageSource.gallery));
        String textoEscaneado = await future;
        widget._editorKey.currentState!.setHtml(textoEscaneado);
      });
    } else if (action == 'action3') {
      print('Accion 3');
      setState(() async {
        Future<String> future = imagenATexto().EscanearTexto(
            await ImagePicker().pickImage(source: ImageSource.camera));
        String textoEscaneado = await future;
        widget._editorKey.currentState!.setHtml(textoEscaneado);
      });
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(20),
        margin: const EdgeInsets.only(bottom: 20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
          border: Border.all(
            color: Colors.grey,
            width: 1.0,
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: RichEditor(
                key: widget._editorKey,
                value: hola,
                editorOptions: RichEditorOptions(
                  placeholder: 'Start typing',
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  baseFontFamily: 'sans-serif',
                  barPosition: BarPosition.BOTTOM,
                ),
              ),
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
          ],
        ),
      ),
    );
  }
}
