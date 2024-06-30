import 'dart:io'; // Import for File class
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Import for date formatting
import 'package:chronocapsules/capsule.dart'; // Import Capsule class
import 'package:chronocapsules/full_screen_image_screen.dart'; // Import the full screen image screen
import 'package:image_picker/image_picker.dart'; // Import for image picker

class TimeCapsuleDetailsScreen extends StatefulWidget {
  final Capsule capsule;
  final Function(Capsule) onUpdate;

  const TimeCapsuleDetailsScreen({
    super.key,
    required this.capsule,
    required this.onUpdate,
  });

  @override
  _TimeCapsuleDetailsScreenState createState() =>
      _TimeCapsuleDetailsScreenState();
}

class _TimeCapsuleDetailsScreenState extends State<TimeCapsuleDetailsScreen> {
  late Capsule capsule;

  @override
  void initState() {
    super.initState();
    capsule = widget.capsule;
  }

  // Function to format DateTime to display only the date
  String formattedDate(DateTime dateTime) {
    return DateFormat('MMMM d, yyyy').format(dateTime);
  }

  Future<void> _addPhotos() async {
    final List<XFile> selectedImages = await ImagePicker().pickMultiImage(
      imageQuality: 70, // Adjust as needed
    );

    if (selectedImages.isNotEmpty) {
      setState(() {
        capsule.uploadedPhotos
            .addAll(selectedImages.map((image) => image.path));
        widget.onUpdate(capsule); // Update the capsule
      });
    }
  }

  Future<void> _addLetter() async {
    final TextEditingController letterController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Add Letter"),
        content: TextField(
          controller: letterController,
          maxLines: 10,
          decoration: const InputDecoration(hintText: "Enter your letter here"),
        ),
        actions: [
          TextButton(
            onPressed: () {
              if (letterController.text.isNotEmpty) {
                setState(() {
                  capsule.letters.add(letterController.text);
                  widget.onUpdate(capsule); // Update the capsule
                });
              }
              Navigator.pop(context);
            },
            child: const Text("Add"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          capsule.title,
          style: const TextStyle(
            fontSize: 24.0,
            color: Colors.white,
            fontFamily: 'IndieFlower',
          ),
        ),
        backgroundColor: Colors.blueGrey,
      ),
      body: Container(
        color: Colors.grey, // Light pastel blue color
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'VIRTUAL CAPSULE:',
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.0,
                  color: Colors.black,
                  fontFamily: 'IndieFlower',
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Opening Date: ${formattedDate(capsule.date)}', // Use formattedDate function
                style: const TextStyle(fontSize: 18, color: Colors.black54),
              ),
              const SizedBox(height: 20),
              if (capsule.date.isAfter(now))
                const Text(
                  'LOCKED',
                  style: TextStyle(fontSize: 18, color: Colors.red),
                )
              else
                Expanded(
                  child: ListView.builder(
                    itemCount:
                    capsule.uploadedPhotos.length + capsule.letters.length,
                    itemBuilder: (context, index) {
                      if (index < capsule.uploadedPhotos.length) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => FullScreenImageScreen(
                                  imagePath: capsule.uploadedPhotos[index],
                                ),
                              ),
                            );
                          },
                          child: ListTile(
                            leading: Image.file(
                              File(capsule.uploadedPhotos[index]),
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                            ),
                            title: Text(
                              'Photo ${index + 1}',
                              style: const TextStyle(color: Colors.black),
                            ),
                          ),
                        );
                      } else {
                        int letterIndex = index - capsule.uploadedPhotos.length;
                        return ListTile(
                          title: Text(
                            'Letter ${letterIndex + 1}',
                            style: const TextStyle(color: Colors.black),
                          ),
                          subtitle: Text(capsule.letters[letterIndex]),
                        );
                      }
                    },
                  ),
                ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.red[600],
        onPressed: () => _showAddOptions(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.photo),
            title: const Text("Add Photos"),
            onTap: () {
              Navigator.pop(context);
              _addPhotos();
            },
          ),
          ListTile(
            leading: const Icon(Icons.note),
            title: const Text("Add Letter"),
            onTap: () {
              Navigator.pop(context);
              _addLetter();
            },
          ),
        ],
      ),
    );
  }
}
