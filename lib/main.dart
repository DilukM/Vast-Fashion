import 'package:admin/screens/admin/admin_page.dart';
import 'package:admin/screens/Customer/home_screen.dart';
import 'package:admin/screens/signin_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Vast Fashion',
      theme: ThemeData(
        // colorScheme: ColorScheme.dark(),
        colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(255, 54, 54, 226)),
        useMaterial3: true,
      ),
      home: const SignInScreen(),
      routes: {
        '/admin': (context) => const AdminPage(),
        '/customer': (context) => const HomePage(),
      },
    );
  }
}
