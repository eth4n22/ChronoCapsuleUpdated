import 'package:flutter/material.dart';
class Capsule {
  final String title;
  final DateTime date;
  final List<String> uploadedPhotos; // List of photo paths

  Capsule({
    required this.title,
    required this.date,
    required this.uploadedPhotos,
  });
}
