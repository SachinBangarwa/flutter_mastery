import 'package:flutter/material.dart';
import 'package:flutter_mastery/auth/screens/onb_screen.dart';
import 'package:flutter_mastery/core/storage/storage_helper.dart';
import 'package:flutter_mastery/dash/screens/main_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await StorageHelper.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Mastery',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      home: StorageHelper.getLoggedIn()
          ? const MainScreen()
          : const OnbScreen(),
    );
  }
}
