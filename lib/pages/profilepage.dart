import 'package:flutter/material.dart';
import 'package:tourist_app/pages/auth.dart';

class Profilepage extends StatefulWidget {
  const Profilepage({super.key});

  @override
  State<Profilepage> createState() => _ProfilepageState();
}

class _ProfilepageState extends State<Profilepage> {
  String userName = 'Loading...';
  String userEmail = 'Loading...';

  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  // Function to load user data from AuthService
  void loadUserData() async {
    auth authService = auth();
    Map<String, String> userData = await authService.getUserData();

    setState(() {
      userName = userData['name'] ?? 'Guest';
      userEmail = userData['email'] ?? 'No email';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile Page')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Name: $userName', style: const TextStyle(fontSize: 20)),
            const SizedBox(height: 10),
            Text('Email: $userEmail', style: const TextStyle(fontSize: 20)),
          ],
        ),
      ),
    );
  }
}
