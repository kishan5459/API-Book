import 'package:api_course/lib-old/Post/post_register.dart';
import 'package:api_course/lib-old/Get/home_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // home: const HomeScreen(),
      home: const PostRegisterScreen(),
    );
  }
}
