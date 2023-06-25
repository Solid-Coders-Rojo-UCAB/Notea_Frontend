// ignore_for_file: file_names, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

const h1 = TextStyle(
  fontSize: 37,
  fontWeight: FontWeight.bold,
  color: Colors.black,
);

const h2 = TextStyle(
  fontSize: 28,
  fontWeight: FontWeight.bold,
  color: Colors.black,
);

const h3 = TextStyle(
  fontSize: 22,
  fontWeight: FontWeight.bold,
  color: Colors.black,
);

const text = TextStyle(
  fontSize: 16,
  height: 1.5,
  fontWeight: FontWeight.normal,
  color: Color.fromARGB(155, 0, 0, 0),
);

const negritaTipo = TextStyle(
  fontSize: 16,
  height: 1.5,
  fontWeight: FontWeight.bold,
  color: Color.fromARGB(155, 0, 0, 0),
);
const negrita = TextStyle(
  fontSize: 16,
  height: 1.5,
  fontWeight: FontWeight.bold,
);

const cursiva = TextStyle(
  fontSize: 16,
  height: 1.5,
  fontStyle: FontStyle.italic,
  color: Color.fromARGB(155, 0, 0, 0),
);

const tachado = TextStyle(
  fontSize: 16,
  height: 1.5,
  decoration: TextDecoration.lineThrough,
  color: Color.fromARGB(155, 0, 0, 0),
);

const sobrescrito = TextStyle(
  fontSize: 16,
  height: 1.5,
  textBaseline: TextBaseline.alphabetic,
  color: Color.fromARGB(155, 0, 0, 0),
);

const subrayado = TextStyle(
  fontSize: 16,
  height: 1.5,
  decoration: TextDecoration.underline,
  color: Color.fromARGB(155, 0, 0, 0),
);

class TextBlock extends StatefulWidget {
  TextBlock({Key? key}) : super(key: key);

  final TextEditingController controller = TextEditingController();
  final FocusNode focus = FocusNode();
  final FocusNode rawKeyboardFocus = FocusNode();

  @override
  _TextBlockState createState() => _TextBlockState();
}

class _TextBlockState extends State<TextBlock> {
  String dropdownValue = 'One';
  Color backgroundColor = Colors.transparent;
  double opacity = 0;
  bool renderBlockChange = false;                     //Esta es la variable que se encarga de mostrar o no el  menu desplegable de NEGRITAS, IMAGENES
  TextStyle activeStyle = text;

  List<FocusNode> styleNodes = [
    FocusNode(),
    FocusNode(),
    FocusNode(),
    FocusNode(),
  ];

  @override
  void initState() {
    super.initState();
    widget.focus.addListener(() {
      if (!widget.focus.hasFocus
          && !styleNodes[0].hasFocus
          && !styleNodes[1].hasFocus
          && !styleNodes[2].hasFocus
          && !styleNodes[3].hasFocus) {
        setState(() {
          renderBlockChange = false;
          backgroundColor = Colors.transparent;
          opacity = 0;
        });
      }
    });
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the widget tree.
    // This also removes the _printLatestValue listener.
    // print('disposed');
    // widget.focus.dispose();
    // widget.RawKeyboardFocus.dispose();
    // widget.controller.dispose();
    super.dispose();
  }

  _onEnter(e) {
    setState(() {
      backgroundColor = Colors.black12;       //Cuando se le pasa el mouse por encima cambia de color (es un HOVER de csss)
      opacity = 1;
    });
  }

  _onExit(e) {
    setState(() {
      if (!renderBlockChange) {
        backgroundColor = Colors.transparent; //Cuando se le pasa el mouse por encima cambia de color (es un HOVER de csss)
        opacity = 0;
      }
    });
  }

  handleKey(key) {
    if (key.runtimeType == RawKeyDownEvent) {
      if (key.data.keyLabel == 'Escape' || key.logicalKey.keyLabel == 'Escape') {
        setState(() {
          renderBlockChange = !renderBlockChange;                       //Setea al valor contrario al que estaba
          if (renderBlockChange) {                                      //Si es true, pone el fondo con negro
            backgroundColor = Colors.black12; 
            opacity = 1;
          }
          else {
            backgroundColor = Colors.transparent;                     //Si es false, pone el fondo trasnparente
            opacity = 0;
            widget.focus.requestFocus();
          }
        });
      }
    }
  }

  TextStyle?  activarEstilo(String estilo) {
    final Map<String, TextStyle> estilos = {
      'negrita': negrita,
      'cursiva': cursiva,
      'tachado': tachado,
      'subrayado': subrayado,
    };
    renderBlockChange = renderBlockChange;
    return estilos[estilo];
}

