// ignore_for_file: must_be_immutable, library_private_types_in_public_api

import 'package:flutter/material.dart';

class TareaBlock extends StatefulWidget {

  final Map<String, dynamic>? tareas;
  String? id;

  List<TextEditingController> controllers = []; // Controladores de texto
  final TareaBlockController controller1 =TareaBlockController(); // Controladores de texto
  final TareaBlockController controllerEditar =TareaBlockController(); // Controladores de texto
  int cantTareas = 0;

  TareaBlock({Key? key, this.tareas, this.id}) : super(key: key);

  @override
  _TareaBlockState createState() => _TareaBlockState();
}

class _TareaBlockState extends State<TareaBlock> {
  List<Task> tasks = []; // Lista de tareas
  @override
  void dispose() {
    // Liberar los controladores de texto al salir del Widget
    for (var controller in widget.controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    if (widget.tareas != null) {
      List<dynamic> valueList = widget.tareas!['value'];
      tasks = valueList.map((taskJson) => parseTask(taskJson)).toList();
      
      widget.cantTareas = tasks.length;
      
    }
  widget.controllerEditar.listaTareas = tasks;

  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Tareas',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          ListView.builder(
            shrinkWrap: true,
            itemCount: tasks.length,
            itemBuilder: (context, index) {
              final task = tasks[index];
              final controller = TextEditingController(text: task.description);
              widget.controllers.add(controller); // Agregar el controlador a la lista

              return Row(
                children: [
                  Checkbox(
                    value: task.completed,
                    onChanged: (value) {
                      setState(() {
                        task.completed = value ?? false;
                      });
                    },
                  ),
                  Expanded(
                    child: TextFormField(
                      controller: controller, // Asignar el controlador
                      onChanged: (value) {
                        setState(() {
                          task.description = value;
                          widget.controllerEditar.listaTareas = tasks;
                        });
                      },
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.zero,
                        isDense: true,
                        border: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                      ),
                      style: TextStyle(
                        fontSize: 16,
                        decoration: task.completed
                            ? TextDecoration.lineThrough
                            : null,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        widget.controller1.eliminarTarea(tasks[index]);           //TArea agregada
                        tasks.removeAt(index);
                        widget.controllers.removeAt(index); // Eliminar el controlador correspondiente
                      });
                      widget.controllerEditar.listaTareas = tasks;
                      widget.cantTareas -= 1;
                    },
                    icon: const Icon(Icons.close),
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  TextEditingController descriptionController =
                      TextEditingController();

                  return AlertDialog(
                    title: const Text('Agregar tarea'),
                    content: TextField(
                      controller: descriptionController,
                      decoration: const InputDecoration(
                        labelText: 'Descripción',
                      ),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          final newTask = Task(
                            description: descriptionController.text,
                            completed: false,
                          );
                          setState(() {
                            tasks.add(newTask);
                            widget.controller1.agregarTarea(newTask);//TArea agregada
                            widget.controllers.add(TextEditingController(
                              text: newTask.description,
                            ));
                            Navigator.pop(context);
                            widget.cantTareas += 1;
                            widget.controllerEditar.listaTareas = tasks;
                          },
                          );
                        },
                        child: const Text('Agregar'),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('Cancelar'),
                      ),
                    ],
                  );
                },
              );
            },
            child: const Text('Agregar tarea'),
          ),
        ],
      ),
    );
  }
}

class Task {
  String? id;
  String description;
  bool completed;

  Task({
    required this.description,
    required this.completed,
    this.id,
  });
}


class TareaBlockController {
  List<Task> listaTareas = [];

  void agregarTarea(Task tarea) {
    listaTareas.add(tarea);
  }
  void eliminarTarea(Task tarea) {
    listaTareas.remove(tarea);
  }
}

Task parseTask(Map<String, dynamic> json) {
  return Task(
    description: json['titulo'],
    completed: json['check'],
  );
}