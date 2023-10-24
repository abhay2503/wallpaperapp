import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:wallpaper/admin.dart';
import 'package:wallpaper/popular.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Wallpaper app',
      theme: ThemeData.dark().copyWith(scaffoldBackgroundColor: Colors.black),
      home: Popular(),
    );
  }
}
