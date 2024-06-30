import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:chronocapsules/sign_in_screen.dart';
import 'package:chronocapsules/create_capsule_screen.dart';
import 'package:chronocapsules/time_capsule_details_screen.dart';
import 'package:chronocapsules/capsule.dart';
import 'package:intl/intl.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: AuthCheck(),
    );
  }
}

class AuthCheck extends StatelessWidget {
  const AuthCheck({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
              body: Center(child: CircularProgressIndicator()));
        } else if (snapshot.hasData) {
          return const TimeCapsuleHomeScreen();
        } else {
          return const SigninScreen();
        }
      },
    );
  }
}

class TimeCapsuleHomeScreen extends StatefulWidget {
  const TimeCapsuleHomeScreen({super.key});

  @override
  _TimeCapsuleHomeScreenState createState() => _TimeCapsuleHomeScreenState();
}

class _TimeCapsuleHomeScreenState extends State<TimeCapsuleHomeScreen> {
  List<Capsule> capsules = [];

  void _deleteCapsule(int index) {
    setState(() {
      capsules.removeAt(index);
    });
  }

  void _updateCapsule(Capsule updatedCapsule, int index) {
    setState(() {
      capsules[index] = updatedCapsule;
    });
  }

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
                      return Container(
                        margin: const EdgeInsets.symmetric(
                            vertical: 4.0, horizontal: 8.0),
                        decoration: BoxDecoration(
                          color: Colors.grey,
                          border: Border.all(
                            color: Colors.white10,
                            width: 2.0,
                          ),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(8.0),
                          title: Text(
                            capsules[index].title,
                            style: const TextStyle(color: Colors.yellow),
                          ),
                          subtitle: Text(
                            'Opens on: ${DateFormat('MMMM d, yyyy').format(capsules[index].date.toLocal())}',
                            style: const TextStyle(color: Colors.white),
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _deleteCapsule(index),
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => TimeCapsuleDetailsScreen(
                                  capsule: capsules[index],
                                  onUpdate: (updatedCapsule) =>
                                      _updateCapsule(updatedCapsule, index),
                                ),
                              ),
                            );
                          },
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
                child: const Text("Logout"),
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
              builder: (context) => const CreateCapsuleScreen(),
            ),
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
}
