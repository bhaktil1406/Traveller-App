import 'dart:convert';
import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:tourist_app/pages/AttractionPage.dart';
import 'package:tourist_app/pages/auth.dart';
import 'package:tourist_app/pages/categoriespage.dart';
import 'package:tourist_app/pages/stateDetailspage.dart';

class Homepage2 extends StatefulWidget {
  const Homepage2({super.key});

  @override
  State<Homepage2> createState() => _Homepage2State();
}

class _Homepage2State extends State<Homepage2> {
  final double recContSizeHeight = 230;
  late int stateid;

  final primaryColor = const Color(0xFF1EFEBB);
  final secondaryColor = const Color(0xFF02050A);
  final ternaryColor = const Color(0xFF1B1E23);

  final List<Map<String, String>> destinations = [
    {'name': 'Singapore', 'imagePath': 'assets/singapore.jpg'},
    {'name': 'Taj Mahal', 'imagePath': 'assets/singapore.jpg'},
    {'name': 'Lotus Temple', 'imagePath': 'assets/singapore.jpg'},
    {'name': 'Goa Beach', 'imagePath': 'assets/singapore.jpg'},
    {'name': 'Manali', 'imagePath': 'assets/singapore.jpg'},
  ];

  int _selectedIndex = 0;

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
        Navigator.pushReplacementNamed(context, 'liked');
      } else if (_selectedIndex == 4) {
        Navigator.pushReplacementNamed(context, 'Group');
      }
    });
  }

  List listResponse = []; // Initialize as an empty list
  var recommListIds;
  List recommendedlist = [];
  var apiUri = "https://traveller-app-api.onrender.com";
  bool isLoading = true;

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

  Future<List<int>> fetchRecommAttractionIds() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    User? currentUser = auth.currentUser;

    if (currentUser != null) {
      DocumentReference userDocRef =
          firestore.collection('user').doc(currentUser.uid);
      DocumentSnapshot userDoc = await userDocRef.get();

      if (userDoc.exists) {
        List<dynamic> recomm = userDoc.get("categories");
        recommListIds = List<int>.from(recomm);
        return recommListIds;
      }
      return [];
    } else {
      throw Exception('No user is currently signed in.');
    }
  }

  Future recommended() async {
    try {
      List<int> recommIds =
          await fetchRecommAttractionIds(); // Fetch the list of liked attraction IDs
      // Now fetch detailed information from the API for each liked attraction
      if (recommIds.isNotEmpty) {
        print(recommIds);
        final response = await http.post(
          Uri.parse('https://traveller-app-api.onrender.com/recommended_attr/'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(
              {'recommListId': recommIds}), // Send the list of IDs to the API
        );
        print(json.decode(response.body)["data"]);
        if (response.statusCode == 200) {
          print("hello");
          setState(() {
            recommendedlist = json
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

  Map? stateResponse;

  Future<void> fetchStateData() async {
    try {
      final response = await http.get(
          Uri.parse('https://traveller-app-api.onrender.com/states/$stateid'));

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
    recommended();
    loadUserData();
  }

  String userName = 'Loading...';

  void loadUserData() async {
    auth authService = auth();
    Map<String, String> userData = await authService.getUserData();

    setState(() {
      userName = userData['name'] ?? 'Guest';
    });
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var safeArea = MediaQuery.of(context).padding.top;

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
                        icon: Icon(Icons.group),
                        label: 'Groups', // No label
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

      // bottomNavigationBar: BottomNavigationBar(
      //   items: [
      //     BottomNavigationBarItem(
      //         icon: Icon(
      //           Icons.home,
      //           color: primaryColor,
      //         ),
      //         label: 'Home'),
      //     BottomNavigationBarItem(
      //         icon: Icon(
      //           Icons.search,
      //           color: primaryColor,
      //         ),
      //         label: 'Search'),
      //     BottomNavigationBarItem(
      //         icon: Icon(
      //           Icons.favorite,
      //           color: primaryColor,
      //         ),
      //         label: 'Like'),
      //     BottomNavigationBarItem(
      //         icon: Icon(
      //           Icons.person,
      //           color: primaryColor,
      //         ),
      //         label: 'Profile'),
      //   ],
      //   backgroundColor: Colors.black.withOpacity(0.3),
      //   selectedItemColor: Colors.black,
      // ),
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
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
                child: const Text("Logout"),
              ),
              ElevatedButton(
                onPressed: () {
                  FirebaseAuth.instance.signOut();
                  Navigator.pushNamed(context, "chatbot");
                },
                child: const Text("Chatbot"),
              ),
            ],
          ),
        ),
      ),
      // backgroundColor: primaryColor,
      body: Stack(
        children: [
          // Background image container
          // Container(
          //   decoration: BoxDecoration(
          //     image: DecorationImage(
          //       image: AssetImage('assets/un1.png'),
          //       fit: BoxFit.cover,
          //     ),
          //   ),
          // ),
          // The rest of your content goes here
          SingleChildScrollView(
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
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, "profile");
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.5),
                                shape: BoxShape.circle),
                            height: 100,
                            width: 50,
                            child: Padding(
                              padding: const EdgeInsets.all(14.0),
                              // child: SvgPicture.asset(
                              //   'assets/m.svg',
                              // ),
                              child: Icon(
                                Icons.person,
                                color: primaryColor,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Welcome $userName',
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                      fontSize: 25,
                    ),
                  ),
                  //const SizedBox(height: 20),
                  // Container(
                  //   width: double.infinity,
                  //   padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  //   decoration: BoxDecoration(
                  //       color: Colors.black.withOpacity(0.3),
                  //       border: Border.all(
                  //         color: const Color.fromARGB(255, 80, 80, 80),
                  //         style: BorderStyle.solid,
                  //       ),
                  //       borderRadius: BorderRadius.circular(25)),
                  //   child: TextField(
                  //     decoration: InputDecoration(
                  //         border: InputBorder.none,
                  //         hintText: "Search",
                  //         hintStyle:
                  //             TextStyle(color: Colors.white, fontSize: 18),
                  //         prefixIcon: Icon(
                  //           Icons.search,
                  //           color: primaryColor,
                  //           size: 25,
                  //         )),
                  //   ),
                  // ),
                  const SizedBox(height: 20),
                  _buildCategoryIcons(),
                  const SizedBox(height: 20),
                  _buildRecommendedSection(),
                  const SizedBox(height: 25),
                  // Padding(
                  //   padding: const EdgeInsets.symmetric(horizontal: 30),
                  //   child:
                  //       Divider(color: const Color.fromARGB(255, 80, 80, 80)),
                  // ),
                  const SizedBox(height: 20),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 15),
                    decoration: BoxDecoration(
                        //  color: Colors.black.withOpacity(0.3),
                        // border: Border.all(
                        //   color: const Color.fromARGB(255, 80, 80, 80),
                        //   style: BorderStyle.solid,
                        // ),
                        borderRadius: BorderRadius.circular(25)),
                    child: const Text(
                      'Top States',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 26,
                      ),

                      // style: TextStyle(
                      //   fontWeight: FontWeight.w400,
                      //   color: Colors.white,
                      //   fontSize: 23,
                      // ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  _buildDestinationList(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryIcons() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildCategoryIcon('Trekking', 'assets/svg/trekking.svg', 0),
          const SizedBox(width: 30),
          _buildCategoryIcon('Religious', 'assets/svg/religious.svg', 1),
          const SizedBox(width: 30),
          _buildCategoryIcon('Beaches', 'assets/svg/beach.svg', 2),
          const SizedBox(width: 30),
          _buildCategoryIcon('Mountains', 'assets/svg/mountain.svg', 3),
          const SizedBox(width: 30),
          _buildCategoryIcon('Historical', 'assets/svg/historical.svg', 4),
          const SizedBox(width: 30),
          _buildCategoryIcon('Museum', 'assets/svg/museum.svg', 5),
          const SizedBox(width: 30),
          _buildCategoryIcon(
              'National Parks', 'assets/svg/nationalpark.svg', 6),
          const SizedBox(width: 30),
          _buildCategoryIcon('Wildlife', 'assets/svg/wildlife.svg', 7),
        ],
      ),
    );
  }

  Widget _buildCategoryIcon(String label, String iconPath, int categoryId) {
    return GestureDetector(
      onTap: () async {
        // Navigate to the AttractionPage
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                CategoryPage(categoryId: categoryId, label: label),
          ),
        );
      },
      child: Column(
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
            style: const TextStyle(
              fontSize: 13,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  // Widget _buildRecommendedSection() {
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       Text(
  //         'Recommended',
  //         style: TextStyle(
  //           fontWeight: FontWeight.w400,
  //           color: Colors.white,
  //           fontSize: 23,
  //         ),
  //       ),
  //       const SizedBox(height: 14),
  //       SingleChildScrollView(
  //         scrollDirection: Axis.horizontal,
  //         child: Row(
  //           mainAxisAlignment: MainAxisAlignment.spaceAround,
  //           children: [
  //             // _buildRecommendedCard('Taj Mahal', 'assets/singapore.jpg'),
  //             // SizedBox(width: 20),
  //             // _buildRecommendedCard('Lotus Temple', 'assets/singapore.jpg'),
  //             // SizedBox(width: 20),
  //             // _buildRecommendedCard('Goa Beach', 'assets/singapore.jpg'),
  //             // SizedBox(width: 20),
  //             // _buildRecommendedCard('Manali', 'assets/singapore.jpg'),
  //             recommendedlist.isEmpty
  //                 ? Center(child: CircularProgressIndicator())
  //                 : ListView.builder(
  //                     itemCount: recommendedlist.length,
  //                     itemBuilder: (context, index) {
  //                       return _buildRecommendedCard(
  //                         recommendedlist[index]['name'],
  //                         recommendedlist[index]['images']
  //                             [0], // Assuming the image URL is here
  //                       );
  //                     },
  //                   ),
  //           ],
  //         ),
  //       ),
  //     ],
  //   );
  // }
  Widget _buildRecommendedSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
          decoration: BoxDecoration(
              // color: Colors.black.withOpacity(0.3),
              // border: Border.all(
              //   color: const Color.fromARGB(255, 80, 80, 80),
              //   style: BorderStyle.solid,
              // ),
              borderRadius: BorderRadius.circular(25)),
          child: const Text(
            'Recommended',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontSize: 26,
            ),
            // style: TextStyle(
            //   fontWeight: FontWeight.w400,
            //   color: primaryColor,
            //   fontSize: 23,
            // ),
          ),
        ),
        const SizedBox(height: 14),
        recommendedlist.isEmpty
            ? Center(
                child: CircularProgressIndicator(
                color: primaryColor,
              ))
            : SizedBox(
                height: 300, // Set an explicit height for the scrollable area
                child: ListView.builder(
                  scrollDirection: Axis.horizontal, // Horizontal scrolling
                  itemCount: recommendedlist.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: _buildRecommendedCard(
                        recommendedlist[index]['id'],
                        recommendedlist[index]['name'],
                        recommendedlist[index]['cover_img'],
                        recommendedlist[index]['city_name'],
                        recommendedlist[index]['state_name'],
                      ),
                    );
                  },
                ),
              ),
      ],
    );
  }

  // Widget _buildRecommendedCard(String name, String imagePath) {
  //   return Container(
  //     height: 300,
  //     width: 300,
  //     decoration: BoxDecoration(
  //         borderRadius: BorderRadius.circular(10),
  //         border: Border.all(
  //             color: const Color.fromARGB(255, 80, 80, 80),
  //             style: BorderStyle.solid)),
  //     child: Column(
  //       children: [
  //         ClipRRect(
  //           child: Image.network(
  //             "${imagePath}",
  //             fit: BoxFit.contain,
  //           ),
  //           borderRadius: BorderRadius.only(
  //               topLeft: Radius.circular(10), topRight: Radius.circular(10)),
  //         ),
  //         SizedBox(
  //           height: 10,
  //         ),
  //         Padding(
  //           padding: const EdgeInsets.symmetric(horizontal: 10),
  //           child: Row(
  //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //             children: [
  //               Text(
  //                 name,
  //                 style: TextStyle(color: Colors.white, fontSize: 18),
  //               ),
  //               SizedBox(
  //                 width: 50,
  //               ),
  //               Icon(
  //                 Icons.safety_check,
  //                 color: Colors.white,
  //                 size: 20,
  //               ),
  //             ],
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  Widget _buildRecommendedCard(
      int id, String name, String imagePath, String city, String state) {
    return Container(
      height: 300,
      width: 300,
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
            onTap: () {
              //  // Navigate to AttractionPage and pass the ID
              Navigator.push(
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
                    style: const TextStyle(color: Colors.white, fontSize: 23),
                    overflow: TextOverflow.ellipsis, // Handle long names
                  ),
                ),
                const SizedBox(width: 50),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            alignment: Alignment.topLeft,
            child: Text(
              "$city, $state",
              style: const TextStyle(
                  color: Color.fromARGB(255, 95, 95, 95), fontSize: 17),
            ),
          )
        ],
      ),
    );
  }

  Widget buildVerticalLine() {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        width: 2, // Thickness of the vertical line

        height: double.infinity, // Full height of the grid item

        color: const Color.fromARGB(255, 255, 250, 250)
            .withOpacity(0.3), // Line color with some transparency
      ),
    );
  }

  Widget _buildDestinationList() {
    // Check if the listResponse is null or empty

    if (listResponse.isEmpty) {
      return Center(
        child: CircularProgressIndicator(
          color: primaryColor,
        ), // Show loading indicator while the list is loading
      );
    }

    return GridView.builder(
      shrinkWrap: true, // Allows the GridView to take only necessary space

      physics: const NeverScrollableScrollPhysics(), // Disable its scrolling

      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, // Number of items per row

        crossAxisSpacing: 5, // Horizontal space between items

        mainAxisSpacing: 5, // Vertical space between items

        childAspectRatio: 1, // Ratio of width to height of grid items
      ),

      padding: const EdgeInsets.all(10),

      itemCount: listResponse.length, // Number of items in the grid

      itemBuilder: (context, index) {
        bool isSecondItem = (index % 2 != 0);

        return Stack(
          children: [
            if (index % 2 == 1) Positioned.fill(child: buildVerticalLine()),
            Transform.translate(
              offset: isSecondItem ? const Offset(0, 30) : const Offset(0, 0),
              child: GestureDetector(
                onTap: () {
                  stateid = listResponse[index][0];

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
                      margin: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 15),
                      child: Stack(
                        children: [
                          Container(
                            height: 120,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.grey,
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.network(
                                "${listResponse[index][2]}",
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 10,
                            left: 10,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 8),
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.3),
                                borderRadius: BorderRadius.circular(25),
                              ),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.location_pin,
                                    color: Color(0xFF1EFEBB),
                                    size: 10,
                                  ),
                                  Text(
                                    listResponse[index][1],
                                    style: GoogleFonts.poppins(
                                      color: Colors.white,
                                      fontSize: 10,
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
              ),
            ),
          ],
        );
      },
    );
  }
}

