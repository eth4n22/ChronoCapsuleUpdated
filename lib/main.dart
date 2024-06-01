import 'package:chronocapsules/sign_in_screen.dart';
import 'package:chronocapsules/sign_up_screen.dart';
import 'package:flutter/material.dart';

void main() => runApp(const MaterialApp(
      home: SigninScreen(),
    ));

class TimeCapsuleHomeScreen extends StatefulWidget {
  const TimeCapsuleHomeScreen({super.key});

  @override
  _TimeCapsuleHomeScreenState createState() => _TimeCapsuleHomeScreenState();
}

class _TimeCapsuleHomeScreenState extends State<TimeCapsuleHomeScreen> {
  DateTime? _selectedDate; // Variable to store the selected opening date

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'ChronoCapsule',
          style: TextStyle(
            fontSize: 30.0,
            fontWeight: FontWeight.bold,
            letterSpacing: 2.0,
            color: Colors.white,
            fontFamily: 'IndieFlower',
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.blueGrey,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.black, Colors.black87, Colors.black26],
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            const SizedBox(
              width: 200,
              height: 200,
              child: Image(
                image: AssetImage('images/chest.png'),
              ),
            ),
            Center(
              child: Container(
                child: const Text(
                  'Capsule of Memories',
                  style: TextStyle(
                    fontSize: 30.0,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2.0,
                    color: Colors.white,
                    fontFamily: 'IndieFlower',
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.red[600],
        onPressed: () {
          _selectOpeningDate(context);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  // Function to show date picker for selecting the opening date
  void _selectOpeningDate(BuildContext context) async {
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
      // After selecting the opening date, create the time capsule
      _createTimeCapsule();
    }
  }

  // Function to create a new time capsule with the selected opening date
  void _createTimeCapsule() {
    // Implement logic to create a new time capsule with the selected opening date
    print('Creating a new time capsule with opening date: $_selectedDate');
  }
}

class Home extends StatelessWidget {
  const Home({super.key});
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
