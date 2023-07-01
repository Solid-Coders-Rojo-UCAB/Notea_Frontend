import 'dart:convert';
import 'package:flutter/material.dart';

class Nota {
  String contenido;
  List<Estilo> estilos;

  Nota({required this.contenido, required this.estilos});

  factory Nota.fromJson(Map<String, dynamic> json) {
    return Nota(
      contenido: json['contenido'],
      estilos: List<Estilo>.from(json['estilos'].map((x) => Estilo.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() => {
        'contenido': contenido,
        'estilos': List<dynamic>.from(estilos.map((x) => x.toJson())),
      };
}

class Estilo {
  int startIndex;
  int endIndex;
  String estilo;

  Estilo({required this.startIndex, required this.endIndex, required this.estilo});

  factory Estilo.fromJson(Map<String, dynamic> json) {
    return Estilo(
      startIndex: json['startIndex'],
      endIndex: json['endIndex'],
      estilo: json['estilo'],
    );
  }

  Map<String, dynamic> toJson() => {
    'startIndex': startIndex,
    'endIndex': endIndex,
    'estilo': estilo,
  };
}

class NotaEditor extends StatefulWidget {
  @override
  _NotaEditorState createState() => _NotaEditorState();
}

class _NotaEditorState extends State<NotaEditor> {
  Nota miNota = Nota(contenido: '', estilos: []);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Editor de Notas'),
      ),
      body: Column(
        children: [
          TextFormField(
            onChanged: (value) {
              setState(() {
                miNota.contenido = value;
              });
            },
          ),
          ElevatedButton(
            onPressed: () {
              miNota.estilos.add(Estilo(startIndex: 5, endIndex: 10, estilo: "color: red;"));
              miNota.estilos.add(Estilo(startIndex: 18, endIndex: 24, estilo: "text-decoration: underline;"));

              String notaJson = jsonEncode(miNota);

              Nota notaCargada = Nota.fromJson(jsonDecode(notaJson));
              String contenidoConEstilos = notaCargada.contenido;
              for (Estilo estilo in notaCargada.estilos) {
                contenidoConEstilos = contenidoConEstilos.replaceRange(
                    estilo.startIndex, estilo.endIndex, '<span style="${estilo.estilo}">');
                contenidoConEstilos = contenidoConEstilos.replaceRange(
                    estilo.endIndex, estilo.endIndex + 7, '</span>');
              }

              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Nota con Estilos'),
                    content: Text(contenidoConEstilos),
                    actions: [
                      TextButton(
                        child: Text('Cerrar'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  );
                },
              );
            },
            child: Text('Guardar Nota'),
          ),
        ],
      ),
    );
  }
}
