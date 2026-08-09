import 'package:flutter/material.dart';

import 'auth/screens/onb_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
     debugShowCheckedModeBanner: false,

      theme: ThemeData(
        

        colorScheme: .fromSeed(seedColor: Colors.deepPurple),
      ),

      home: OnbScreen(),
    );
  }
}

