// ignore_for_file: file_names, library_private_types_in_public_api

import 'package:flutter/material.dart';

class Grupo {
  final int id;
  final String nombre;
  final int usuario;

  Grupo({required this.id, required this.nombre, required this.usuario});
}

class GrupoList extends StatefulWidget {

  final Function(Grupo) onDataReceived;
  const GrupoList({Key? key, required this.onDataReceived}) : super(key: key);

  @override
  _GrupoListState createState() => _GrupoListState();
}

class _GrupoListState extends State<GrupoList> {
  List<Grupo> grupos = [      //LISTA DE GRUPOS QUE SE SUPONE SE RECIBIRAN POR PARAMETROS
    Grupo(id: 1, nombre: 'Grupo 1', usuario: 1),
    Grupo(id: 2, nombre: 'Grupo 2', usuario: 2),
    Grupo(id: 3, nombre: 'Grupo 3', usuario: 1),
    Grupo(id: 4, nombre: 'Grupo 4', usuario: 2),
  ];

  Grupo? selectedGrupo;


  void sendDataToWrapperWidget() {
    widget.onDataReceived(selectedGrupo!);
  }

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
                    'Seleccionar Grupo',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16.0),
                  SizedBox(
                    height: 200,
                    child: ListView.builder(
                      itemCount: grupos.length,
                      itemBuilder: (context, index) {
                        final grupo = grupos[index];
                        return Card(
                          child: RadioListTile<Grupo>(
                            title: Text(grupo.nombre),
                            value: grupo,
                            groupValue: selectedGrupo,
                            onChanged: (value) {
                              setState(() {
                                selectedGrupo = value;
                              });
                              sendDataToWrapperWidget();
                            },
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  ElevatedButton(
                    onPressed: () {
                      if (selectedGrupo != null) {
                        Navigator.pop(context, selectedGrupo);
                      }
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
          selectedGrupo = value;
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
              setState(() {}); // Actualiza el estado para mostrar el grupo seleccionado
            },
            child: const Text('Grupo'),
          ),
          const SizedBox(height: 16.0),
          Text('Grupo seleccionado: ${selectedGrupo?.nombre ?? ''}'),
        ],
      ),
    );
  }
}