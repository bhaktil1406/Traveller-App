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

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:card_swiper/card_swiper.dart';
import 'package:readmore/readmore.dart';

class Statedetailspage extends StatefulWidget {
  final int stateid; // State ID passed from the previous screen

  const Statedetailspage({required this.stateid, Key? key}) : super(key: key);

  @override
  State<Statedetailspage> createState() => _StatedetailspageState();
}

class _StatedetailspageState extends State<Statedetailspage> {
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
    bool isExpanded = false;
    if (stateResponse == null) {
      return Scaffold(
        backgroundColor: Color.fromARGB(41, 93, 93, 91),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final stateInfo = stateResponse!['state_data'];
    final attractions = stateResponse!['attr_data'];

    return Scaffold(
      appBar: AppBar(
         backgroundColor: Color.fromARGB(41, 93, 93, 91),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      backgroundColor:
          Color.fromARGB(41, 93, 93, 91), // Example background color
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.all(10),
                // height: 300,
                padding: EdgeInsets.only(top: 30, right: 20, left: 20),
                decoration: BoxDecoration(
                  // color: Color.fromARGB(
                  //     30, 255, 255, 255), // Make container transparent
                  borderRadius: BorderRadius.circular(15), // Rounded corners
                  border: Border.all(
                      color: const Color.fromARGB(255, 0, 0, 0),
                      width: 1), // Border
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      stateInfo['state_name'] ?? 'Unknown State',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    ReadMoreText(
                      stateInfo["state_info"],
                      lessStyle: TextStyle(
                          fontWeight: FontWeight.w600, color: Colors.red),
                      moreStyle: TextStyle(
                          fontWeight: FontWeight.w600, color: Colors.red),
                      style: TextStyle(color: Colors.white, fontSize: 15),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        Text(
                          "State capital",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 17,
                              fontWeight: FontWeight.w600),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Text(
                          stateInfo?["state_capital"] ??
                              'No information available',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          child: Image.asset(
                            "assets/weather2.png",
                            height: 30,
                            width: 30,
                          ),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Text(
                          "Weather is not Display",
                          style: TextStyle(color: Colors.white),
                        )
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.all(10),
                padding: EdgeInsets.only(top: 30, right: 0, left: 30),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15), // Rounded corners
                  border: Border.all(
                      color: const Color.fromARGB(255, 0, 0, 0),
                      width: 1), // Border
                ),
                child: Column(
                  children: [
                    Container(
                      alignment: Alignment.topLeft,
                      child: Text(
                        "Most attracted places",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 25,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                    const SizedBox(height: 10),
                    // Swiper for attraction images
                    SizedBox(
                      height: 400, // Set the height for the swipe
                      child: Swiper(
                        itemCount: attractions.length,
                        // layout: SwiperLayout.STACK,
                        viewportFraction: 0.9,
                        scale: 0.9,
                        autoplay: true,
                        autoplayDelay: 5000,
                        // itemWidth: 350,
                        itemBuilder: (context, index) {
                          final attraction = attractions[index];

                          return GestureDetector(
                            onTap: () {
                              // Print the attraction ID when the image is clicked
                              print('Attraction ID: ${attraction['id']}');
                            },
                            child: Card(
                              child: SizedBox(
                                height:
                                    300, // Adjust height to fit the image and the text
                                width: 300,
                                child: Stack(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Image.network(
                                        attraction['cover_img'],
                                        height:
                                            400, // Match image height with the container
                                        width: 300,
                                        fit: BoxFit
                                            .cover, // Adjust fit to cover the card
                                        loadingBuilder:
                                            (context, child, progress) {
                                          return progress == null
                                              ? child
                                              : Center(
                                                  child:
                                                      CircularProgressIndicator());
                                        },
                                        errorBuilder:
                                            (context, error, stackTrace) {
                                          return Center(
                                              child: Icon(Icons.error));
                                        },
                                      ),
                                    ),
                                    // Overlay for attraction name at the bottom of the image
                                    // Positioned(
                                    //   bottom: 0,
                                    //   left: 0,
                                    //   right: 100,
                                    //   child: Container(
                                    //     padding: EdgeInsets.all(20),
                                    //     decoration: BoxDecoration(
                                    //         color: Colors.black.withOpacity(
                                    //             0.5), // Semi-transparent background
                                    //         borderRadius:
                                    //             BorderRadius.circular(10)),
                                    //     child: Text(
                                    //       attraction['name'] ??
                                    //           'Unknown Place', // Display attraction name
                                    //       style: TextStyle(
                                    //         color: Colors.white,
                                    //         fontSize: 16,
                                    //         fontWeight: FontWeight.bold,
                                    //       ),
                                    //       textAlign: TextAlign.center,
                                    //     ),
                                    //   ),
                                    // ),
                                    Positioned(
                                      bottom: 10,
                                      left: 10,
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8, vertical: 8),
                                        decoration: BoxDecoration(
                                          color: Colors.black.withOpacity(0.5),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: Row(
                                          children: [
                                            const Icon(Icons.location_pin,
                                                color: Colors.white),
                                            Text(
                                              attraction['name'] ??
                                                  'Unknown Place',
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
      ),
    );
  }
}
