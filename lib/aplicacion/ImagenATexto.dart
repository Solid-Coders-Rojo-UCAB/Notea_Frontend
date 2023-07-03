import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:image_picker/image_picker.dart';

class imagenATexto {
  Future<String> EscanearTexto(XFile? foto) async {
    String textocompleto = "";
    final selectedImage = foto;
    if (selectedImage != null) {
      final inputImage = InputImage.fromFilePath(selectedImage.path);
      final textDetector = GoogleMlKit.vision.textRecognizer();
      RecognizedText recognizedText =
          await textDetector.processImage(inputImage);
      await textDetector.close();
      for (TextBlock block in recognizedText.blocks) {
        for (TextLine line in block.lines) {
          textocompleto = textocompleto + line.text + "\n";
        }
      }
      return textocompleto;
    } else
      return "";
  }
}
