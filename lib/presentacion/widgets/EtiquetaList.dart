// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';

class Tag {
  final int id;
  final String nombre;
  final int idUsuario;
  final Color color;

  Tag({
    required this.id,
    required this.nombre,
    required this.idUsuario,
    required this.color,
  });
}

class EtiquetaList extends StatefulWidget {
  const EtiquetaList({Key? key}) : super(key: key);

  @override
  _EtiquetaListState createState() => _EtiquetaListState();
}

class _EtiquetaListState extends State<EtiquetaList> {
  List<Tag> tags = [
    Tag(id: 1, nombre: 'Etiqueta 1', idUsuario: 1, color: Colors.blue),
    Tag(id: 2, nombre: 'Etiqueta 2', idUsuario: 1, color: Colors.green),
    Tag(id: 3, nombre: 'Etiqueta 3', idUsuario: 2, color: Colors.red),
    Tag(id: 4, nombre: 'Etiqueta 4', idUsuario: 2, color: Colors.indigo),
    Tag(id: 5, nombre: 'Etiqueta 5', idUsuario: 2, color: Colors.redAccent),
    Tag(id: 6, nombre: 'Etiqueta 6', idUsuario: 2, color: Colors.pink),
    // Agrega más etiquetas según tus necesidades
  ];

  List<Tag> selectedTags = [];

  void _openBottomSheet(BuildContext context) async {
    await showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Container(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'Seleccionar Etiquetas',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16.0),
                  Expanded(
                    child: ListView.builder(
                      itemCount: tags.length,
                      itemBuilder: (context, index) {
                        final tag = tags[index];
                        final isSelected = selectedTags.contains(tag);
                        return Card(
                          child: ListTile(
                            title: Text(tag.nombre),
                            trailing: Checkbox(
                              value: isSelected,
                              onChanged: (value) {
                                setState(() {
                                  if (isSelected) {
                                    selectedTags.remove(tag);
                                  } else {
                                    selectedTags.add(tag);
                                  }
                                });
                              },
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context, selectedTags);
                    },
                    child: const Text('Guardar'),
                  ),
                ],
              ),
            );
          },
        );
      },
    ).then((value) {
      if (value != null) {
        setState(() {
          selectedTags = List<Tag>.from(value);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          ElevatedButton(
            onPressed: () async {
              _openBottomSheet(context);
              setState(() {}); // Actualiza el estado para mostrar las etiquetas seleccionadas
            },
            child: const Text('Etiquetas'),
          ),
          const SizedBox(height: 16.0),
          Text('Etiquetas seleccionadas: ${selectedTags.length}'),
          Wrap(
            spacing: 8.0,
            runSpacing: 8.0,
            children: selectedTags.map((tag) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
                decoration: BoxDecoration(
                  color: tag.color,
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: Text(
                  tag.nombre,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
