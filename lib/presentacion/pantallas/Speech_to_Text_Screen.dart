import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';


class SpeechToTextScreen extends StatefulWidget {
  
  final String textoNota;
  const SpeechToTextScreen({super.key, required this.textoNota});

  @override
  State<SpeechToTextScreen> createState() => _SpeechToTextScreenState();
}

class _SpeechToTextScreenState extends State<SpeechToTextScreen> {

  SpeechToText _speechToText = SpeechToText();
  bool _speechEnabled = false;
  String _lastWords = '';
  String nuevoTexto = '';
  String finalTexto = '';

  /// dicen que se debe hacer una vez por app
  void _initSpeech() async {
    _speechEnabled = await _speechToText.initialize();
    setState(() {});
  }

  void _startListening() async {
    await _speechToText.listen(onResult: _onSpeechResult);
    setState(() {
       nuevoTexto = "$nuevoTexto $_lastWords";
       _lastWords = '';
    });
  }

  void _stopListening() async { //en android se detiene automaticamente
    await _speechToText.stop();
    setState(() {
    });
  }

  void _onSpeechResult(SpeechRecognitionResult result) {
    setState(() {
      _lastWords = result.recognizedWords;
    });
  }

  String concatResult() {
    finalTexto = "$nuevoTexto $_lastWords";
    return "$nuevoTexto $_lastWords";
  }

  @override
  void initState() {
    super.initState();
    nuevoTexto = widget.textoNota;
    _initSpeech();
  }

  @override
  Widget build(BuildContext context) {
    //si no es premiun se muestra un mensaje 
    if (!_speechEnabled){
      return const Scaffold(
        body: Center(
          child: Text(
            'El dispositivo no soporta esta funcionalidad o se ha denegado el permiso',
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
              color: Color(0XFF21579C),
            ),
          ),
        ),
      );
    }
     return Scaffold(
      body: Center(
        child: Column(
         mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Column(
              children: [
              const SizedBox(height: 20.0), 
              AnimatedTextKit(
                animatedTexts: [TypewriterAnimatedText(
                  "Voz a Texto",
                  textStyle: const TextStyle(
                    fontSize: 39.0,
                    fontWeight: FontWeight.bold,
                    color: Color(0XFF21579C),
                  ),
                  speed: const Duration(milliseconds: 400),
                )],
              onTap: () {
              //
              }),
              const SizedBox(height: 20.0),
              Container(
                foregroundDecoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  border: Border.all(
                    color: const Color(0XFF21579C),
                    width: 2.0,
                  ),
                ),
              decoration: BoxDecoration(
                color: Colors.blue[100],
                borderRadius: BorderRadius.circular(10.0),
              ),
              width: MediaQuery.of(context).size.width * 0.8,
              padding: const EdgeInsets.all(16.0),
              child: Text(
                  concatResult(),
                style: const TextStyle(
                  fontSize: 19.5,
                  fontWeight: FontWeight.bold,
                  color: Color(0XFFD6A319),
                ),
              ),
              ),
              const SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () {
                  print('Nuevo texto ->>> ' + finalTexto);
                  Navigator.pop(context, finalTexto);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0XFF21579C),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(32.0),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14)
              ),
                child: const Text('Guardar'),
              ),
              const SizedBox(height: 3.0),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context, widget.textoNota);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0XFF21579C),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(32.0),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14)
              ),
                child: const Text('Regresar'),
              ),
          ])
        ],
      )
    ),
    floatingActionButton: FloatingActionButton(
              backgroundColor: const Color(0XFFD6A319),
              onPressed: _speechToText.isNotListening ? _startListening : _stopListening,
              tooltip: _speechToText.isNotListening ? 'Escuchar' : 'Dejar de Escuchar',
              child: Icon(_speechToText.isNotListening ? Icons.mic_off : Icons.mic)
              )
    );
  }
}
