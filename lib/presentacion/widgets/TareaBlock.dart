import 'package:flutter/material.dart';

class TareaBlock extends StatefulWidget {
  const TareaBlock({Key? key}) : super(key: key);

  @override
  _TareaBlockState createState() => _TareaBlockState();
}

class _TareaBlockState extends State<TareaBlock> {
  List<Task> tasks = []; // Lista de tareas
  List<TextEditingController> controllers = []; // Controladores de texto

  @override
  void dispose() {
    // Liberar los controladores de texto al salir del Widget
    for (var controller in controllers) {
      controller.dispose();
    }
    super.dispose();
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
              controllers.add(controller); // Agregar el controlador a la lista

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
                        tasks.removeAt(index);
                        controllers.removeAt(index); // Eliminar el controlador correspondiente
                      });
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
                          setState(() {
                            final newTask = Task(
                              description: descriptionController.text,
                              completed: false,
                            );
                            tasks.add(newTask);
                            controllers.add(TextEditingController(
                              text: newTask.description,
                            ));
                            Navigator.pop(context);
                          });
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
  String description;
  bool completed;

  Task({
    required this.description,
    this.completed = false,
  });
}
