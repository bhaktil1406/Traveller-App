import 'dart:convert';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:tourist_app/pages/AttractionPage.dart';

class LikedPage extends StatefulWidget {
  const LikedPage({super.key});

  @override
  _LikedPageState createState() => _LikedPageState();
}

class _LikedPageState extends State<LikedPage> {
  bool isLoading = true;
  List<dynamic> likedAttractions = []; // List to store liked attractions
  List<int> likedIds = [];
  var apiUri = "https://traveller-app-api.onrender.com";
  int _selectedIndex = 3;

  @override
  void initState() {
    super.initState();
    fetchLikedAttractions(); // Start fetching liked attractions when the widget initializes
  }

  // Function to fetch the liked IDs from Firestore (replace with your own function)
  Future<List<int>> fetchLikedAttractionIds() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    User? currentUser = auth.currentUser;

    if (currentUser != null) {
      DocumentReference userDocRef =
          firestore.collection('user').doc(currentUser.uid);
      DocumentSnapshot userDoc = await userDocRef.get();

      if (userDoc.exists) {
        List<dynamic> liked = userDoc.get("liked");
        likedIds = List<int>.from(liked);
        return likedIds;
      }
      return [];
    } else {
      throw Exception('No user is currently signed in.');
    }
  }

  // Function to fetch detailed information about attractions using the liked IDs
  Future<void> fetchLikedAttractions() async {
    try {
      List<int> likedIds =
          await fetchLikedAttractionIds(); // Fetch the list of liked attraction IDs
      // Now fetch detailed information from the API for each liked attraction
      if (likedIds.isNotEmpty) {
        final response = await http.post(
          Uri.parse('$apiUri/liked'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(
              {'likedlist': likedIds}), // Send the list of IDs to the API
        );

        if (response.statusCode == 200) {
          print("hello");
          setState(() {
            likedAttractions = json
                .decode(response.body)["data"]; // Get detailed attractions info
            isLoading = false; // Data fetching completed
          });
        } else {
          print(
              'Failed to fetch attractions. Status code: ${response.statusCode}');
          setState(() {
            isLoading = false;
          });
        }
      } else {
        // No liked attractions, stop loading
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      print('Error fetching liked attractions: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  // Function to build individual cards using the provided builder
  Widget _buildRecommendedCard(
      int id, String name, String imagePath, String city, String state) {
    return Container(
      height: 300,
      width: double.infinity, // Make sure the width fills the container
      margin: const EdgeInsets.symmetric(
          vertical: 10), // Add vertical spacing between cards
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.3),
        borderRadius: BorderRadius.circular(25),
        border: Border.all(
          color: const Color.fromARGB(255, 80, 80, 80),
          style: BorderStyle.solid,
        ),
      ),
      child: Column(
        children: [
          GestureDetector(
            onTap: () async {
              // Navigate to the AttractionPage
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AttractionPage(attrId: id),
                ),
              );

              // Once back to the LikedPage, refresh the liked attractions
              fetchLikedAttractions(); // Call this method to refresh the list
            },
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(25),
                topRight: Radius.circular(25),
              ),
              child: Image.network(
                "$imagePath?w=300&h=-1&s=1", // Load image from URL
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    const Icon(Icons.error),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    name,
                    style: const TextStyle(color: Colors.white, fontSize: 23),
                    overflow: TextOverflow.ellipsis, // Handle long names
                  ),
                ),
                const SizedBox(width: 50),
                Container(
                  height: 40,
                  width: 40,
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: const Color.fromARGB(255, 43, 43, 43),
                  ),
                  child: const Icon(
                    Icons.favorite_border,
                    color: Color(0xFF1EFEBB),
                    size: 25,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            alignment: Alignment.topLeft,
            child: Text(
              "$city, $state",
              style: const TextStyle(
                color: Color.fromARGB(255, 95, 95, 95),
                fontSize: 17,
              ),
            ),
          )
        ],
      ),
    );
  }


  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      if (_selectedIndex == 0) {
        Navigator.pushReplacementNamed(context, 'home');
      } else if (_selectedIndex == 1) {
        Navigator.pushReplacementNamed(context, 'search');
      } else if (_selectedIndex == 2) {
        Navigator.pushReplacementNamed(context, 'GroupListPage');
      } else if (_selectedIndex == 3) {
        Navigator.pushReplacementNamed(context, 'liked');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 18, 17, 17),
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
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 18, 17, 17),
        title: const Text("Liked Attractions",
            style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator()) // Show loading spinner
          : likedAttractions.isEmpty
              ? const Center(
                  child: Text(
                  'No liked attractions found.',
                  style: TextStyle(color: Colors.white),
                )) // Show if no attractions are liked
              : ListView.builder(
                  itemCount: likedAttractions.length,
                  padding: const EdgeInsets.all(10),
                  itemBuilder: (context, index) {
                    var attraction = likedAttractions[index];
                    return _buildRecommendedCard(
                      attraction["id"], // Assuming each attraction has an id
                      attraction["name"], // Assuming each attraction has a name
                      attraction[
                          "cover_img"], // Assuming each attraction has an image path
                      attraction["city_name"],
                      attraction[
                          "state_name"], // Assuming each attraction has a state
                    );
                  },
                ),
    );
  }
}
