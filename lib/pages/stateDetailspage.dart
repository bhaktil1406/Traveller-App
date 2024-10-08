// import 'dart:convert';

// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:card_swiper/card_swiper.dart';

// class Statedetailspage extends StatefulWidget {
//   final int stateid; // State ID passed from the previous screen

//   const Statedetailspage({required this.stateid, Key? key}) : super(key: key);

//   @override
//   State<Statedetailspage> createState() => _StatedetailspageState();
// }

// class _StatedetailspageState extends State<Statedetailspage> {
//   Map? stateResponse;

//   Future<void> fetchStateData() async {
//     try {
//       final response = await http.get(Uri.parse(
//           'https://traveller-app-api.onrender.com/states/${widget.stateid}'));

//       if (response.statusCode == 200) {
//         setState(() {
//           stateResponse = json.decode(response.body)['data'];
//         });
//       } else {
//         throw Exception('Failed to load state data');
//       }
//     } catch (e) {
//       // Handle exceptions here
//       print('Error: $e');
//     }
//   }

//   @override
//   void initState() {
//     super.initState();
//     fetchStateData(); // Fetch the state details when the page loads
//   }

//   @override
//   Widget build(BuildContext context) {
//     bool isExpanded = false;
//     if (stateResponse == null) {
//       return Scaffold(
//         backgroundColor: Colors.black,
//         body: Center(child: CircularProgressIndicator()),
//       );
//     }

