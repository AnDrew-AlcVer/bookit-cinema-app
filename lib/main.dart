import 'package:flutter/material.dart';
import 'package:aalcver_tf_ipc/views/login_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CineApp',
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
