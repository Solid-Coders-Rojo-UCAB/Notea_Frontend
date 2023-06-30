import 'package:flutter/material.dart';

class Desplegable extends StatefulWidget {
  final String titulo;
  final Widget contenido;

  Desplegable({required this.titulo, required this.contenido});

  @override
  _DesplegableState createState() => _DesplegableState();
}

class _DesplegableState extends State<Desplegable> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  bool _mostrarContenido = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        GestureDetector(
          onTap: () {
            setState(() {
              _mostrarContenido = !_mostrarContenido;
              if (_mostrarContenido) {
                _animationController.forward();
              } else {
                _animationController.reverse();
              }
            });
          },
          child: Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(10.0), // Establece el radio de los bordes
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Flexible(
                  child: Text(
                    widget.titulo,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: _mostrarContenido ? 19.0 : 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                RotationTransition(
                  turns: _animation,
                  child: const Icon(
                    Icons.expand_less,
                    size: 30.0,
                  ),
                ),
              ],
            ),
          ),
        ),
        AnimatedBuilder(
          animation: _animationController,
          builder: (BuildContext context, Widget? child) {
            return ClipRect(
              child: Align(
                alignment: Alignment.topCenter,
                heightFactor: _animation.value,
                child: widget.contenido,
              ),
            );
          },
        ),
        const SizedBox(height: 16.0), // Separación entre los desplegables
      ],
    );
  }
}
