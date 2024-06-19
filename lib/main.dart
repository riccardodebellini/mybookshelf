import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mybookshelf/sys/auth_system.dart';
import 'package:mybookshelf/sys/firebase_options.dart';





// RUN APP AND WAIT FOR FIREBASE
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
   
  runApp(const MyApp());

}

// APP
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      
      // Theming
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.lightBlue,
            brightness: Brightness.light),
      ),
      title: "MyBookshelf",
      home: const AuthSystem(), // Home page
    );
  }
}



