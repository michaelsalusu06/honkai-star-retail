import 'package:flutter/material.dart';
import 'views/page1.dart'; // Points to your newly created page1.dart

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Honkai Star Retail',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
      ),
      home: const Page1(), // Sets page 1 as the application starting point
    );
  }
}