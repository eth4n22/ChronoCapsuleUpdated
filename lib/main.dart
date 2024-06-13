import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:chronocapsules/sign_in_screen.dart';
import 'package:chronocapsules/create_capsule_screen.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    const MaterialApp(
      home: SigninScreen(),
    ),
  );
}

class Capsule {
  final String title;
  final DateTime date;

  Capsule({required this.title, required this.date});
}

class TimeCapsuleHomeScreen extends StatefulWidget {
  const TimeCapsuleHomeScreen({super.key});

  @override
  _TimeCapsuleHomeScreenState createState() => _TimeCapsuleHomeScreenState();
}

class _TimeCapsuleHomeScreenState extends State<TimeCapsuleHomeScreen> {
  DateTime? _selectedDate;
  List<Capsule> capsules = [];

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
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.black, Colors.black87, Colors.black26],
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
              ),
            ),
            child: Column(
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
                      'Active ChronoCapsules',
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
                const SizedBox(height: 20),
                Expanded(
                  child: ListView.builder(
                    itemCount: capsules.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(
                          capsules[index].title,
                          style: const TextStyle(color: Colors.white),
                        ),
                        subtitle: Text(
                          'Opens on: ${capsules[index].date.toLocal()}',
                          style: const TextStyle(color: Colors.white70),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                child: const Text("Logout"),
                onPressed: () {
                  FirebaseAuth.instance.signOut().then((value) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SigninScreen(),
                      ),
                    );
                  });
                },
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.red[600],
        onPressed: () async {
          final newCapsule = await Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const CreateCapsuleScreen()),
          );
          if (newCapsule != null) {
            setState(() {
              capsules.add(newCapsule);
            });
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void _createTimeCapsule() {
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