//     final stateInfo = stateResponse!['state_data'];
//     final attractions = stateResponse!['attr_data'];
//     List<dynamic> attractionss = stateResponse!['attr_data'];
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.black,
//         iconTheme: IconThemeData(color: Colors.white),
//       ),
//       backgroundColor: Colors.black, // Example background color
//       body: SafeArea(
//         child: SingleChildScrollView(
//           child: Column(
//             children: [
//               Container(
//                 margin: EdgeInsets.all(10),
//                 height: 300,
//                 padding: EdgeInsets.only(top: 30, right: 20, left: 20),
//                 decoration: BoxDecoration(
//                   color: Color.fromARGB(
//                       30, 255, 255, 255), // Make container transparent
//                   borderRadius: BorderRadius.circular(15), // Rounded corners
//                   border: Border.all(
//                       color: const Color.fromARGB(255, 0, 0, 0),
//                       width: 1), // Border
//                 ),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       stateInfo['state_name'] ?? 'Unknown State',
//                       style: TextStyle(color: Colors.white, fontSize: 30),
//                     ),
//                     const SizedBox(height: 10),
//                     // Display state_info with a "More" button
//                     Text(
//                       stateInfo['state_info'] ?? 'No information available',
//                       maxLines: isExpanded
//                           ? null
//                           : 5, // Control lines with isExpanded
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontSize: 16,
//                         overflow: TextOverflow
//                             .ellipsis, // Handle overflow with ellipsis
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               Container(
//                 margin: EdgeInsets.all(10),
//                 height: 300,
//                 padding: EdgeInsets.only(top: 30, right: 20, left: 20),
//                 decoration: BoxDecoration(
//                   // color: Color.fromARGB(
//                   //     30, 255, 255, 255), // Make container transparent
//                   borderRadius: BorderRadius.circular(15), // Rounded corners
//                   border: Border.all(
//                       color: const Color.fromARGB(255, 0, 0, 0),
//                       width: 1), // Border
//                 ),
//                 child: Column(
//                   children: [
//                     Container(
//                       alignment: Alignment.topLeft,
//                       child: Text(
//                         "Most attracted places",
//                         style: TextStyle(color: Colors.white, fontSize: 25),
//                       ),
//                     ),
//                     Swiper(itemCount: 3,)
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:http/http.dart' as http;
// import 'package:card_swiper/card_swiper.dart';
// import 'package:readmore/readmore.dart';
// import 'package:tourist_app/pages/AttractionPage.dart';

// class Statedetailspage extends StatefulWidget {
//   final int stateid; // State ID passed from the previous screen

//   const Statedetailspage({required this.stateid, Key? key}) : super(key: key);

//   @override
//   State<Statedetailspage> createState() => _StatedetailspageState();
// }

// class _StatedetailspageState extends State<Statedetailspage> {
//   Map? stateResponse;

//   Future<void> fetchStateData() async {
//     try {
//       final response = await http.get(Uri.parse(
//           'https://traveller-app-api.onrender.com/states/${widget.stateid}'));

//       if (response.statusCode == 200) {
//         setState(() {
//           stateResponse = json.decode(response.body)['data'];
//         });
//       } else {
//         throw Exception('Failed to load state data');
//       }
//     } catch (e) {
//       // Handle exceptions here
//       print('Error: $e');
//     }
//   }

//   @override
//   void initState() {
//     super.initState();
//     fetchStateData(); // Fetch the state details when the page loads
//   }

//   @override
//   Widget build(BuildContext context) {
//     bool isExpanded = false;
//     if (stateResponse == null) {
//       return Scaffold(
//         backgroundColor: Color.fromARGB(41, 93, 93, 91),
//         body: Center(child: CircularProgressIndicator()),
//       );
//     }

//     final stateInfo = stateResponse!['state_data'];
//     final attractions = stateResponse!['attr_data'];

//     return Scaffold(
//       // appBar: AppBar(
//       //    backgroundColor: Color.fromARGB(41, 93, 93, 91),
//       //   iconTheme: IconThemeData(color: Colors.white),
//       // ),
//       backgroundColor:
//           Color.fromARGB(41, 93, 93, 91), // Example background color
//       body: Stack(
//         children: [
//           Container(
//             decoration: BoxDecoration(
//               image: DecorationImage(
//                 image: AssetImage('assets/un1.png'),
//                 fit: BoxFit.cover,
//               ),
//             ),
//           ),
//           SingleChildScrollView(
//             child: Column(
//               children: [
//                 Container(
//                   margin: EdgeInsets.all(5),
//                   // height: 300,
//                   padding: EdgeInsets.only(top: 30, right: 5, left: 35),
//                   // decoration: BoxDecoration(
//                   //   // color: Color.fromARGB(
//                   //   //     30, 255, 255, 255), // Make container transparent
//                   //   borderRadius: BorderRadius.circular(15), // Rounded corners
//                   //   border: Border.all(
//                   //       color: const Color.fromARGB(255, 0, 0, 0),
//                   //       width: 1), // Border
//                   // ),
//                   child: Container(
//                     padding: EdgeInsets.all(20),
//                     decoration: BoxDecoration(
//                         color: Colors.black.withOpacity(0.3),
//                         border: Border.all(
//                           color: const Color.fromARGB(255, 80, 80, 80),
//                           style: BorderStyle.solid,
//                         ),
//                         borderRadius: BorderRadius.circular(25)),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           stateInfo['state_name'] ?? 'Unknown State',
//                           style: GoogleFonts.montserrat(
//                             fontWeight: FontWeight.w500,
//                             color: Colors.white,
//                             fontSize: 25,
//                           ),
//                         ),
//                         const SizedBox(height: 10),
//                         ReadMoreText(
//                           stateInfo["state_info"],
//                           lessStyle: TextStyle(
//                               fontWeight: FontWeight.w600,
//                               color: Color(0xFF1EFEBB)),
//                           moreStyle: TextStyle(
//                               fontWeight: FontWeight.w600,
//                               color: Color(0xFF1EFEBB)),
//                           style: TextStyle(color: Colors.white, fontSize: 15),
//                         ),
//                         SizedBox(
//                           height: 20,
//                         ),
//                         Row(
//                           children: [
//                             // Text(
//                             //   "State capital",
//                             //   style: TextStyle(
//                             //       color: Colors.white,
//                             //       fontSize: 17,
//                             //       fontWeight: FontWeight.w600),
//                             // ),
//                             Icon(
//                               Icons.location_on,
//                               color: Color(0xFF1EFEBB),
//                             ),
//                             SizedBox(
//                               width: 10,
//                             ),
//                             Text(
//                               stateInfo?["state_capital"] ??
//                                   'No information available',
//                               style: TextStyle(
//                                   color: Colors.white,
//                                   fontSize: 17,
//                                   fontWeight: FontWeight.w500),
//                             ),
//                           ],
//                         ),
//                         SizedBox(
//                           height: 20,
//                         ),
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.start,
//                           children: [
//                             Container(
//                               child: Image.asset(
//                                 "assets/weather2.png",
//                                 height: 30,
//                                 width: 30,
//                               ),
//                             ),
//                             SizedBox(
//                               width: 20,
//                             ),
//                             Text(
//                               "Weather is not Display",
//                               style: TextStyle(color: Colors.white),
//                             )
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//                 Container(
//                   margin: EdgeInsets.all(10),
//                   padding: EdgeInsets.only(top: 30, right: 0, left: 30),
//                   // decoration: BoxDecoration(
//                   //   borderRadius: BorderRadius.circular(15), // Rounded corners
//                   //   border: Border.all(
//                   //       color: const Color.fromARGB(255, 0, 0, 0),
//                   //       width: 1), // Border
//                   // ),
//                   child: Column(
//                     children: [
//                       Container(
//                         alignment: Alignment.topLeft,
//                         child: Text(
//                           "Most attracted places",
//                           style: GoogleFonts.montserrat(
//                             fontWeight: FontWeight.w500,
//                             color: Color(0xFF1EFEBB),
//                             fontSize: 25,
//                           ),
//                         ),
//                       ),
//                       const SizedBox(height: 10),
//                       // Swiper for attraction images
//                       SizedBox(
//                         height: 300, // Set the height for the swipe
//                         child: Swiper(
//                           itemCount: attractions.length,
//                           // layout: SwiperLayout.STACK,
//                           viewportFraction: 1,
//                           scale: 0.8,
//                           autoplay: true,
//                           autoplayDelay: 5000,
//                           // itemWidth: 350,
//                           itemBuilder: (context, index) {
//                             final attraction = attractions[index];

//                             return GestureDetector(
//                               onTap: () {
//                                 // Navigate to AttractionPage and pass the ID
//                                 Navigator.push(
//                                   context,
//                                   MaterialPageRoute(
//                                     builder: (context) => AttractionPage(
//                                         attrId: attraction['id']),
//                                   ),
//                                 );
//                               },
//                               child: Container(
//                                 height: 300,
//                                 width: 300,
//                                 decoration: BoxDecoration(
//                                   color: Colors.black.withOpacity(0.3),
//                                   borderRadius: BorderRadius.circular(25),
//                                   border: Border.all(
//                                     color:
//                                         const Color.fromARGB(255, 80, 80, 80),
//                                     style: BorderStyle.solid,
//                                   ),
//                                 ),
//                                 child: Column(
//                                   children: [
//                                     SizedBox(
//                                       height: 200,
//                                       width: double.infinity,
//                                       child: ClipRRect(
//                                         borderRadius: BorderRadius.only(
//                                             topLeft: Radius.circular(25),
//                                             topRight: Radius.circular(25)),
//                                         child: Image.network(
//                                           attraction['cover_img'] +
//                                               "?w=500&h=-1&s=1",

//                                           fit: BoxFit
//                                               .cover, // Adjust fit to cover the card
//                                           loadingBuilder:
//                                               (context, child, progress) {
//                                             return progress == null
//                                                 ? child
//                                                 : Center(
//                                                     child:
//                                                         CircularProgressIndicator());
//                                           },
//                                           errorBuilder:
//                                               (context, error, stackTrace) {
//                                             return Center(
//                                                 child: Icon(Icons.error));
//                                           },
//                                         ),
//                                       ),
//                                       // Overlay for attraction name at the bottom of the image
//                                       // Positioned(
//                                       //   bottom: 0,
//                                       //   left: 0,
//                                       //   right: 100,
//                                       //   child: Container(
//                                       //     padding: EdgeInsets.all(20),
//                                       //     decoration: BoxDecoration(
//                                       //         color: Colors.black.withOpacity(
//                                       //             0.5), // Semi-transparent background
//                                       //         borderRadius:
//                                       //             BorderRadius.circular(10)),
//                                       //     child: Text(
//                                       //       attraction['name'] ??
//                                       //           'Unknown Place', // Display attraction name
//                                       //       style: TextStyle(
//                                       //         color: Colors.white,
//                                       //         fontSize: 16,
//                                       //         fontWeight: FontWeight.bold,
//                                       //       ),
//                                       //       textAlign: TextAlign.center,
//                                       //     ),
//                                       //   ),
//                                       // ),
//                                       // Positioned(
//                                       //   bottom: 10,
//                                       //   left: 10,
//                                       // child: Container(
//                                       //   padding: const EdgeInsets.symmetric(
//                                       //       horizontal: 8, vertical: 8),
//                                       //   decoration: BoxDecoration(
//                                       //     color:
//                                       //         Colors.black.withOpacity(0.5),
//                                       //     borderRadius:
//                                       //         BorderRadius.circular(10),
//                                       //   ),
//                                       //   child: Row(
//                                       //     children: [
//                                       //       const Icon(Icons.location_pin,
//                                       //           color: Colors.white),
//                                       //       Text(
//                                       //         attraction['name'] ??
//                                       //             'Unknown Place',
//                                       //         style: GoogleFonts.poppins(
//                                       //           color: Colors.white,
//                                       //           fontSize: 14,
//                                       //           fontWeight: FontWeight.w600,
//                                       //         ),
//                                       //       ),
//                                       //     ],
//                                       //   ),
//                                       // ),
//                                       // ),
//                                     ),
//                                     SizedBox(
//                                       height: 20,
//                                     ),
//                                     Container(
//                                       padding: const EdgeInsets.symmetric(
//                                           horizontal: 8, vertical: 8),
//                                       decoration: BoxDecoration(
//                                         color: Colors.black.withOpacity(0.5),
//                                         borderRadius: BorderRadius.circular(10),
//                                       ),
//                                       child: Row(
//                                         children: [
//                                           const Icon(Icons.location_pin,
//                                               color: const Color(0xFF1EFEBB)),
//                                           SizedBox(
//                                             width: 10,
//                                           ),
//                                           Container(
//                                             width: 200,
//                                             child: Text(
//                                               attraction['name'] ??
//                                                   'Unknown Place',
//                                               overflow: TextOverflow.ellipsis,
//                                               maxLines: 2,
//                                               style: GoogleFonts.poppins(
//                                                 color: Colors.white,
//                                                 fontSize: 14,
//                                                 fontWeight: FontWeight.w600,
//                                               ),
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             );
//                           },
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:card_swiper/card_swiper.dart';
import 'package:readmore/readmore.dart';
import 'package:tourist_app/pages/AttractionPage.dart';

