import 'package:flutter/material.dart';


class DialogsInfo {
  confirm(BuildContext context, String title, String description, String id,
      Function onSelected) {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text(
              'Desea eliminar la nota:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
            ),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text(title),
                ],
              ),
            ),
            actions: <Widget>[
              ElevatedButton(
                onPressed: () => _confirmResult(true, context, id, onSelected),
                child: const Text('Eliminar'),
              ),
              ElevatedButton(
                onPressed: () => _confirmResult(false, context, id, onSelected),
                child: const Text('Cancelar'),
              ),
            ],
          );
        });
  }

  _confirmResult(bool isYes, BuildContext context, String id,
      Function onSelected) async {
    // if (isYes) {
    //   Navigator.pop(context);
    //   Future<bool> isRemove = Future<True>;
    //        // se elimina directamente de la base de datos
    //   if (await isRemove) {
    //     onSelected(); // callback para actualizar la lista de notas
    //   }
    // } else {
    //   Navigator.pop(context);
    // }
  }
}
