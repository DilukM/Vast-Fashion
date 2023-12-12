import 'package:admin/reusable_widgets/reusablewidgets.dart';
import 'package:admin/screens/admin/admin_page.dart';
import 'package:admin/screens/Customer/home_screen.dart';
import 'package:admin/screens/signin_screen.dart';
import 'package:admin/utils/color_util.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String _selectedUserRole = 'customer';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  hexStringToColor("#47894b"),
                  hexStringToColor("#5ea758"),
                  hexStringToColor("#8bbd78"),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                    20, MediaQuery.of(context).size.height * 0.2, 20, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    const SizedBox(height: 30),
                    reusableTextField("Enter Username", Icons.person_outline,
                        false, _userNameController),
                    const SizedBox(height: 30),
                    reusableTextField("Enter Email", Icons.email_outlined,
                        false, _emailController),
                    const SizedBox(height: 30),
                    reusableTextField("Enter Password", Icons.lock_outline,
                        true, _passwordController),
                    const SizedBox(height: 30),
                    ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.resolveWith((states) {
                            if (states.contains(MaterialState.pressed)) {
                              return Colors.black26;
                            }
                            return Colors.white;
                          }),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(30.0)))),
                      onPressed: () async {
                        await _register();
                      },
                      child: const Text(
                        'Register',
                        style: const TextStyle(
                            color: Colors.black87,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(height: 16),
                    signInOption()
                  ],
                ),
              ),
            )));
  }

  Future<void> _register() async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      // Add user data to Firestore
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user?.uid)
          .set({
        'username': _userNameController.text.trim(),
        'email': _emailController.text.trim(),
        'userType': 'customer',
      });

      // Navigate to home screen based on user type
      if (_selectedUserRole == 'admin') {
        Navigator.pushReplacementNamed(context, '/admin');
      } else {
        Navigator.pushReplacementNamed(context, '/customer');
      }
    } on FirebaseAuthException catch (e) {
      print('Failed to register: $e');
      // Handle registration errors (e.g., display an error message)
    }
  }

  signInOption() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Already have an account?  ",
            style: TextStyle(color: Colors.white70)),
        GestureDetector(
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const SignInScreen()));
          },
          child: const Text("Sign In",
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        )
      ],
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: const RegistrationScreen(),
    routes: {
      '/admin': (context) => const AdminPage(),
      '/customer': (context) => const HomePage(),
    },
  ));
}
