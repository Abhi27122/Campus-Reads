import 'package:campusreads/Front/frontpage.dart';
import 'package:campusreads/data/google_sign_in.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          brightness: Brightness.light,
           primaryColor: Colors.yellow,
           primarySwatch: Colors.brown,
           backgroundColor: Color.fromARGB(255, 227, 218, 167),
    ),
      home: AuthService().handleAuthState(),
    );
  }
}

class Login extends StatelessWidget {
  Login();
  TextEditingController email = new TextEditingController();
  TextEditingController password = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 227, 218, 167),
      body: Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        padding: const EdgeInsets.fromLTRB(20, 20, 20, 70),
                        child: Icon(
                          Icons.person,
                          color: Colors.black54,
                          size: 100,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                        child: TextField(
                          controller: email,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.yellow, width: 0.0),
                              borderRadius: BorderRadius.circular(90.0),
                            ),
                            labelText: 'Email',
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                        child: TextField(
                          controller: password,
                          obscureText: true,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(90.0),
                            ),
                            labelText: 'Password',
                          ),
                        ),
                      ),
                      Container(
                          height: 80,
                          padding: const EdgeInsets.all(20),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(90.0)
                              ),
                              minimumSize: const Size.fromHeight(50),
                            ),
                            child: const Text('Log In'),
                            onPressed: () async{
                              AuthService().signInWithGoogle();
                              final FirebaseAuth auth = FirebaseAuth.instance;
                              final User? user = auth.currentUser;
                            },
                          )),
                      TextButton(
                        onPressed: () {
                          AuthService().signOut();
                        },
                        child: Text(
                          'Forgot Password?',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(builder: ((context) => RegistrationPage())));
                        },
                        child: Text(
                          'Register to Campus Reads',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ),
                ],
              ),
            ),
    );
  }
}

class RegistrationPage extends StatelessWidget {
  RegistrationPage({Key? key}) : super(key: key);
  TextEditingController email = new TextEditingController();
  TextEditingController password = new TextEditingController();
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 227, 218, 167),
      body: Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        padding: const EdgeInsets.fromLTRB(20, 20, 20, 70),
                        child: Icon(
                          Icons.person,
                          color: Colors.black54,
                          size: 100,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                        child: TextField(
                          controller: email,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.yellow, width: 0.0),
                              borderRadius: BorderRadius.circular(90.0),
                            ),
                            labelText: 'Email',
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                        child: TextField(
                          controller: password,
                          obscureText: true,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(90.0),
                            ),
                            labelText: 'Password',
                          ),
                        ),
                      ),
                      Container(
                          height: 80,
                          padding: const EdgeInsets.all(20),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(90.0)
                              ),
                              minimumSize: const Size.fromHeight(50),
                            ),
                            child: const Text('Register'),
                            onPressed: () {
                              
                            },
                          )),
                          TextButton(
                        onPressed: () {
                        },
                        child: Text(
                          'Sign up using google',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ),
                ],
              ),
            ),
    );
  }
}