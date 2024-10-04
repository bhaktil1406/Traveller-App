import 'dart:convert';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:floating_bottom_navigation_bar/floating_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:tourist_app/pages/stateDetailspage.dart';

class Homepage2 extends StatefulWidget {
  const Homepage2({super.key});

  @override
  State<Homepage2> createState() => _Homepage2State();
}

class _Homepage2State extends State<Homepage2> {
  final double recContSizeHeight = 230;
  late int stateid;
  int _pageIndex = 0;

  final primaryColor = const Color(0xFF02050A);
  final secondayColor = const Color(0xFF1EFEBB);
  final ternaryColor = const Color(0xFF1B1E23);

  final List<Map<String, String>> destinations = [
    {'name': 'Singapore', 'imagePath': 'assets/singapore.jpg'},
    {'name': 'Taj Mahal', 'imagePath': 'assets/singapore.jpg'},
    {'name': 'Lotus Temple', 'imagePath': 'assets/singapore.jpg'},
    {'name': 'Goa Beach', 'imagePath': 'assets/singapore.jpg'},
    {'name': 'Manali', 'imagePath': 'assets/singapore.jpg'},
  ];

  void _onItemTapped(int index) {
    setState(() {
      _pageIndex = index;
    });
  }

  List listResponse = []; // Initialize as an empty list

  Future apicall() async {
    http.Response response;
    response = await http
        .get(Uri.parse("https://traveller-app-api.onrender.com/states/"));
    if (response.statusCode == 200) {
      setState(() {
        // No need for a map if you're working with a list directly
        listResponse =
            json.decode(response.body)['data']; // Assign list directly
      });
    }
  }

  Map? stateResponse;

  Future<void> fetchStateData() async {
    try {
      final response = await http.get(Uri.parse(
          'https://traveller-app-api.onrender.com/states/${stateid}'));

      if (response.statusCode == 200) {
        setState(() {
          stateResponse = json.decode(response.body)['data'];
        });
      } else {
        throw Exception('Failed to load state data');
      }
    } catch (e) {
      // Handle exceptions here
      print('Error: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    apicall(); // Call the API during widget initialization
    fetchStateData();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var safeArea = MediaQuery.of(context).padding.top;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      drawer: Drawer(
        backgroundColor: Colors.white,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  FirebaseAuth.instance.signOut();
                  Navigator.popAndPushNamed(context, "loginpage");
                },
                child: Text("Logout"),
              ),
              ElevatedButton(
                onPressed: () {
                  FirebaseAuth.instance.signOut();
                  Navigator.pushNamed(context, "chatbot");
                },
                child: Text("Chatbot"),
              ),
            ],
          ),
        ),
      ),
      backgroundColor: primaryColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: safeArea),
                SizedBox(
                  height: 60,
                  width: width,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'TripExpert',
                        style: GoogleFonts.satisfy(
                          color: Colors.white,
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          // Navigate to user account page
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: ternaryColor,
                            borderRadius: BorderRadius.circular(50),
                          ),
                          height: 100,
                          width: 50,
                          child: Padding(
                            padding: const EdgeInsets.all(18.0),
                            child: SvgPicture.asset(
                              'assets/m.svg',
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Hi,\nwhere do \nyou want to go?',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 20),
                // Category icons (e.g., Camping, Religious, Beaches)
                _buildCategoryIcons(),
                const SizedBox(height: 20),
                _buildRecommendedSection(),
                const SizedBox(height: 20),
                Text(
                  'Top Destinations',
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    color: Colors.white,
                    fontSize: 23,
                  ),
                ),
                const SizedBox(height: 14),
                _buildDestinationList(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryIcons() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildCategoryIcon('Camping', 'assets/m.svg'),
          SizedBox(width: 30),
          _buildCategoryIcon('Religious', 'assets/m.svg'),
          SizedBox(width: 30),
          _buildCategoryIcon('Beaches', 'assets/m.svg'),
          SizedBox(width: 30),
          _buildCategoryIcon('Mountains', 'assets/m.svg'),
          SizedBox(width: 30),
          _buildCategoryIcon('Historical', 'assets/m.svg'),
        ],
      ),
    );
  }

  Widget _buildCategoryIcon(String label, String iconPath) {
    return Column(
      children: [
        Container(
          height: 70,
          width: 70,
          padding: const EdgeInsets.all(18.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            color: ternaryColor,
          ),
          child: SvgPicture.asset(iconPath),
        ),
        const SizedBox(height: 5),
        Text(
          label,
          style: TextStyle(
            fontSize: 13,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildRecommendedSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Recommended',
          style: TextStyle(
            fontWeight: FontWeight.w400,
            color: Colors.white,
            fontSize: 23,
          ),
        ),
        const SizedBox(height: 14),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildRecommendedCard('Taj Mahal', 'assets/singapore.jpg'),
              SizedBox(width: 20),
              _buildRecommendedCard('Lotus Temple', 'assets/singapore.jpg'),
              SizedBox(width: 20),
              _buildRecommendedCard('Goa Beach', 'assets/singapore.jpg'),
              SizedBox(width: 20),
              _buildRecommendedCard('Manali', 'assets/singapore.jpg'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRecommendedCard(String name, String imagePath) {
    return Stack(
      children: [
        Container(
          height: 150,
          width: 200,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.asset(
              imagePath,
              fit: BoxFit.cover,
            ),
          ),
        ),
        Positioned(
          bottom: 10,
          left: 10,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.5),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                Icon(Icons.location_pin, color: secondayColor),
                Text(
                  name,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDestinationList() {
    return Column(
      children: List.generate(listResponse.length, (index) {
        // Ensure stateResponse is not null and contains 'state_data' and 'attr_data'
        final stateInfo = stateResponse?['state_data'];
        final attractions = stateResponse?['attr_data'];

        // Check if attractions exist and have 'images', otherwise use a placeholder
        String imageUrl = attractions != null &&
                attractions.containsKey('images')
            ? attractions['images']
            : ''; // Leave as an empty string to trigger CircularProgressIndicator

        return GestureDetector(
          onTap: () {
            // Ensure 'stateid' is assigned before using it
            stateid = listResponse[index][0];
            print(stateid);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Statedetailspage(stateid: stateid),
              ),
            );
          },
          child: Column(
            children: [
              Container(
                margin:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                child: Stack(
                  children: [
                    // Container to display image or loading indicator
                    Container(
                      height: 200,
                      width: double
                          .infinity, // Ensure it takes full available width
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.grey, // Placeholder background color
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        // child: imageUrl.isEmpty
                        //     ? Center(
                        //         child:
                        //             CircularProgressIndicator(), // Show loader when no image
                        //       )
                        //     : FadeInImage.assetNetwork(
                        //         placeholder: '',
                        //         image: '${imageUrl}',
                        //         height: 200,
                        //         width: 400,
                        //         fit: BoxFit.cover,
                        //         fadeInDuration: Duration(milliseconds: 500),
                        //         imageErrorBuilder:
                        //             (context, error, stackTrace) {
                        //           return Center(
                        //             child:
                        //                 CircularProgressIndicator(), // Keep showing the loader if there's an error
                        //           );
                        //         },
                        //       ),
                        child: Image.network(
                          "${listResponse[index][2]}",
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    // Positioned widget for the state name and location pin icon
                    Positioned(
                      bottom: 10,
                      left: 10,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.location_pin, color: Colors.white),
                            Text(
                              listResponse[index][1],
                              style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
