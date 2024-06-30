import 'dart:io';
import 'package:flutter/material.dart';

class FullScreenImageScreen extends StatelessWidget {
  final String imagePath;

  const FullScreenImageScreen({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Image Viewer',
          style: const TextStyle(
            fontSize: 24.0,
            color: Colors.white,
            fontFamily: 'IndieFlower',
          ),
        ),
        backgroundColor: Colors.blueGrey,
      ),
      body: Center(
        child: Image.file(File(imagePath)),
      ),
    );
  }
}
