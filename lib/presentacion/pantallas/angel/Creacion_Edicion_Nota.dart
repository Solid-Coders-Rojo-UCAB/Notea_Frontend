// ignore_for_file: must_be_immutable, library_private_types_in_public_api, file_names

import 'package:flutter/material.dart';
import 'package:notea_frontend/presentacion/pantallas/angel/Container_Editor_Nota.dart';
import 'package:notea_frontend/presentacion/pantallas/angel/EtiquetaList.dart';
import 'package:notea_frontend/presentacion/pantallas/angel/GrupoList.dart';
// import 'package:notea_frontend/presentacion/pantallas/angel/EtiquetaList.dart';
// import 'package:notea_frontend/presentacion/pantallas/angel/GrupoList.dart';
class AccionesConNota extends StatefulWidget {
  final String accion;

  const AccionesConNota({Key? key, required this.accion}) : super(key: key);

  @override
  _AccionesConNotaState createState() => _AccionesConNotaState();
}

class _AccionesConNotaState extends State<AccionesConNota> {
  late TextEditingController _tituloController;

  @override
  void initState() {
    super.initState();
    _tituloController = TextEditingController();
  }

  @override
  void dispose() {
    _tituloController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Añadir Nota'),
        backgroundColor: const Color(0xFF21579C),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 24, bottom: 40),
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: TextFormField(
                    controller: _tituloController,
                    decoration: InputDecoration(
                      hintText: 'Ingrese el título de la nota',
                      contentPadding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: const BorderSide(
                          color: Colors.black12,
                          width: 1.0,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: const BorderSide(
                          color: Colors.blue,
                          width: 2.0,
                        ),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 16.0),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.9,
                    height: 500,
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.black12,
                          width: 1.0,
                        ),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: const ContainerEditorNota(),
                    ),
                  ),
                ),
                const SizedBox(height: 24.0),
                Column(
                  children: const [
                    EtiquetaList(),
                    GrupoList(),
                  ],
                ),
                const SizedBox(height: 24.0),
                FloatingActionButton(
                  onPressed: () {
                    String titulo = _tituloController.text;
                    // Acción al presionar el botón de guardar, puedes usar la variable "titulo" para obtener el título ingresado
                  },
                  backgroundColor: Colors.blue,
                  child: const Icon(
                    Icons.sd_storage_outlined,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
