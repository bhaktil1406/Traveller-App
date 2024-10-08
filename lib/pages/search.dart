import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert'; // To decode JSON

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

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
      }
      // Add other navigation cases as needed
    });
  }

  // Default selected search type
  String _selectedType = 'all'; // Default is 'all'
  final List<String> _searchTypes = ['attraction', 'state', 'all'];

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
      backgroundColor: Color.fromARGB(255, 18, 17, 17),
      appBar: AppBar(
        title: Text("Search Attractions"),
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
              decoration: InputDecoration(
                labelText: "Search",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
              ),
              style: TextStyle(color: Colors.white),
              onSubmitted: (value) {
                if (value.isNotEmpty) {
                  _searchAttractions(value);
                }
              },
            ),
            SizedBox(height: 20),

            // Pill-shaped toggle buttons for selecting type
            ToggleButtons(
              borderColor: Colors.grey,
              selectedBorderColor: Colors.blue,
              fillColor: Colors.blue.withOpacity(0.1),
              color: const Color.fromARGB(255, 255, 255, 255),
              selectedColor: Colors.blue,
              isSelected:
                  _searchTypes.map((type) => type == _selectedType).toList(),
              onPressed: (index) {
                setState(() {
                  _selectedType = _searchTypes[index];
                });
              },
              children: _searchTypes.map((type) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child:
                      Text(type.capitalize(), style: TextStyle(fontSize: 16)),
                );
              }).toList(),
            ),
            SizedBox(height: 20),

            // Loading indicator
            if (_isLoading) CircularProgressIndicator(),

            // Search results
            Expanded(
              child: ListView.builder(
                itemCount: _results.length,
                itemBuilder: (context, index) {
                  var attraction = _results[index];
                  return Card(
                    elevation: 4.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Attraction image
                        Container(
                          height: 150,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.vertical(
                                top: Radius.circular(10.0)),
                            image: DecorationImage(
                              image: NetworkImage(attraction['type'] == 'state'
                                  ? attraction['STATE_IMAGE']
                                  : attraction['cover_img']),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                attraction['type'] == 'state'
                                    ? attraction['STATE_NAME']
                                    : attraction['name'],
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 5),
                              Text(
                                attraction['type'] == 'state'
                                    ? attraction['STATE_INFO'] ??
                                        'No description available.'
                                    : attraction['about'] ??
                                        'No description available.',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
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
                      offset: Offset(0, 5), // Position of the shadow
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
                        icon: Icon(Icons.chat),
                        label: 'Chatbot',
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(Icons.favorite),
                        label: 'Likes',
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
}

extension StringCasingExtension on String {
  String capitalize() {
    return this[0].toUpperCase() + this.substring(1);
  }
}
