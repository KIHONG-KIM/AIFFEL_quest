import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:typed_data';

void main() => runApp(const MaterialApp(home: ImageProcessor()));

class ImageProcessor extends StatefulWidget {
  const ImageProcessor({super.key});

  @override
  ImageProcessorState createState() => ImageProcessorState();
}

class ImageProcessorState extends State<ImageProcessor> {
  File? _image;
  Uint8List? _processedImageBytes;

  final picker = ImagePicker();

  // 사진 불러오기
  Future<void> _getImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
        _processedImageBytes = null;
      });
    }
  }

  // API 호출
  Future<void> _processImage() async {
    if (_image == null) return;

    try {
      List<int> imageBytes = await _image!.readAsBytes();
      String base64Image = base64Encode(imageBytes);

      var response = await http.post(
        Uri.parse('http://192.168.45.45:8000/segment/'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'image': base64Image}),
      );

      if (response.statusCode == 200) {
        setState(() => _processedImageBytes = response.bodyBytes);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Image processed successfully')),
        );
      } else {
        throw Exception('Failed to process image');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error processing image: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Image Processor')),
      body: SizedBox(
        width: 500,
        height: 1000,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (_image != null) Image.file(_image!, width: 500, height: 500),
              const SizedBox(height: 20),
              if (_processedImageBytes != null)
                Image.memory(_processedImageBytes!, width: 500, height: 500),
            ],
          ),
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: _getImage,
            tooltip: 'Pick Image',
            child: const Icon(Icons.add_a_photo),
          ),
          const SizedBox(height: 16),
          FloatingActionButton(
            onPressed: _processImage,
            tooltip: 'Process Image',
            child: const Icon(Icons.send),
          ),
        ],
      ),
    );
  }
}
