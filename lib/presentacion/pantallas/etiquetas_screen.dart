import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:notea_frontend/dominio/agregados/usuario.dart';
import 'package:notea_frontend/infraestructura/bloc/etiqueta/etiqueta_bloc.dart';

class EtiquetasScreen extends StatefulWidget {
  final Usuario usuario;

  const EtiquetasScreen({super.key, required this.usuario});

  @override
  _EtiquetasScreenState createState() => _EtiquetasScreenState();
}

class _EtiquetasScreenState extends State<EtiquetasScreen> {
  final TextEditingController _nombreEtiquetaController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    context
        .read<EtiquetaBloc>()
        .add(EtiquetaCatchEvent(idUsuarioDueno: widget.usuario.id));
  }

  String convertColorToEnum(Color color) {
    if (color == Colors.amber) {
      return 'AMBER';
    } else if (color == Colors.blue) {
      return 'BLUE';
    } else if (color == Colors.green) {
      return 'GREEN';
    } else if (color == Colors.orange) {
      return 'ORANGE';
    } else if (color == Colors.purple) {
      return 'PURPLE';
    } else if (color == Colors.red) {
      return 'RED';
    } else if (color == Colors.black) {
      return 'BLACK';
    } else if (color == Colors.indigo) {
      return 'INDIGO';
    } else {
      return 'BLUE'; // Valor por defecto en caso de que no se encuentre una coincidencia
    }
  }

  Color getColor(String colorName) {
    switch (colorName) {
      case 'RED':
        return Colors.red;
      case 'PURPLE':
        return Colors.purple;
      case 'INDIGO':
        return Colors.indigo;
      case 'AMBER':
        return Colors.amber;
      case 'BLACK':
        return Colors.black;
      case 'BLUE':
        return Colors.blue;
      case 'ORANGE':
        return Colors.orange;
      case 'GREEN':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  void _showEditDialog(
      String etiquetaId, String nombreActual, String colorActual) {
    Color currentColor = getColor(colorActual);
    _nombreEtiquetaController.text = nombreActual;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Center(
              child: SingleChildScrollView(
                child: AlertDialog(
                  title: const Text('Editar'),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        controller: _nombreEtiquetaController,
                        decoration: const InputDecoration(
                            hintText: 'Nombre de la etiqueta'),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(
                              255, 23, 100, 202), // background color
                        ),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                titlePadding: const EdgeInsets.all(0.0),
                                contentPadding: const EdgeInsets.all(0.0),
                                content: SingleChildScrollView(
                                  child: BlockPicker(
                                    pickerColor: currentColor,
                                    onColorChanged: (Color color) {
                                      setState(() {
                                        currentColor = color;
                                      });
                                    },
                                  ),
                                ),
                              );
                            },
                          );
                        },
                        child: const Text('Seleccionar color'),
                      ),
                      const SizedBox(height: 20),
                      CircleAvatar(
                        backgroundColor: currentColor,
                        radius: 20,
                      ),
                    ],
                  ),
                  actions: <Widget>[
                    TextButton(
                      child: const Text('Cancelar'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    TextButton(
                      child: const Text('Guardar'),
                      onPressed: () {
                        context.read<EtiquetaBloc>().add(
                              EtiquetaPatchEvent(
                                id: etiquetaId,
                                nombre: _nombreEtiquetaController.text,
                                color: convertColorToEnum(currentColor),
                              ),
                            );
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _showAddDialog() {
    Color currentColor = Colors.blue;
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Center(
              child: SingleChildScrollView(
                child: AlertDialog(
                  title: const Text('Añadir'),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        controller: _nombreEtiquetaController,
                        decoration: const InputDecoration(
                            hintText: 'Nombre de la etiqueta'),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(
                              255, 23, 100, 202), // background color
                        ),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                titlePadding: const EdgeInsets.all(0.0),
                                contentPadding: const EdgeInsets.all(0.0),
                                content: SingleChildScrollView(
                                  child: BlockPicker(
                                    pickerColor: currentColor,
                                    onColorChanged: (Color color) {
                                      setState(() {
                                        currentColor = color;
                                      });
                                    },
                                  ),
                                ),
                              );
                            },
                          );
                        },
                        child: const Text('Seleccionar color'),
                      ),
                      const SizedBox(height: 20),
                      CircleAvatar(
                        backgroundColor: currentColor,
                        radius: 20,
                      ),
                    ],
                  ),
                  actions: <Widget>[
                    TextButton(
                      child: const Text('Cancelar'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    TextButton(
                      child: const Text('Añadir'),
                      onPressed: () {
                        context.read<EtiquetaBloc>().add(
                              EtiquetaCreateEvent(
                                nombre: _nombreEtiquetaController.text,
                                color: convertColorToEnum(currentColor),
                                idUsuarioDueno: widget.usuario.id,
                              ),
                            );
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Etiquetas'),
        backgroundColor: const Color.fromARGB(255, 23, 100, 202),
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {
            ZoomDrawer.of(context)!.toggle();
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: BlocBuilder<EtiquetaBloc, EtiquetaState>(
          builder: (context, state) {
            if (state is EtiquetaInitialState) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is EtiquetaDeleteSuccessState) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                context
                    .read<EtiquetaBloc>()
                    .add(EtiquetaCatchEvent(idUsuarioDueno: widget.usuario.id));
              });
              return Container();
            } else if (state is EtiquetaPatchSuccessState) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                context
                    .read<EtiquetaBloc>()
                    .add(EtiquetaCatchEvent(idUsuarioDueno: widget.usuario.id));
              });
              return Container();
            } else if (state is EtiquetaCreateSuccessState) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                context
                    .read<EtiquetaBloc>()
                    .add(EtiquetaCatchEvent(idUsuarioDueno: widget.usuario.id));
              });
              return Container();
            } else if (state is EtiquetasSuccessState) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 80),
                child: ListView.builder(
                  itemCount: state.etiquetas.length,
                  itemBuilder: (context, index) {
                    final etiqueta = state.etiquetas[index];
                    return Card(
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: getColor(etiqueta.getColorEtiqueta()),
                          radius: 15,
                        ),
                        title: Text(
                          etiqueta.getNombreEtiqueta(),
                          style: const TextStyle(fontSize: 18),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () {
                                _showEditDialog(
                                  etiqueta.idEtiqueta,
                                  etiqueta.getNombreEtiqueta(),
                                  etiqueta.getColorEtiqueta(),
                                );
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: const Text('Confirmar eliminación'),
                                      content: const Text(
                                          '¿Estás seguro de que quieres eliminar esta etiqueta?'),
                                      actions: <Widget>[
                                        TextButton(
                                          child: const Text('Cancelar'),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                        TextButton(
                                          child: const Text('Eliminar'),
                                          onPressed: () {
                                            context.read<EtiquetaBloc>().add(
                                                  EtiquetaDeleteEvent(
                                                    etiquetaId:
                                                        etiqueta.idEtiqueta,
                                                  ),
                                                );
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              );
            } else {
              return const Center(child: Text('Ocurrió un error'));
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color.fromARGB(255, 23, 100, 202),
        onPressed: _showAddDialog,
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
