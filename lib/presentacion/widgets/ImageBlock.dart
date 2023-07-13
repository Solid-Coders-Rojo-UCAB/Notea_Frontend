// ignore_for_file: library_private_types_in_public_api, file_names

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImageBlock extends StatefulWidget {

  final ImageBlockController controller = ImageBlockController();
  
  ImageBlock({Key? key}) : super(key: key);
  Image? selectedImage;

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
          File(pickedImage.path),  // Agregar import 'dart:io';
          fit: BoxFit.cover,
          height: 380,
        );
      });
      widget.controller.setImage(widget.selectedImage, pickedImage.name);
    }
  }

  void _removeImage() {
    setState(() {
      widget.selectedImage = null;
    });
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
            child: ElevatedButton(
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
          ),
      ],
    );
  }
}


class ImageBlockController {
  Image? _selectedImage;
  String? _imageName;

  void setImage(Image? image, String? imageName) {
    _selectedImage = image;
    _imageName = imageName;
  }

  Image? getSelectedImage() {
    return _selectedImage;
  }

  String? getImageName() {
    return _imageName;
  }
}