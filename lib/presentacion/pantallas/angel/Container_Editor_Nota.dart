// ignore_for_file: library_private_types_in_public_api, file_names

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:notea_frontend/presentacion/pantallas/angel/ImageBlock.dart';
import 'package:notea_frontend/presentacion/pantallas/angel/TareaBlock.dart';
import 'package:notea_frontend/presentacion/pantallas/angel/TextBlock.dart';

class ContainerEditorNota extends StatefulWidget {
  const ContainerEditorNota({super.key});

  @override
  _ContainerEditorNotaState createState() => _ContainerEditorNotaState();
}

class _ContainerEditorNotaState extends State<ContainerEditorNota> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController titleController = TextEditingController();

  final focusNode = FocusNode();
  final  List<dynamic> _children = [
    TextBlock(),
  ];
  var canDelete = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    focusNode.dispose();
    super.dispose();
  }

  handleKey(key) {
    if (key.runtimeType == RawKeyDownEvent) {
      if (key.data.keyLabel == 'Backspace' || key.logicalKey.keyLabel == 'Backspace') {
        setState(() {
        for (var i = 0; i < _children.length; i++) {
          // print(_children[i].controller.text);
          if (i != 0
              && FocusScope.of(context).focusedChild == _children[i].focus  //Estas parado en el TextBlock seleccionado
              && _children[i].controller.text.isEmpty) {                //Y el texto esta vacio, y le das Backspace
            setState(() {
              canDelete = true;                                             //Ahora se puede eliminar
            });
          }
        }
      });
      }
      if (key.data.keyLabel == 'Enter' || key.logicalKey.keyLabel == 'Enter') {
        setState(() {
        for (var i = 0; i < _children.length; i++) {
          if (FocusScope.of(context).focusedChild == _children[i].focus) {  //Estas parado en el TextBlock seleccionado
            _children.insert(i + 1, TextBlock());                       //Le insertas a _children un nuevo TextBlock
            _children[i + 1].focus.requestFocus();                          //y ahora selecciona el focus del nuevo TextBlock
          }
        }
        _children.insert(_children.length + 1, TextBlock());
      });
      }
    }
    if (key.runtimeType == RawKeyUpEvent) {
      if (key.data.keyLabel == 'Backspace' || key.logicalKey.keyLabel == 'Backspace') {
        setState(() {
        for (var i = 0; i < _children.length; i++) {
          // print(_children[i].controller.text);
          if (i != 0
              && FocusScope.of(context).focusedChild == _children[i].focus    //Estas parado en el TextBlock seleccionado
              && _children[i].controller.text.isEmpty) {                  //Y el texto esta vacio, y le das Backspace
            if (canDelete) {
              setState(() {
                _children[i-1].focus.requestFocus();                          //y ahora selecciona el focus del TextBlock anterior
                _children.removeAt(i);                                        //Remueve ese TextBlock
                canDelete = false;                                            //Ahora NO se puede eliminar
              });
            }
          }
        }
      });
      }
    }
  }

  Widget _textBuilder() {
    return SingleChildScrollView(
      controller: _scrollController,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ..._children,
            IconButton(
              onPressed: () {},
              icon: PopupMenuButton<String>(
                icon: const Icon(Icons.add),
                offset: const Offset(-120, 10),
                itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                  const PopupMenuItem<String>(
                    value: 'text_block',
                    child: ListTile(
                      leading: Icon(Icons.text_fields),
                      title: Text('Agregar TextBlock'),
                    ),
                  ),
                  const PopupMenuItem<String>(
                    value: 'image_block',
                    child: ListTile(
                      leading: Icon(Icons.image),
                      title: Text('Agregar ImageBlock'),
                    ),
                  ),
                  const PopupMenuItem<String>(
                    value: 'tarea_block',
                    child: ListTile(
                      leading: Icon(Icons.list),
                      title: Text('Agregar TareaBlock'),
                    ),
                  ),
                ],
                onSelected: (String value) {
                  setState(() {
                    if (value == 'text_block') {
                      _children.add(TextBlock());
                    }else if (value == 'image_block') {
                      _children.add(const ImageBlock());
                    }else if (value == 'tarea_block') {
                      _children.add(const TareaBlock());
                    }
                  });
                  // Scroll hacia el nuevo bloque agregado
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    _scrollController.animateTo(
                      _scrollController.position.maxScrollExtent + 120, // Con esto se maneja cuanto scrool se recorre
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return RawKeyboardListener(
        focusNode: focusNode,
        onKey: (RawKeyEvent key) => handleKey(key),
        child: Scaffold(
          body: _textBuilder(),
        ));
  }

}