// Function to build the vertical line
Widget buildVerticalLine() {
  return Align(
    alignment: Alignment.centerRight,
    child: Container(
      width: 2, // Thickness of the vertical line
      height: double.infinity, // Full height of the grid item
      color: const Color.fromARGB(255, 255, 250, 250)
          .withOpacity(0.3), // Line color
    ),
  );
}

// Widget _buildDestinationList() {
// Check if the listResponse is null or empty
// if (listResponse == null || listResponse.isEmpty) {
//   return Center(
//     child: CircularProgressIndicator(), // Show loading indicator while the list is loading
//   );
// }

//   return Column(
//     children: List.generate(listResponse.length, (index) {
//       // Ensure stateResponse is not null and contains 'state_data' and 'attr_data'
//       final stateInfo = stateResponse?['state_data'];
//       final attractions = stateResponse?['attr_data'];

//       // Check if attractions exist and have 'images', otherwise use a placeholder
//       String imageUrl = attractions != null &&
//               attractions.containsKey('images')
//           ? attractions['images']
//           : ''; // Leave as an empty string to trigger CircularProgressIndicator

//       return GestureDetector(
//         onTap: () {
//           // Ensure 'stateid' is assigned before using it
//           stateid = listResponse[index][0];
//           print(stateid);
//           Navigator.push(
//             context,
//             MaterialPageRoute(
//               builder: (context) => Statedetailspage(stateid: stateid),
//             ),
//           );
//         },
//         child: Column(
//           children: [
//             Container(
//               margin:
//                   const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
//               child: Stack(
//                 children: [
//                   // Container to display image or loading indicator
//                   Container(
//                     height: 200,
//                     width: double
//                         .infinity, // Ensure it takes full available width
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(10),
//                       color: Colors.grey, // Placeholder background color
//                     ),
//                     child: ClipRRect(
//                       borderRadius: BorderRadius.circular(10),
//                       // child: imageUrl.isEmpty
//                       //     ? Center(
//                       //         child:
//                       //             CircularProgressIndicator(), // Show loader when no image
//                       //       )
//                       //     : FadeInImage.assetNetwork(
//                       //         placeholder: '',
//                       //         image: '${imageUrl}',
//                       //         height: 200,
//                       //         width: 400,
//                       //         fit: BoxFit.cover,
//                       //         fadeInDuration: Duration(milliseconds: 500),
//                       //         imageErrorBuilder:
//                       //             (context, error, stackTrace) {
//                       //           return Center(
//                       //             child:
//                       //                 CircularProgressIndicator(), // Keep showing the loader if there's an error
//                       //           );
//                       //         },
//                       //       ),
//                       child: Image.network(
//                         "${listResponse[index][2]}",
//                         fit: BoxFit.cover,
//                       ),
//                     ),
//                   ),
//                   // Positioned widget for the state name and location pin icon
//                   Positioned(
//                     bottom: 10,
//                     left: 10,
//                     child: Container(
//                       padding: const EdgeInsets.symmetric(
//                           horizontal: 8, vertical: 8),
//                       decoration: BoxDecoration(
//                         color: Colors.black.withOpacity(0.5),
//                         borderRadius: BorderRadius.circular(10),
//                       ),
//                       child: Row(
//                         children: [
//                           const Icon(Icons.location_pin, color: Colors.white),
//                           Text(
//                             listResponse[index][1],
//                             style: GoogleFonts.poppins(
//                               color: Colors.white,
//                               fontSize: 14,
//                               fontWeight: FontWeight.w600,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       );
//     }),
//   );
// }
