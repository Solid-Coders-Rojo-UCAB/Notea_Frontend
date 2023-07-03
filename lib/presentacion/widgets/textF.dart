// ignore_for_file: use_key_in_widget_constructors, library_private_types_in_public_api, file_names

import 'package:flutter/material.dart';
import 'package:notea_frontend/presentacion/pantallas/Speech_to_Text_Screen.dart';
import 'package:rich_editor/rich_editor.dart';

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

  void customAction(String action) {
    // Lógica para las acciones personalizadas
    if (action == 'action1') {
      Navigator.push(context, 
        MaterialPageRoute(builder: (context) => 
          const SpeechToTextScreen(textoNota: '')))
          .then((value) => setState(() {
            //nos devuelve el texto de la nota
            }));
      // Acción 1
    } else if (action == 'action2') {
      print('Accion 2');
      // Acción 2
    }
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
                value: '',
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
                  child: Text('Audio a Texto'),
                ),
                const PopupMenuItem<String>(
                  value: 'action2',
                  child: Text('Imagen a Texto'),
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