  @override
  Widget build(BuildContext context) {
    return RawKeyboardListener(
      focusNode: widget.rawKeyboardFocus,
      onKey: (RawKeyEvent key) => handleKey(key),
      child: MouseRegion(
        onEnter: (e) => _onEnter(e),        //HOVER
        onExit: (e) => _onExit(e),          //HOVER
        child: AnimatedContainer(
          margin: const EdgeInsets.only(bottom: 20),
          height: renderBlockChange ? 180 : 105,
          // height: renderBlockChange ? 190 : 120,
          // height: renderBlockChange ? 170 : 100,
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
              color: backgroundColor, borderRadius: BorderRadius.circular(20)),
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Row(
                children: [
                  AnimatedOpacity(
                      opacity: opacity,
                      duration: const Duration(milliseconds: 200),
                      child: Container(
                        margin: const EdgeInsets.only(right: 20),
                        child: Column(
                          children: [
                            IconButton(icon: const Icon(Icons.menu, color: Colors.black38), onPressed: () {    //Aca el boton del menu desplegable
                              setState(() {
                                renderBlockChange = !renderBlockChange;   //Esto cambia el valor true o false
                              });
                            }),
                          ],
                        )
                      )),
                  Flexible(
                    child: TextField(
                      cursorColor: Colors.black12,
                      style: activeStyle,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.deny('\n'),
                      ],
                      decoration: const InputDecoration(
                        labelText: 'Texto',
                        labelStyle: TextStyle(color: Colors.grey),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                      ),
                      controller: widget.controller,
                      focusNode: widget.focus,
                      autofocus: false,
                      maxLines: null,
                      // maxLines: null,
                    ),
                  ),
                ],
              ),
              Expanded(
                child: AnimatedContainer(
                  margin: const EdgeInsets.only(top: 12, left: 60),
                  duration: const Duration(milliseconds: 200),
                  height: renderBlockChange ?  70 : 0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      //Fila con los primeros botones
                      Expanded(
                        child:Row(
                          children: [
                            Expanded(
                              child: ListView(
                                children: [
                                  TextButton(
                                    focusNode: styleNodes[0],
                                    child: Container(
                                      padding: const EdgeInsets.all(5),
                                      child: const Text(
                                        'Negrita',
                                        style: negritaTipo,
                                      ),
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        activeStyle = activarEstilo('negrita')!;
                                        renderBlockChange = true;
                                        opacity = 0;
                                        backgroundColor = Colors.transparent;
                                        widget.focus.requestFocus();
                                      });
                                    },
                                  ),
                                  TextButton(
                                    focusNode: styleNodes[1],
                                    child: Container(
                                      padding: const EdgeInsets.all(5),
                                      child: const Text(
                                        'Cursiva',
                                        style: cursiva,
                                      ),
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        activeStyle = activarEstilo('cursiva')!;
                                        renderBlockChange = true;
                                        opacity = 0;
                                        backgroundColor = Colors.transparent;
                                        widget.focus.requestFocus();
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      //Fila con los segundos botones
                      Expanded(
                        child:Row(
                          children: [
                            Expanded(
                              child: ListView(
                                children: [
                                  TextButton(
                                    focusNode: styleNodes[0],
                                    child: Container(
                                      padding: const EdgeInsets.all(5),
                                      child: const Text(
                                        'Tachado',
                                        style: tachado,
                                      ),
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        activeStyle = activarEstilo('tachado')!;
                                        renderBlockChange = true;
                                        opacity = 0;
                                        backgroundColor = Colors.transparent;
                                        widget.focus.requestFocus();
                                      });
                                    },
                                  ),
                                  TextButton(
                                    focusNode: styleNodes[1],
                                    child: Container(
                                      padding: const EdgeInsets.all(5),
                                      child: const Text(
                                        'Subrayado',
                                        style: subrayado,
                                      ),
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        activeStyle = activarEstilo('subrayado')!;
                                        renderBlockChange = true;
                                        opacity = 0;
                                        backgroundColor = Colors.transparent;
                                        widget.focus.requestFocus();
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      //Fila con el ultimo boton para salir del menu
                      Expanded(
                        child:Row(
                          children: [
                            Expanded(
                              child: ListView(
                                children: [
                                  IconButton(icon: const Icon(Icons.close, color: Colors.red), onPressed: () {    //Aca el boton del menu desplegable
                                    setState(() {
                                      renderBlockChange = !renderBlockChange;   //Esto cambia el valor true o false
                                    });
                                  }),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
