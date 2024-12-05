import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:tourist_app/pages/AttractionPage.dart';
import 'package:tourist_app/pages/stateDetailspage.dart'; // To decode JSON

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  _SearchPageState createState() => _SearchPageState();
}

const primaryColor = Color(0xFF1EFEBB);
const secondayColor = Color(0xFF02050A);
const ternaryColor = Color(0xFF1B1E23);

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  bool _isLoading = false;
  List<dynamic> _results = [];
  int _selectedIndex = 1; // Default selected index

  // Function to handle navigation bar tap
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
        Navigator.pushReplacementNamed(context, 'itinerary');
      } else if (_selectedIndex == 4) {
        Navigator.pushReplacementNamed(context, 'FeedPage');
      }
    });
  }

  // Default selected search type
  String _selectedType = 'all'; // Default is 'all'
  final List<String> _searchTypes = ['all', 'state', 'attraction'];

  // API call function
  Future<void> _searchAttractions(String query) async {
    setState(() {
      _isLoading = true;
    });

    try {
      final String apiUrl =
          'https://traveller-app-api.onrender.com/search/query=$query&type=$_selectedType';
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _results = data["data"]; // Assuming the API returns a list of results
        });
      } else {
        throw Exception('Failed to load results');
      }
    } catch (error) {
      print('Error: $error');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 18, 17, 17),
      appBar: AppBar(
        title: const Text("Search",
            style: TextStyle(
                color: Colors.white,
                fontSize: 23,
                fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Search bar
            TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                labelText: "Search",
                floatingLabelStyle: TextStyle(color: primaryColor),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                      Radius.circular(30.0)), // Rounded corners
                ),
                prefixIcon: Icon(Icons.search),
                focusColor: primaryColor,
                hoverColor: primaryColor,
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(30.0)),
                  borderSide: BorderSide(
                      color: primaryColor), // Green border when focused
                ),
              ),
              style: const TextStyle(color: Colors.white),
              cursorColor: primaryColor,
              onSubmitted: (value) {
                if (value.length > 3) {
                  _searchAttractions(value);
                }
              },
            ),
            const SizedBox(height: 20),

            // Pill-shaped toggle buttons for selecting type

            ToggleButtons(
              borderColor: Colors.grey,
              selectedBorderColor: primaryColor,
              borderRadius: BorderRadius.circular(30.0),
              fillColor: primaryColor.withOpacity(0.2),
              color: Colors.white,
              selectedColor: primaryColor,
              isSelected:
                  _searchTypes.map((type) => type == _selectedType).toList(),
              onPressed: (index) {
                setState(() {
                  _selectedType = _searchTypes[index];
                });
              },
              children: _searchTypes.map((type) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(type.capitalize(),
                        style: const TextStyle(fontSize: 16)),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),

            // Loading indicator
            if (_isLoading) const CircularProgressIndicator(),

            // Search results
            Expanded(
              child: ListView.builder(
                itemCount: _results.length,
                itemBuilder: (context, index) {
                  var attraction = _results[index];
                  if (attraction["type"] == "attraction") {
                    return _buildAttrationCard(
                      attraction["id"], // Assuming each attraction has an id
                      attraction["name"], // Assuming each attraction has a name
                      attraction[
                          "cover_img"], // Assuming each attraction has an image path
                      attraction["city_name"],
                      attraction[
                          "state_name"], // Assuming each attraction has a state
                    );
                  } else {
                    return _buildStateCard(
                      attraction[
                          "STATE_ID"], // Assuming each attraction has an id
                      attraction[
                          "STATE_NAME"], // Assuming each attraction has a name
                      attraction[
                          "STATE_IMAGE"], // Assuming each attraction has an image path
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
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
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(Icons.search),
                        label: 'Search',
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(Icons.group),
                        label: 'Groups',
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(Icons.line_style_outlined),
                        label: 'AI Itinerary',
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(Icons.article_rounded),
                        label: 'Feed', // No label
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
    );
  }

  Widget _buildAttrationCard(
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
      child: Stack(
        children: [
          Column(
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
                        style:
                            const TextStyle(color: Colors.white, fontSize: 23),
                        overflow: TextOverflow.ellipsis, // Handle long names
                      ),
                    ),
                    const SizedBox(width: 50)
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
              ),
            ],
          ),
          Positioned(
            top: 10,
            right: 10,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.6),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                "Attraction",
                style: TextStyle(
                    color: primaryColor,
                    fontSize: 15,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStateCard(int id, String name, String imagePath) {
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
      child: Stack(
        children: [
          Column(
            children: [
              GestureDetector(
                onTap: () async {
                  // Navigate to the AttractionPage
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Statedetailspage(stateid: id),
                    ),
                  );
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
                        style:
                            const TextStyle(color: Colors.white, fontSize: 23),
                        overflow: TextOverflow.ellipsis, // Handle long names
                      ),
                    ),
                    const SizedBox(width: 50)
                  ],
                ),
              ),
            ],
          ),
          Positioned(
            top: 10,
            right: 10,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.6),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                "State",
                style: TextStyle(
                    color: primaryColor,
                    fontSize: 15,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

extension StringCasingExtension on String {
  String capitalize() {
    return this[0].toUpperCase() + substring(1);
  }
}
