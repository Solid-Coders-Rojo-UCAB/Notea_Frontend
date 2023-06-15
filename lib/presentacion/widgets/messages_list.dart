import 'dart:async';

import 'package:flutter/material.dart';
import 'dart:math';

import 'package:notea_frontend/presentacion/widgets/dialogs.dart';



class MessagesList extends StatefulWidget {
  final String userId;
  final Function callback2;
  const MessagesList({Key? key, required this.userId, required  this.callback2}) : super(key: key);

  @override
  State<MessagesList> createState() => _MessagesListState();
}

class _MessagesListState extends State<MessagesList> {
  DialogsInfo d = DialogsInfo();
  bool hover = true;


  DateTime parseDate(String dateString) {
    return DateTime.parse(dateString);
  }

  void callback() {
    //Funcion que se ejecuta al eliminar una nota
    catchUserNotes(); //Como se elimina la nota de la base de datos, debemos actualizar la lista de notas
  }

  @override
  void initState() {
    //Funcion que se ejecuta al iniciar el widget (se ejecuta solo una vez)
    super.initState();
    //Funcion para recuperar las notas del usuario
    Timer(const Duration(seconds: 1), () async {
      catchUserNotes();
    });
  }

  void catchUserNotes() async {
    //Captamos las notas del usuario que inicio sesion
    // String notesStrJSON =
    //     await Api.getUserNotes('/users/${widget.userId}/notes');
    // if (notesStrJSON == '{"error":"No notes found"}') {
    //   setState(() {
    //     listNotes =
    //         []; //COlocar logica para que indique que no tiene notas asignadas
    //   });
    // } else {
    //   List<Map<String, dynamic>> notasMap = (json.decode(notesStrJSON) as List)
    //       .map((i) => Map<String, dynamic>.from(i))
    //       .toList();

    //   listNotes = createUserNotesList(notasMap);
    //   listNotes.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
    // }
    // setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        shrinkWrap: true,
        // itemCount: listNotes.length,
        itemCount: 0,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (BuildContext context, int index) {
          // final note = listNotes[index];

          return TweenAnimationBuilder<double>(
            duration: Duration(
              milliseconds: (200 + (index * 100)).toInt() < 1500
                  ? (200 + (index * 100)).toInt()
                  : 1500,
            ),
            tween: Tween(begin: 0, end: 1),
            builder: (_, value, __) => TweenAnimationBuilder<double>(
              duration: const Duration(milliseconds: 500),
              tween: Tween(begin: (80 * index).toDouble(), end: 0),
              builder: ((_, paddingValue, __) => Container(
                    padding: EdgeInsets.only(top: paddingValue),
                    child: Opacity(
                      opacity: value,
                      child: SizedBox(
                        height: 190,
                        child: GestureDetector(
                          onTap: () {
                            viewNota('1', "1",'Titulo','Contenido de la nota');
                          },
                          child: MouseRegion(
                            onEnter: (h){
                              setState(() {
                                hover=false;
                              });
                            },
                            onExit: (h){
                              setState(() {
                                hover=true;
                              });
                            },
                            child: Card(
                              // color: hover ? Colors.grey[200] : Colors.white,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 10),
                                child: Container(
                                  margin: const EdgeInsets.only(bottom: 1),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        width: 40,
                                        height: 40,
                                        child: CircleAvatar(
                                          backgroundColor: Colors.primaries[Random()
                                              .nextInt(Colors.primaries.length)],
                                          radius: 100,
                                        ), //CircleAvatar
                                      ),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              parseDate('2023-04-14T19:01:28.332Z') as String,
                                              style: const TextStyle(
                                                  color: Colors.black54,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w400),
                                            ),
                                            const SizedBox(height: 3),
                                            const Text(
                                              'note.title',
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w700),
                                            ),
                                            const SizedBox(height: 6),
                                            Text(
                                              'note.content',
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  color:
                                                      Colors.black.withOpacity(0.8),
                                                  fontWeight: FontWeight.w400),
                                            ),
                                            const SizedBox(height: 6),
                                            Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.end,
                                              children: [
                                                const SizedBox(width: 120,),
                                                TextButton.icon(
                                                  onPressed: () {
                                                    d.confirm(
                                                        context,
                                                        'note.title',
                                                        'note.content',
                                                        '1',
                                                        widget.callback2
                                                        );
                                                  },
                                                  icon:
                                                      const Icon(Icons.delete_forever_rounded),
                                                  label:
                                                      const Text('Eliminar Nota'),
                                                  style: TextButton.styleFrom(
                                                    foregroundColor:
                                                        Colors.primaries[Random()
                                                            .nextInt(Colors
                                                                .primaries.length)],
                                                  ),
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  )),
            ),
          );
        });
  }

  void viewNota(String user, String idNote, String title, String content) {
    // estos sirven para colocar el contenido que se ha guardado
    final TextEditingController tituloController =
        TextEditingController(text: title);
    final TextEditingController contenidoController =
        TextEditingController(text: content);
    Navigator.of(context)
        .push(MaterialPageRoute<void>(builder: (BuildContext context) {
      return Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              children: [
                SizedBox(
                  height: 60,
                  child: TextButton.icon(
                      onPressed: Navigator.of(context).pop,
                      icon: const Icon(Icons.arrow_back),
                      label: const Text(
                        'Volver',
                        style: TextStyle(fontSize: 18),
                      )),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.grey[200],
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(bottom: 8),
                      child: Text(
                        'Título',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    TextFormField(
                      controller: tituloController,
                      maxLines: 1,
                      style: const TextStyle(fontSize: 20),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Título de tu nota',
                        hintStyle: TextStyle(
                          color: Colors.grey[400],
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.grey[200],
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(bottom: 8),
                      child: Text(
                        'Contenido',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    TextFormField(
                      controller: contenidoController,
                      maxLines: 10,
                      style: const TextStyle(fontSize: 20),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Contenido de tu nota',
                        hintStyle: TextStyle(
                          color: Colors.grey[400],
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            TextButton.icon(
              onPressed: () async {
                // if (await updateNote(idNote, user, tituloController.text,
                //     contenidoController.text)) {
                //   // ignore: use_build_context_synchronously
                //   Navigator.of(context).pop();
                //   callback(); //Función callback para actualizar la lista de notas
                //   // ignore: use_build_context_synchronously
                //   ScaffoldMessenger.of(context).showSnackBar(
                //     const SnackBar(
                //       content: Text('Nota Actualizada'),
                //     ),
                //   );
                // } else {
                //   // ignore: use_build_context_synchronously
                //   ScaffoldMessenger.of(context).showSnackBar(
                //     const SnackBar(content: Text('No se pudo actualizar')),
                //   );
                // }
              },
              icon: const Icon(Icons.save, color: Colors.white),
              label: const Text(
                'Guardar',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
              style: TextButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 178, 187, 192),
              ),
            ),
          ],
        ),
      );
    }));
  }
}
