// ignore_for_file: file_names, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:notea_frontend/dominio/agregados/grupo.dart';

class Grupa {
  final int id;
  final String nombre;
  final int usuario;

  Grupa({required this.id, required this.nombre, required this.usuario});
}

class GrupoList extends StatefulWidget {
  final List<Grupo>? grupos;
  final Function(Grupo) onDataReceived;
  const GrupoList({Key? key, required this.onDataReceived, required this.grupos}) : super(key: key);

  @override
  _GrupoListState createState() => _GrupoListState();
}

class _GrupoListState extends State<GrupoList> {
  List<Grupa> grupas = [      //LISTA DE GRUPOS QUE SE SUPONE SE RECIBIRAN POR PARAMETROS
    Grupa(id: 1, nombre: 'Grupa 1', usuario: 1),
    Grupa(id: 2, nombre: 'Grupa 2', usuario: 2),
    Grupa(id: 3, nombre: 'Grupa 3', usuario: 1),
    Grupa(id: 4, nombre: 'Grupa 4', usuario: 2),
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
                      itemCount: widget.grupos?.length,
                      itemBuilder: (context, index) {
                        final grupo =  widget.grupos?[index];
                        return Card(
                          child: RadioListTile<Grupo>(
                            title: Text(grupo!.getNombre()),
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
          Text('Grupo seleccionado: ${selectedGrupo?.getNombre() ?? ''}'),
        ],
      ),
    );
  }
}