class Statedetailspage extends StatefulWidget {
  final int stateid; // State ID passed from the previous screen

  const Statedetailspage({required this.stateid, Key? key}) : super(key: key);

  @override
  State<Statedetailspage> createState() => _StatedetailspageState();
}

class _StatedetailspageState extends State<Statedetailspage> {
  var primaryColor = Color(0xFF1EFEBB);
  var secondaryColor = Color(0xFF02050A);
  var ternaryColor = Color(0xFF1B1E23);
  Map? stateResponse;

  Future<void> fetchStateData() async {
    try {
      final response = await http.get(Uri.parse(
          'https://traveller-app-api.onrender.com/states/${widget.stateid}'));

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
    fetchStateData(); // Fetch the state details when the page loads
  }

  @override
  Widget build(BuildContext context) {
    if (stateResponse == null) {
      return Scaffold(
        backgroundColor: Colors.grey[100],
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final stateInfo = stateResponse!['state_data'];
    final attractions = stateResponse!['attr_data'];

    return Scaffold(
      backgroundColor: Color.fromARGB(41, 93, 93, 91),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top State Image
                Stack(
                  children: [
                    Container(
                      height: 350,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(30),
                          bottomRight: Radius.circular(30),
                        ),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(30),
                          bottomRight: Radius.circular(30),
                        ),
                        child: Image.network(
                          stateInfo['state_image'] ?? '',
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: double.infinity,
                          errorBuilder: (context, error, stackTrace) {
                            return Center(
                              child: Icon(Icons.error, color: Colors.red),
                            );
                          },
                          loadingBuilder: (context, child, progress) {
                            return progress == null
                                ? child
                                : Center(child: CircularProgressIndicator());
                          },
                        ),
                      ),
                    ),
                    // State name overlay

                    // Back Button
                    Positioned(
                      top: 40,
                      left: 20,
                      child: CircleAvatar(
                        backgroundColor: secondaryColor,
                        child: IconButton(
                          icon: Icon(Icons.arrow_back, color: primaryColor),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                // State Information Section

                Container(
                  // margin: EdgeInsets.symmetric(horizontal: 20),
                  padding: EdgeInsets.all(20),
                  // decoration: BoxDecoration(
                  //   color: Colors.black.withOpacity(0.3),
                  //   borderRadius: BorderRadius.circular(25),
                  //   border: Border.all(
                  //     color: Colors.grey.shade700,
                  //   ),
                  // ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        child: Text(
                          stateInfo['state_name'] ?? 'Unknown State',
                          style: GoogleFonts.montserrat(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 28,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Icon(
                            Icons.location_on,
                            color: Color(0xFF1EFEBB),
                            size: 16,
                          ),
                          const SizedBox(width: 10),
                          Text(
                            stateInfo?["state_capital"] ?? 'No capital info',
                            style: TextStyle(
                              color: Colors.grey,
                              // fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "About",
                        style: GoogleFonts.montserrat(
                          fontWeight: FontWeight.w500,
                          color: Color.fromARGB(255, 255, 255, 255),
                          fontSize: 20,
                        ),
                      ),
                      const SizedBox(height: 10),
                      ReadMoreText(
                        stateInfo["state_info"] ?? 'No information available',
                        trimLines: 3,
                        trimMode: TrimMode.Line,
                        trimCollapsedText: 'Read more',
                        trimExpandedText: 'Read less',
                        style: TextStyle(color: Colors.grey),
                        moreStyle: TextStyle(
                            color: Color(0xFF1EFEBB),
                            fontWeight: FontWeight.bold),
                        lessStyle: TextStyle(
                            color: Color(0xFF1EFEBB),
                            fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Image.asset(
                            "assets/weather2.png",
                            height: 30,
                            width: 30,
                          ),
                          const SizedBox(width: 10),
                          Text(
                            "Weather data not available",
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                // Most Attracted Places Section
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Most Attracted Places",
                        style: GoogleFonts.montserrat(
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF1EFEBB),
                          fontSize: 22,
                        ),
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        height: 300, // Set the height for the swiper
                        child: Swiper(
                          itemCount: attractions.length,
                          viewportFraction: 0.9,
                          scale: 0.9,
                          autoplay: true,
                          itemBuilder: (context, index) {
                            final attraction = attractions[index];

                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => AttractionPage(
                                        attrId: attraction['id']),
                                  ),
                                );
                              },
                              child: Container(
                                margin: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.3),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: Colors.grey.shade700,
                                  ),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(20),
                                        topRight: Radius.circular(20),
                                      ),
                                      child: Image.network(
                                        attraction['cover_img'] +
                                            "?w=500&h=-1&s=1",
                                        height: 200,
                                        width: double.infinity,
                                        fit: BoxFit.cover,
                                        errorBuilder:
                                            (context, error, stackTrace) {
                                          return Center(
                                            child: Icon(Icons.error,
                                                color: Colors.red),
                                          );
                                        },
                                        loadingBuilder:
                                            (context, child, progress) {
                                          return progress == null
                                              ? child
                                              : Center(
                                                  child:
                                                      CircularProgressIndicator());
                                        },
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10),
                                      child: Text(
                                        attraction['name'] ?? 'Unknown Place',
                                        style: GoogleFonts.poppins(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10),
                                      child: Text(
                                        attraction['city_name'] ??
                                            'Unknown City',
                                        style: GoogleFonts.poppins(
                                          color: Colors.grey[400],
                                          fontSize: 14,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
