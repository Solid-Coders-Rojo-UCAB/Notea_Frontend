import 'package:flutter/material.dart';

class CartaWidget extends StatelessWidget {
  final DateTime fecha;
  final String titulo;
  final String contenido;
  final List<String> tags;
  final VoidCallback? onDeletePressed;
  final VoidCallback? onChangePressed;

  CartaWidget({
    required this.fecha,
    required this.titulo,
    required this.contenido,
    required this.tags,
    this.onDeletePressed,
    this.onChangePressed,
  });

  @override
  Widget build(BuildContext context) {
    String formattedDate = fecha.month < 9 ? '0${fecha.month} - ${fecha.day}' : '${fecha.month} - ${fecha.day}'; // Formateo de la fecha
    return FractionallySizedBox(
      widthFactor: 0.65, // Establece el ancho al 70% del tamaño disponible
      child:GestureDetector(
        onTap: () {
          print('SE ABRE LA PANTALLA PARA EDITAR LA NOTA');
        },
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  constraints: const BoxConstraints(
                    maxWidth: 100, // Establece el ancho máximo para el contenedor
                  ),
                  child: Text(
                    formattedDate,
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0,
                    ),
                    overflow: TextOverflow.ellipsis, // Muestra "..." si el texto es demasiado largo
                  ),
                ),
                const SizedBox(height: 16.0),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 24.0,
                      height: 24.0,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.blue, // Cambiar el color del círculo según tus necesidades
                      ),
                    ),
                    const SizedBox(width: 8.0),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          Container(
                            constraints: const BoxConstraints(
                              maxWidth: 250, // Establece el ancho máximo para el contenedor
                            ),
                            child: Text(
                              titulo,
                              style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 16.0,
                              ),
                              overflow: TextOverflow.ellipsis, // Muestra "..." si el texto es demasiado largo
                            ),
                          ),
                          const SizedBox(height: 8.0),
                          Container(
                            constraints: const BoxConstraints(
                              maxWidth: 300, // Establece el ancho máximo para el contenedor
                            ),
                            child: Text(
                              contenido,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14.0,
                              color: Color.fromARGB(125, 0, 0, 0),
                              ),
                              overflow: TextOverflow.ellipsis, // Muestra "..." si el texto es demasiado largo
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Row(
                      
                      children: tags.map((tag) => TagWidget(tag: tag)).toList(),
                    ),
                    Expanded(
                      
                     child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                            IconButton(
                              icon: const Tooltip(
                                message: 'Eliminar',
                                child: Icon(
                                  Icons.delete,
                                  color: Color.fromARGB(255, 20, 18, 18),
                                ),
                              ),
                              onPressed: onDeletePressed,
                            ),
                            IconButton(
                              icon: const Tooltip(
                                message: 'Recuperar',
                                child: Icon(
                                  Icons.autorenew,
                                  color: Color.fromARGB(255, 20, 18, 18),
                                ),
                              ),
                              onPressed: onChangePressed,
                            ),
                  ]),
                   ),
                  ],
                ),
              ],
            ),
          ),
        ),
      )
    );
  }

  toList() {}
}

class TagWidget extends StatelessWidget {
  final String tag;

  TagWidget({required this.tag});

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(
        maxWidth: 45, // Establece el ancho máximo para el contenedor
      ),
      margin: const EdgeInsets.only(right: 8.0),
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4.0),
        color: const Color(0xFF21579C),
      ),
      child: Text(
        tag,
        style: const TextStyle(
            fontSize: 12.0, fontWeight: FontWeight.w300, color: Colors.white),
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
