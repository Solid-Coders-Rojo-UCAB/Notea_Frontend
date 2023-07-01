// ignore_for_file: library_private_types_in_public_api, file_names

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notea_frontend/dominio/agregados/grupo.dart';
import 'package:notea_frontend/infraestructura/bloc/nota/nota_bloc.dart';
import 'package:notea_frontend/infraestructura/bloc/usuario/usuario_bloc.dart';
import 'package:notea_frontend/presentacion/pantallas/home_screen.dart';
import 'package:notea_frontend/presentacion/widgets/TextBlock.dart';

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


class AnimatedButton extends StatefulWidget {
  final List<Grupo>? grupos;
  final Function(Grupo) onDataReceivedGrupo;
  final Function(List<dynamic>) onDataReceivedEtiqueta;
  final bool puedeCrear;

  final String tituloNota;
  final List<dynamic> listInfo;
  final Grupo? grupo;
  final List<dynamic> etiquetas;

  const AnimatedButton({Key? key, required this.onDataReceivedGrupo, required this.onDataReceivedEtiqueta, required this.grupos, required this.puedeCrear, required this.tituloNota, required this.listInfo, required this.grupo, required this.etiquetas}) : super(key: key);


  @override
  _AnimatedButtonState createState() => _AnimatedButtonState();
}

class _AnimatedButtonState extends State<AnimatedButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _opacityAnimation;
  late Animation<double> _scaleAnimation;

  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.5),
      ),
    );

    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.5, 1),
      ),
    );
  }

  //Boton de las Etiquetas--------------------------------
  List<Tag> selectedTags = [];
  void sendDataToWrapperWidgetEtiqueta() {
    widget.onDataReceivedEtiqueta(selectedTags);
  }
  List<Tag> tags = [
    Tag(id: 1, nombre: 'Etiqueta 1', idUsuario: 1, color: Colors.blue),
    Tag(id: 2, nombre: 'Etiqueta 2', idUsuario: 1, color: Colors.green),
    Tag(id: 3, nombre: 'Etiqueta 3', idUsuario: 2, color: Colors.red),
    Tag(id: 4, nombre: 'Etiqueta 4', idUsuario: 2, color: Colors.indigo),
    Tag(id: 5, nombre: 'Etiqueta 5', idUsuario: 2, color: Colors.redAccent),
    Tag(id: 6, nombre: 'Etiqueta 6', idUsuario: 2, color: Colors.pink),
    // Agrega más etiquetas según tus necesidades
  ];
  void openBottomSheetEtiqueta(BuildContext context) async {
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
                                  sendDataToWrapperWidgetEtiqueta();
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
  //Boton de las Etiquetas--------------------------------

  //Boton del Grupo--------------------------------
  Grupo? selectedGrupo;
  void sendDataToWrapperWidgetGrupo() {
    widget.onDataReceivedGrupo(selectedGrupo!);
  }
  void openBottomSheetGrupo(BuildContext context) async {
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
                              sendDataToWrapperWidgetGrupo();
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
  //Boton del Grupo--------------------------------

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _toggleExpanded() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });
  }

  Widget _buildExpandedButtons() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 80.0), // Ajusta el valor según tus necesidades
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FadeTransition(
            opacity: _opacityAnimation,
            child: ScaleTransition(
              scale: _scaleAnimation,
              child: ElevatedButton(
                onPressed: () {
                  openBottomSheetGrupo(context);
                  setState(() {});
                  _toggleExpanded();
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  padding: const EdgeInsets.all(10.0),
                  minimumSize: const Size(120, 60),
                ),
                child: const Text('Grupo'),
              ),
            ),
          ),
          const SizedBox(width: 16.0), // Espacio entre los botones
          FadeTransition(
            opacity: _opacityAnimation,
            child: ScaleTransition(
              scale: _scaleAnimation,
              child: ElevatedButton(
                onPressed: () {
                  openBottomSheetEtiqueta(context);
                  setState(() {});
                  _toggleExpanded();
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  padding: const EdgeInsets.all(10.0),
                  minimumSize: const Size(120, 60),
                ),
                child: const Text('Etiquetas'),
              ),
            ),
          ),
        ],
      ),
    );
  }



  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
          height: 100.0, // Altura fija del contenedor del botón principal
          child: Align(
            alignment: Alignment.bottomCenter,
            child: FloatingActionButton(
              onPressed: () => {
                _toggleExpanded(),
                // print("Boton de etiqueta presionado"),
                // if (widget.puedeCrear) {
                //   _crearNota()
                // }
              },
              shape: const CircleBorder(),
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              elevation: 2.0,
              child: AnimatedIcon(
                icon: AnimatedIcons.menu_close,
                progress: _animationController,
              ),
            ),
          ),
        ),
        if (_isExpanded) _buildExpandedButtons(),
      ],
    );
  }
}



