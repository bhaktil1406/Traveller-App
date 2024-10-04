import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tourist_app/chatbot.dart';
import 'package:tourist_app/pages/home.dart';
import 'package:tourist_app/pages/Homepage2.dart';
import 'package:tourist_app/pages/loginpage.dart';
import 'package:tourist_app/pages/phoneregi.dart';
import 'package:tourist_app/pages/register.dart';
import 'package:firebase_core/firebase_core.dart';

import 'pages/otp.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    bool isLoggedIn = FirebaseAuth.instance.currentUser != null;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(),
      home: isLoggedIn ? const Homepage2() : register(),
      routes: {
        'register': (context) => register(),
        'phoneregi': (context) => phoneregi(),
        'home': (context) => Homepage2(),
        'otp': (context) => otp(),
        'loginpage': (context) => loginpage(),
        'chatbot': (context) => chatbot(),
      },
    );
  }
}
