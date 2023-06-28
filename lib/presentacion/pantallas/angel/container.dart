import 'package:flutter/material.dart';



class ContainerPro extends StatefulWidget {
  final Function(String) onDataReceived;

   const ContainerPro({super.key, required this.onDataReceived});


  @override
  ContainerProState createState() => ContainerProState();
}

class ContainerProState extends State<ContainerPro> {
  TextEditingController textController = TextEditingController();

  void sendDataToWrapperWidget() {
    final data = textController.text;
    if (widget.onDataReceived != null) {
      widget.onDataReceived(data);
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Container Editor Nota'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              onChanged: (newValue) => sendDataToWrapperWidget(),
              controller: textController,
              decoration: InputDecoration(
                labelText: 'Ingrese un dato',
              ),
            ),
            ElevatedButton(
              onPressed: sendDataToWrapperWidget,
              child: Text('Enviar dato'),
            ),
          ],
        ),
      ),
    );
  }
}
