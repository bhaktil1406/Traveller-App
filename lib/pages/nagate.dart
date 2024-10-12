import 'dart:ui'; // Needed for BackdropFilter
import 'package:flutter/material.dart';

class Navigation extends StatefulWidget {
  const Navigation({super.key});

  @override
  _NavigationState createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> {
  int _selectedIndex = 0;

  // Function to handle navigation bar tap
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      if (_selectedIndex == 0) {
        Navigator.pushReplacementNamed(context, 'home');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Stack(
          children: [
            // This adds a shadow below the bar for a floating effect
            Positioned(
              bottom: 10,
              left: 0,
              right: 0,
              child: Container(
                height: 80,
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.25),
                      blurRadius: 20,
                      spreadRadius: 5,
                      offset: const Offset(0, 5), // Position of the shadow
                    )
                  ],
                ),
              ),
            ),
            // Glassmorphism effect with blur and transparency
            ClipRRect(
              borderRadius: BorderRadius.circular(30.0),
              child: BackdropFilter(
                filter: ImageFilter.blur(
                    sigmaX: 15.0,
                    sigmaY: 15.0), // Stronger blur for the glass effect
                child: Container(
                  height: 70,
                  decoration: BoxDecoration(
                    color: Colors.white
                        .withOpacity(0.1), // Adjust the transparency here
                    borderRadius: BorderRadius.circular(30.0),
                    border: Border.all(
                      color: Colors.white
                          .withOpacity(0.2), // Border for the glassy look
                      width: 1.5,
                    ),
                  ),
                  child: BottomNavigationBar(
                    type: BottomNavigationBarType.fixed,
                    backgroundColor: Colors.transparent, // Set to transparent
                    elevation: 0, // No shadow from the BottomNavigationBar
                    items: const <BottomNavigationBarItem>[
                      BottomNavigationBarItem(
                        icon: Icon(Icons.home),
                        label: 'Home',
                        // backgroundColor: Color(0xFF1EFEBB) // No label
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(Icons.search),
                        label: 'Search', // No label
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(Icons.chat),
                        label: 'Chatbot', // No label
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(Icons.favorite),
                        label: 'Likes', // No label
                      ),
                    ],
                    currentIndex: _selectedIndex,
                    selectedItemColor: Colors.white,
                    unselectedItemColor: Colors.grey,
                    onTap: _onItemTapped,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      backgroundColor:
          Colors.black, // Makes the background look good with floating effect
    );
  }
}
