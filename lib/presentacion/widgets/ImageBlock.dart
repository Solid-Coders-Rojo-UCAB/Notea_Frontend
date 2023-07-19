// ignore_for_file: library_private_types_in_public_api, file_names

import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter_image_compress/flutter_image_compress.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:notea_frontend/infraestructura/Repositorio/repositorioNotaImpl.dart';

import '../pantallas/sketchScreen.dart';

class ImageBlock extends StatefulWidget {

  String? nombre;
  String? base64;
  String? id;

  final ImageBlockController controller = ImageBlockController();
  final ImageBlockController controller1 = ImageBlockController();
  
  ImageBlock({Key? key, this.base64, this.nombre, this.id}) : super(key: key);
  Image? selectedImage;
  Image? selectedImage1;

  @override
  _ImageBlockState createState() => _ImageBlockState();

}

class _ImageBlockState extends State<ImageBlock> {
  final ImagePicker _imagePicker = ImagePicker();

  Future<void> _pickImageFromGallery() async {
    final pickedImage = await _imagePicker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        widget.selectedImage = Image.file(
          File(pickedImage.path),
          fit: BoxFit.cover,
          height: 380,
        );

        widget.selectedImage1 = Image.network(
          pickedImage.path,
          fit: BoxFit.cover,
        );
      });
      final base64Image = await convertir(File(pickedImage.path));
      widget.controller.setImage(widget.selectedImage, pickedImage.name, base64Image, null);
      widget.controller1.setImage(widget.selectedImage1, pickedImage.name, base64Image, null);
    }
  }

  Future<void> _makeSketch() async {

    final pickedImage = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => const sketchScreen(title: 'Dibuja 😎',)));

    print('pickedImage -> '+ pickedImage);

    if (pickedImage != null) {
      setState(() {
          widget.selectedImage = Image.file(
          File(pickedImage),
          fit: BoxFit.cover,
          height: 380,
        );

        widget.selectedImage1 = Image.network(
          pickedImage,
          fit: BoxFit.cover,
        );
      });
    
      String name = 'sketch' + DateTime.now().toString();

      final base64Image = await convertir(File(pickedImage));
      widget.controller.setImage(widget.selectedImage, name, base64Image, null);
      widget.controller1.setImage(widget.selectedImage1, name, base64Image, null);
    }
  }

  void _removeImage() {
    setState(() {
      widget.selectedImage = null;
    });
  }

  @override
  void initState() {
    super.initState();
    if(widget.nombre != null && widget.base64 != null) {
      // print('nombre -> '+ widget.nombre!);
      // print('base64 -> '+ widget.base64!);

      // widget.selectedImage = imageFromBase64String(widget.hola);
      widget.selectedImage = imageFromBase64String(widget.base64!);
      widget.controller.setImage(widget.selectedImage, widget.nombre, widget.base64!, null);
    }
  }

  Image imageFromBase64String(String base64String) {
    return Image.memory(
      base64Decode(base64String),
      height: 380,
    );
  }


  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (widget.selectedImage != null)
          Container(
            margin: const EdgeInsets.only(bottom: 20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: widget.selectedImage,
                ),
                Positioned(
                  top: 5,
                  right: 5,
                  child: IconButton(
                    icon: const Icon(
                      Icons.delete,
                      color: Colors.white,
                    ),
                    onPressed: _removeImage,
                  ),
                ),
              ],
            ),
          )
        else
          Container(
            margin: const EdgeInsets.all(20),
            child: Column(
              children: [
                ElevatedButton(
                  onPressed: _pickImageFromGallery,
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.blue,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 3,
                  ),
                  child: const Text(
                    'Seleccionar imagen',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: _makeSketch,
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.blue,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 3,
                  ),
                  child: const Text(
                    'Hacer Sketch',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}


class ImageBlockController {
  Image? _selectedImage;
  String? _imageName;
  late String? _selectedImagePath;
  late String _base64;

  void setImage(Image? image, String? imageName, String base64, String? imagePath) {
    _selectedImage = image;
    _imageName = imageName;
    _selectedImagePath = imagePath;
    _base64 = base64;
  }

  Image? getSelectedImage() {
    return _selectedImage;
  }

  String? getImageName() {
    return _imageName;
  }

  String? getImagePath() {
    return _selectedImagePath;
  }

  String getBase64() {
    return _base64;
  }
}



Future<String> convertir(File imagen) async {

      var result = await FlutterImageCompress.compressAndGetFile(
        imagen.absolute.path,
        "${imagen.absolute.path}compressed.jpg",
        quality: 50,
      );

    var res = File("${imagen.absolute.path}compressed.jpg"); //hay que volver a pasasr de xfile a file
    // print("despues de Comprimir");
    // print(res.lengthSync());

    Uint8List imageBytes = await res.readAsBytes();
    String base64Image = base64.encode(imageBytes);

    // print("base64");
    // print(base64Image.length);

    return base64Image;
  }
