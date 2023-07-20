import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:notea_frontend/dominio/agregados/usuario.dart';
import 'package:notea_frontend/infraestructura/bloc/Grupo/grupo_bloc.dart';


class GruposScreen extends StatefulWidget {
  final Usuario usuario;

  const GruposScreen({Key? key, required this.usuario}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _GruposScreenState createState() => _GruposScreenState();
}

class _GruposScreenState extends State<GruposScreen> {
  final TextEditingController _nombreGrupoController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    context
        .read<GrupoBloc>()
        .add(GrupoCatchEvent(idUsuarioDueno: widget.usuario.id));
  }

  void _showEditDialog(String grupoId, String nombreActual) {
    _nombreGrupoController.text = nombreActual;

    showDialog(
      context: context,
      builder: (context) {
        return Center(
          child: SingleChildScrollView(
            child: AlertDialog(
              title: const Text('Editar'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: _nombreGrupoController,
                    decoration:
                        const InputDecoration(hintText: 'Nombre del grupo'),
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
                    context.read<GrupoBloc>().add(
                          GrupoPatchEvent(
                            id: grupoId,
                            nombre: _nombreGrupoController.text,
                            idUsuario:widget.usuario.id,
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
  }

  void _showAddDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return Center(
          child: SingleChildScrollView(
            child: AlertDialog(
              title: const Text('Añadir'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: _nombreGrupoController,
                    decoration:
                        const InputDecoration(hintText: 'Nombre del grupo'),
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
                    context.read<GrupoBloc>().add(
                          GrupoCreateEvent(
                            nombre: _nombreGrupoController.text,
                            idUsuario: widget.usuario.id,
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Grupos'),
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
        child: BlocBuilder<GrupoBloc, GrupoState>(
          builder: (context, state) {
            if (state is GrupoInitialState) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is GrupoDeleteSuccessState) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                context
                    .read<GrupoBloc>()
                    .add(GrupoCatchEvent(idUsuarioDueno: widget.usuario.id));
              });
              return Container();
            } else if (state is GrupoPatchSuccessState) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                context
                    .read<GrupoBloc>()
                    .add(GrupoCatchEvent(idUsuarioDueno: widget.usuario.id));
              });
              return Container();
            } else if (state is GrupoCreateSuccessState) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                context
                    .read<GrupoBloc>()
                    .add(GrupoCatchEvent(idUsuarioDueno: widget.usuario.id));
              });
              return Container();
            } else if (state is GruposSuccessState) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 80),
                child: ListView.builder(
                  itemCount: state.grupos.length,
                  itemBuilder: (context, index) {
                    final grupo = state.grupos[index];
                    return Card(
                      child: ListTile(
                        title: Text(
                          grupo.getNombre(),
                          style: const TextStyle(fontSize: 18),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () {
                                _showEditDialog(
                                  grupo.idGrupo,
                                  grupo.getNombre(),
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
                                          '¿Estás seguro de que quieres eliminar este grupo?'),
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
                                            context.read<GrupoBloc>().add(
                                                  GrupoDeleteEvent(
                                                    grupoId: grupo.idGrupo,
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
