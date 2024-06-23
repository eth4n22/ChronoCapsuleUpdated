import 'package:flutter/material.dart';
import 'package:chronocapsules/capsule.dart'; // Import your Capsule class
import 'package:image_picker/image_picker.dart'; // Import image_picker for photo selection
import 'dart:io';

class CreateCapsuleScreen extends StatefulWidget {
  const CreateCapsuleScreen({Key? key}) : super(key: key);

  @override
  _CreateCapsuleScreenState createState() => _CreateCapsuleScreenState();
}

class _CreateCapsuleScreenState extends State<CreateCapsuleScreen> {
  final TextEditingController _titleController = TextEditingController();
  DateTime? _selectedDate;
  List<File> _selectedPhotos = []; // List to store selected photos

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Capsule'),
        backgroundColor: Colors.blueGrey,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Capsule Title'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _selectDate(context),
              child: const Text('Select Date'),
            ),
            const SizedBox(height: 20),
            Text(
              _selectedDate != null
                  ? 'Selected Date: ${_selectedDate!.toLocal()}'
                  : 'No Date Selected',
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _selectPhotos(context),
              child: const Text('Select Photos'),
            ),
            const SizedBox(height: 20),
            // Display selected photos here (if any)
            Expanded(
              child: ListView.builder(
                itemCount: _selectedPhotos.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: Image.file(_selectedPhotos[index]),
                    trailing: IconButton(
                      icon: Icon(Icons.remove_circle),
                      onPressed: () {
                        setState(() {
                          _selectedPhotos.removeAt(index);
                        });
                      },
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _createCapsule(context);
              },
              child: const Text('Create Capsule'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 10),
    );
    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  Future<void> _selectPhotos(BuildContext context) async {
    final List<XFile>? selectedImages = await ImagePicker().pickMultiImage(
      imageQuality: 70, // Adjust as needed
    );

    if (selectedImages != null && selectedImages.isNotEmpty) {
      setState(() {
        _selectedPhotos.clear(); // Clear existing selections
        _selectedPhotos.addAll(selectedImages.map((image) => File(image.path)));
      });
    }
  }

  void _createCapsule(BuildContext context) {
    if (_titleController.text.isNotEmpty && _selectedDate != null) {
      final newCapsule = Capsule(
        title: _titleController.text,
        date: _selectedDate!,
        uploadedPhotos: _selectedPhotos.map((photo) => photo.path).toList(),
      );
      Navigator.pop(context, newCapsule);
    } else {
      // Show an error message if the title or date is not selected
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a title and select a date'),
        ),
      );
    }
  }
}
