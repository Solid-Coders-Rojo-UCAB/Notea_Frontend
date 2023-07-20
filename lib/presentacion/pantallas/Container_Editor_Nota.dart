// ignore_for_file: library_private_types_in_public_api, file_names

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:notea_frontend/dominio/agregados/usuario.dart';
import 'package:notea_frontend/presentacion/widgets/ImageBlock.dart';
import 'package:notea_frontend/presentacion/widgets/TareaBlock.dart';
import 'package:notea_frontend/presentacion/widgets/TextBlock.dart';
import 'package:notea_frontend/presentacion/widgets/TextBlock.dart';
import 'package:notea_frontend/presentacion/widgets/textOptions.dart';


class ContainerEditorNota extends StatefulWidget {
  final  List<dynamic>? contenidoTotal1;
  final Usuario usuario;
  final Function(String, List<dynamic>) onDataReceived;

  const ContainerEditorNota({super.key, required this.onDataReceived, this.contenidoTotal1, required this.usuario});

  @override
  _ContainerEditorNotaState createState() => _ContainerEditorNotaState();
}

class _ContainerEditorNotaState extends State<ContainerEditorNota> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController titleController = TextEditingController();
  final int altuAc = 0;

  final focusNode = FocusNode();
  final  List<dynamic> _children = [


    // TextBlock(),
  ];
  var canDelete = false;

  @override
  void initState() {
    super.initState();
    print('Antes del != contenido');
    if (widget.contenidoTotal1 != null) {
    print('Despues del != contenido');
      List<dynamic> contenidoList = widget.contenidoTotal1!;
    print('Despues del != contenido LISTAAAAAAA');
      for (var item in contenidoList) {
        var id = item['id'];
        if (item.containsKey('texto')) {
          var cuerpo = item['texto']['cuerpo'];
          _children.add(
            TextBlocPrueba3(cuerpo: cuerpo, id: id,  usuario: widget.usuario,),           //Aca se agrega el texblock que indica el contenido
          );
        } else if (item.containsKey('imagen')) {
          var imagen = item['imagen'];
          // Realizar acción para imagen
          _children.add(
            ImageBlock(nombre: imagen['nombre'],base64: imagen['buffer'], id: id,),           //Aca se agrega el texblock que indica el contenido
          );
        } else if (item.containsKey('tareas')) {
          var tareas = item['tareas'];
          // Realizar acción para tarea
          _children.add(TareaBlock(tareas: tareas, id: id,));      //Aca se agrega la tarea que indica el contenido
        }
      }

    }else {
      _children.add(
        TextBlocPrueba3( usuario: widget.usuario,),           //Ahora esto maneja lo de los estilos mis oabna 
      );
    }
    reload();
    sendDataToWrapperWidget();
  }

  @override
  void dispose() {
    focusNode.dispose();
    super.dispose();
  }

  void reload() async{
    setState(() {
    });
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
            _children.insert(i + 1, TextBlocPrueba3( usuario: widget.usuario,));                       //Le insertas a _children un nuevo TextBlock
            _children[i + 1].focus.requestFocus();                          //y ahora selecciona el focus del nuevo TextBlock
          }
        }
        _children.insert(_children.length + 1, TextBlocPrueba3( usuario: widget.usuario,));
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


  // Con esta función enviamos la data al padre
  void sendDataToWrapperWidget() {
    widget.onDataReceived('data', _children);
  }

  //Esta funcion es la encargada de asignar la altura deacuerdo a la cantidad de componentes en _children
  int calcularAlturaPadre(List<dynamic> lista){
    int altura = 100;
      for (var element in lista) {
        if (element is TextBlocPrueba3){
          altura += 350;
        }
        if (element is ImageBlock){
          altura += 400;
        }
        if (element is TareaBlock){
          altura += 150 + 45 * element.cantTareas;
        }
      }
    return altura;
  }

  Widget _textBuilder() {
    return SingleChildScrollView(
      controller: _scrollController,
      child: SizedBox(
        height: calcularAlturaPadre(_children).toDouble(), //Aca se establece la altura de  los hijos, ESTO REVISARLO
        child: Align(
          alignment: Alignment.topCenter,
          child: Padding(
            padding: const EdgeInsets.all(16.0), //16
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
                          title: Text('Agregar Texto'),
                        ),
                      ),
                      const PopupMenuItem<String>(
                        value: 'image_block',
                        child: ListTile(
                          leading: Icon(Icons.image),
                          title: Text('Agregar Imagen'),
                        ),
                      ),
                      const PopupMenuItem<String>(
                        value: 'tarea_block',
                        child: ListTile(
                          leading: Icon(Icons.list),
                          title: Text('Agregar Tarea'),
                        ),
                      ),
                    ],
                    onSelected: (String value) {
                      setState(() {
                        if (value == 'text_block') {
                          _children.add(
                            TextBlocPrueba3( usuario: widget.usuario,),           //Ahora esto maneja lo de los estilos mis oabna
                          );
                        }else if (value == 'image_block') {
                          _children.add(ImageBlock());
                        }else if (value == 'tarea_block') {
                          _children.add(TareaBlock());
                        }
                        sendDataToWrapperWidget();          //Esto es mejorable, hay que agregar al menos otros componente de la lista para que se guarde
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
        body: Builder(
          builder: (context) {
            return _textBuilder();
          },
        ),
      ),
    );
  }
}

