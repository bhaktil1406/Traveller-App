import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tourist_app/chat/GropListPage.dart';
import 'package:tourist_app/chat/feed.dart';
import 'package:tourist_app/chatbot.dart';
import 'package:tourist_app/pages/Homepage2.dart';
import 'package:tourist_app/pages/iternery.dart';
import 'package:tourist_app/pages/likepage.dart';
import 'package:tourist_app/pages/loginpage.dart';
import 'package:tourist_app/pages/profilepage.dart';
import 'package:tourist_app/pages/register.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:tourist_app/pages/search.dart';

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
      title: 'Traveller App',
      theme: ThemeData(fontFamily: GoogleFonts.montserrat().fontFamily),
      // theme: ThemeData(),
      home: isLoggedIn ? const Homepage2() : const register(),
      // home: ItineraryScreen(
      //   destination: 'Manali',
      //   totalDays: 2,
      // ),
      routes: {
        'register': (context) => const register(),
        'home': (context) => const Homepage2(),
        // 'category': (context) => const CategoryPage(),
        'search': (context) => const SearchPage(),
        'loginpage': (context) => const loginpage(),
        'chatbot': (context) => const chatbot(),
        'liked': (context) => const LikedPage(),
        'profile': (context) => const Profilepage(),
        'GroupListPage': (context) => const GroupListPage(),
        'feed': (context) => FeedPage(),
      },
    );
  }
}
