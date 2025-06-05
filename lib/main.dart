import 'package:flutter/material.dart';
import 'package:aalcver_tf_ipc/views/login_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BookIt',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Roboto',
        brightness: Brightness.dark,
        primarySwatch: Colors.deepPurple,
      ),
      home: LoginScreen(),
    );
  }
}
