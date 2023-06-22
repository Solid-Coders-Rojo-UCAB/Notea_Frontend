import 'package:flutter/material.dart';

class Desplegable extends StatefulWidget {
  final String titulo;
  final Widget contenido;

  Desplegable({required this.titulo, required this.contenido});

  @override
  _DesplegableState createState() => _DesplegableState();
}

class _DesplegableState extends State<Desplegable> {
  bool _mostrarContenido = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        GestureDetector(
          onTap: () {
            setState(() {
              _mostrarContenido = !_mostrarContenido;
            });
          },
          child: Container(
            width: MediaQuery.of(context).size.width * 0.7,
            color: Colors.grey[200],
            padding: EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Flexible(
                  child: Text(
                    widget.titulo,
                    style: TextStyle(
                      fontSize: _mostrarContenido ? 16.0 : 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Icon(
                  _mostrarContenido ? Icons.expand_less : Icons.expand_more,
                  size: 30.0,
                ),
              ],
            ),
          ),
        ),
        if (_mostrarContenido)
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: widget.contenido,
          ),
        SizedBox(height: 16.0), // Separación entre los desplegables
      ],
    );
  }
}
