import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class EtiquetasScreen extends StatefulWidget {
  @override
  _EtiquetasScreenState createState() => _EtiquetasScreenState();
}

class _EtiquetasScreenState extends State<EtiquetasScreen> {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey();
  List<String> etiquetas = [
    'Etiqueta 1',
    'Etiqueta 2',
    'Etiqueta 3'
  ]; 

  List<Color> etiquetasColor = [
    Colors.red,
    Colors.green,
    Colors.blue
  ]; 

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
        padding: const EdgeInsets.only(top: 10.0),
        child: AnimatedList(
          key: _listKey,
          initialItemCount: etiquetas.length,
          itemBuilder: (context, index, animation) {
            return SlideTransition(
              position: animation.drive(Tween<Offset>(
                begin: const Offset(1, 0),
                end: Offset.zero,
              )),
              child: Card(
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: etiquetasColor[index],
                    radius: 15, // Increased radius
                  ),
                  title: Text(
                    etiquetas[index],
                    style: TextStyle(fontSize: 18), // Increased font size
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () {
                          _showEditDialog(index);
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          _listKey.currentState!.removeItem(
                            index,
                            (context, animation) => SlideTransition(
                              position: animation.drive(Tween<Offset>(
                                begin: const Offset(1, 0),
                                end: Offset.zero,
                              )),
                              child: SizedBox.shrink(), // This keeps an empty space after removing the item
                            ),
                          );
                          setState(() {
                            etiquetas.removeAt(index);
                            etiquetasColor.removeAt(index);
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddDialog,
        child: Icon(Icons.add),
        backgroundColor: const Color.fromARGB(255, 23, 100, 202),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  void _showEditDialog(int index) {
    final controller = TextEditingController(text: etiquetas[index]);
    Color currentColor = etiquetasColor[index];
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Center(
              child: SingleChildScrollView(
                child: AlertDialog(
                  title: Text('Editar'),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        controller: controller,
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary:
                              Color.fromARGB(255, 23, 100, 202), // background color
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
                        child: Text('Cambiar color'),
                      ),
                      SizedBox(height: 20),
                      CircleAvatar(
                        backgroundColor: currentColor,
                        radius: 20,
                      ),
                    ],
                  ),
                  actions: <Widget>[
                    TextButton(
                      child: Text('Cancelar'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    TextButton(
                      child: Text('Guardar'),
                      onPressed: () {
                        setState(() {
                          etiquetas[index] = controller.text;
                          etiquetasColor[index] = currentColor;
                        });
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
    ).then((_) => setState((){})); // This will refresh the screen after dialog is dismissed
  }

  void _showAddDialog() {
    final controller = TextEditingController();
    Color currentColor = Colors.blue;
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Center(
              child: SingleChildScrollView(
                child: AlertDialog(
                  title: Text('Añadir'),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        controller: controller,
                        decoration:
                            InputDecoration(hintText: 'Nombre de la etiqueta'),
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary:
                              Color.fromARGB(255, 23, 100, 202), // background color
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
                        child: Text('Seleccionar color'),
                      ),
                      SizedBox(height: 20),
                      CircleAvatar(
                        backgroundColor: currentColor,
                        radius: 20,
                      ),
                    ],
                  ),
                  actions: <Widget>[
                    TextButton(
                      child: Text('Cancelar'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    TextButton(
                      child: Text('Añadir'),
                      onPressed: () {
                        setState(() {
                          etiquetas.add(controller.text);
                          etiquetasColor.add(currentColor);
                          _listKey.currentState!.insertItem(etiquetas.length - 1);
                        });
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
    ).then((_) => setState((){})); // This will refresh the screen after dialog is dismissed
  }
}
