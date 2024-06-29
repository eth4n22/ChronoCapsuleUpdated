import 'dart:io'; // Import for File class
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Import for date formatting
import 'package:chronocapsules/capsule.dart'; // Import Capsule class
import 'package:chronocapsules/full_screen_image_screen.dart'; // Import the full screen image screen

class TimeCapsuleDetailsScreen extends StatelessWidget {
  final Capsule capsule;

  const TimeCapsuleDetailsScreen({Key? key, required this.capsule}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();

    // Function to format DateTime to display only the date
    String formattedDate(DateTime dateTime) {
      return DateFormat('MMMM d, yyyy').format(dateTime);
    }

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
        color: const Color(0xFFB3E5FC), // Light pastel blue color
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
                    itemCount: capsule.uploadedPhotos.length,
                    itemBuilder: (context, index) {
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
                    },
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
