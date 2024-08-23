import 'package:flutter/material.dart';

class ImageToTextScreen extends StatefulWidget {
  const ImageToTextScreen({super.key});

  @override
  State<ImageToTextScreen> createState() => _ImageToTextScreen();
}

class _ImageToTextScreen extends State<ImageToTextScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Image To Text'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text('Image To Text Screen'),
      ),
    );
  }
}
