// import 'dart:convert';

// import 'package:card_swiper/card_swiper.dart';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:http/http.dart' as http;
// import 'package:readmore/readmore.dart';
// import 'package:weather/weather.dart';

// class AttractionPage extends StatefulWidget {
//   final int attrId;
//   const AttractionPage({required this.attrId, Key? key}) : super(key: key);

//   @override
//   _AttractionPageState createState() => _AttractionPageState();
// }

// class _AttractionPageState extends State<AttractionPage> {
//   var primaryColor = Color(0xFF1EFEBB);
//   var secondaryColor = Color(0xFF02050A);
//   var ternaryColor = Color(0xFF1B1E23);
//   var apiUri = "https://traveller-app-api.onrender.com/attractions/";
//   WeatherFactory? weatherFactory;
//   Map? dailyWeather;
//   Map? attrResponse;
//   bool isLoading = true;
//   bool isWeatherLoading = true;

//   @override
//   void initState() {
//     super.initState();
//     weatherFactory = WeatherFactory(
//         "238d3af64708bc689cf087deceecde00"); // Replace with your OpenWeatherMap API key
//     fetchAttraction();
//   }

//   Future<void> fetchAttraction() async {
//     try {
//       final response = await http.get(Uri.parse('$apiUri${widget.attrId}'));
//       if (response.statusCode == 200) {
//         setState(() {
//           attrResponse = json.decode(response.body)["data"];
//         }); // Default to London if city not provided
//       } else {
//         throw Exception("Failed to load attraction");
//       }
//     } catch (e) {
//       print(e);
//       setState(() {
//         isLoading = false;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Scaffold(
//         backgroundColor: secondaryColor,
//         body: attrResponse == null
//             ? Center(child: CircularProgressIndicator())
//             : SingleChildScrollView(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Stack(
//                       clipBehavior: Clip.none,
//                       children: [
//                         Container(
//                           height: 350,
//                           width: double.infinity,
//                           decoration: BoxDecoration(
//                             borderRadius: BorderRadius.only(
//                               bottomLeft: Radius.circular(30),
//                               bottomRight: Radius.circular(30),
//                             ),
//                           ),
//                           child: ClipRRect(
//                             borderRadius: BorderRadius.only(
//                               bottomLeft: Radius.circular(30),
//                               bottomRight: Radius.circular(30),
//                             ),
//                             child: Image.network(
//                               "${attrResponse!['cover_img']}?w=500&h=-1&s=1" ??
//                                   "",
//                               fit: BoxFit.cover,
//                               height: double.infinity,
//                               width: double.infinity,
//                             ),
//                           ),
//                         ),
//                         Positioned(
//                           top: 20,
//                           left: 20,
//                           child: Container(
//                             height: 50,
//                             width: 50,
//                             padding: EdgeInsets.all(1),
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(50),
//                               color: ternaryColor,
//                             ),
//                             child: IconButton(
//                               icon: Icon(Icons.arrow_back,
//                                   color: primaryColor, size: 25),
//                               onPressed: () {
//                                 Navigator.pop(context);
//                               },
//                             ),
//                           ),
//                         ),
//                         Positioned(
//                           top: 20,
//                           right: 20,
//                           child: Container(
//                             height: 50,
//                             width: 50,
//                             padding: EdgeInsets.all(1),
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(50),
//                               color: ternaryColor,
//                             ),
//                             child: IconButton(
//                               icon: Icon(Icons.favorite_border,
//                                   color: primaryColor, size: 25),
//                               onPressed: () {},
//                             ),
//                           ),
//                         ),
//                         Positioned(
//                           bottom: -30,
//                           right: 30,
//                           child: Container(
//                             height: 60,
//                             width: 60,
//                             padding: EdgeInsets.symmetric(
//                                 vertical: 9, horizontal: 15),
//                             decoration: BoxDecoration(
//                               color: primaryColor,
//                               borderRadius: BorderRadius.circular(50),
//                             ),
//                             child: Row(
//                               children: [
//                                 Text(
//                                   attrResponse!['ratings'] != null
//                                       ? "${attrResponse!['ratings']}"
//                                       : "No Rating",
//                                   style: TextStyle(
//                                     color: Colors.black,
//                                     fontWeight: FontWeight.bold,
//                                     fontSize: 22,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                     SizedBox(height: 25),
//                     Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 20),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Container(
//                                     width: 300,
//                                     child: Text(
//                                       attrResponse!['name'] ??
//                                           "Attraction Name",
//                                       maxLines: 2,
//                                       overflow: TextOverflow.ellipsis,
//                                       style: GoogleFonts.montserrat(
//                                         fontWeight: FontWeight.bold,
//                                         color: Colors.white,
//                                         fontSize: 28,
//                                       ),
//                                     ),
//                                   ),
//                                   Row(
//                                     children: [
//                                       Icon(Icons.location_on,
//                                           size: 16, color: primaryColor),
//                                       SizedBox(width: 10),
//                                       Container(
//                                         width: 250,
//                                         child: Text(
//                                           attrResponse!['address'] ??
//                                               "Location",
//                                           overflow: TextOverflow.ellipsis,
//                                           maxLines: 2,
//                                           style: TextStyle(color: Colors.grey),
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ],
//                               ),
//                             ],
//                           ),
//                           SizedBox(height: 16),
//                           SingleChildScrollView(
//                             scrollDirection: Axis.horizontal,
//                             child: Row(
//                               children: [
//                                 InfoButton(
//                                   icon: Icons.event,
//                                   label: attrResponse!['duration'] ?? "N/A",
//                                 ),
//                                 SizedBox(width: 20),
//                                 InfoButton(
//                                   icon: Icons.schedule,
//                                   label: attrResponse!['timings'] ?? "N/A",
//                                 ),
//                               ],
//                             ),
//                           ),
//                           SizedBox(height: 16),
//                           Text(
//                             "Description",
//                             style: GoogleFonts.montserrat(
//                               fontWeight: FontWeight.w500,
//                               color: Color.fromARGB(255, 255, 255, 255),
//                               fontSize: 20,
//                             ),
//                           ),
//                           SizedBox(height: 8),
//                           ReadMoreText(
//                             attrResponse!["about"],
//                             lessStyle: TextStyle(
//                                 fontWeight: FontWeight.w600,
//                                 color: Color(0xFF1EFEBB)),
//                             moreStyle: TextStyle(
//                                 fontWeight: FontWeight.w600,
//                                 color: Color(0xFF1EFEBB)),
//                             style: TextStyle(color: Colors.grey, fontSize: 15),
//                           ),
//                           SizedBox(height: 16),
//                           SizedBox(height: 16),
//                           Padding(
//                             padding: const EdgeInsets.only(left: 20),
//                             child: Text(
//                               "${attrResponse!["review_count"]} Reviews",
//                               style: GoogleFonts.montserrat(
//                                 fontWeight: FontWeight.w500,
//                                 color: Color.fromARGB(255, 255, 255, 255),
//                                 fontSize: 20,
//                               ),
//                             ),
//                           ),
//                           SizedBox(height: 8),
//                           Padding(
//                             padding: const EdgeInsets.symmetric(horizontal: 20),
//                             child: Container(
//                               height: 200,
//                               child: ListView.builder(
//                                 scrollDirection: Axis.horizontal,
//                                 itemCount: attrResponse!['reviews'].length,
//                                 itemBuilder: (context, index) {
//                                   final review =
//                                       attrResponse!['reviews'][index];
//                                   return Container(
//                                     width: 300,
//                                     margin: EdgeInsets.only(right: 10),
//                                     padding: EdgeInsets.all(12),
//                                     decoration: BoxDecoration(
//                                       color: ternaryColor,
//                                       borderRadius: BorderRadius.circular(15),
//                                     ),
//                                     child: Column(
//                                       crossAxisAlignment:
//                                           CrossAxisAlignment.start,
//                                       children: [
//                                         Row(
//                                           mainAxisAlignment:
//                                               MainAxisAlignment.spaceBetween,
//                                           children: [
//                                             Text(
//                                               review['user'],
//                                               style: TextStyle(
//                                                   color: primaryColor,
//                                                   fontWeight: FontWeight.bold),
//                                             ),
//                                             Row(
//                                               children: [
//                                                 Icon(Icons.star,
//                                                     size: 16,
//                                                     color: primaryColor),
//                                                 SizedBox(width: 4),
//                                                 Text(
//                                                   review['rating'].toString(),
//                                                   style: TextStyle(
//                                                       color: Colors.white,
//                                                       fontWeight:
//                                                           FontWeight.bold),
//                                                 ),
//                                               ],
//                                             ),
//                                           ],
//                                         ),
//                                         SizedBox(height: 8),
//                                         Text(
//                                           review['title'],
//                                           style: TextStyle(
//                                               color: Colors.white,
//                                               fontWeight: FontWeight.w600),
//                                         ),
//                                         SizedBox(height: 15),
//                                         Text(
//                                           review['text'],
//                                           maxLines: 3,
//                                           overflow: TextOverflow.ellipsis,
//                                           style: TextStyle(color: Colors.grey),
//                                         ),
//                                       ],
//                                     ),
//                                   );
//                                 },
//                               ),
//                             ),
//                           ),
//                           SizedBox(height: 16),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//       ),
//     );
//   }
// }

// class InfoButton extends StatelessWidget {
//   final IconData icon;
//   final String label;
//   var primaryColor = Color(0xFF1EFEBB);
//   var secondaryColor = Color(0xFF02050A);
//   var ternaryColor = Color(0xFF1B1E23);

//   InfoButton({required this.icon, required this.label});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
//       decoration: BoxDecoration(
//         color: Color.fromARGB(255, 32, 32, 32),
//         borderRadius: BorderRadius.circular(10),
//       ),
//       child: Row(
//         children: [
//           Icon(icon, size: 20, color: primaryColor),
//           SizedBox(width: 10),
//           Text(
//             label,
//             style: TextStyle(
//               fontSize: 12,
//               color: Colors.white,
//               fontWeight: FontWeight.bold,
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
import 'package:readmore/readmore.dart';
import 'package:tourist_app/pages/auth.dart';
import 'package:weather/weather.dart';

class AttractionPage extends StatefulWidget {
  final int attrId;
  const AttractionPage({required this.attrId, Key? key}) : super(key: key);

  @override
  _AttractionPageState createState() => _AttractionPageState();
}

class _AttractionPageState extends State<AttractionPage> {
  var primaryColor = const Color(0xFF1EFEBB);
  var secondaryColor = const Color(0xFF02050A);
  var ternaryColor = const Color(0xFF1B1E23);
  var apiUri = "https://traveller-app-api.onrender.com/attractions/";
  WeatherFactory? weatherFactory;
  Map? dailyWeather;
  Map? attrResponse;
  bool isLoading = true;
  bool isWeatherLoading = true;

  @override
  void initState() {
    super.initState();
    fetchAttraction();
  }

  Future<void> fetchAttraction() async {
    try {
      final response = await http.get(Uri.parse('$apiUri${widget.attrId}'));
      if (response.statusCode == 200) {
        setState(() {
          attrResponse = json.decode(response.body)["data"];
        }); // Default to London if city not provided
      } else {
        throw Exception("Failed to load attraction");
      }
    } catch (e) {
      print(e);
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: secondaryColor,
        body: attrResponse == null
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Container(
                          height: 350,
                          width: double.infinity,
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(30),
                              bottomRight: Radius.circular(30),
                            ),
                          ),
                          child: ClipRRect(
                            borderRadius: const BorderRadius.only(
                              bottomLeft: Radius.circular(30),
                              bottomRight: Radius.circular(30),
                            ),
                            child: Image.network(
                              "${attrResponse!['cover_img']}?w=500&h=-1&s=1",
                              fit: BoxFit.cover,
                              height: double.infinity,
                              width: double.infinity,
                            ),
                          ),
                        ),
                        Positioned(
                          top: 20,
                          left: 20,
                          child: Container(
                            height: 50,
                            width: 50,
                            padding: const EdgeInsets.all(1),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              color: ternaryColor,
                            ),
                            child: IconButton(
                              icon: Icon(Icons.arrow_back,
                                  color: primaryColor, size: 25),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                          ),
                        ),
                        Positioned(
                          top: 20,
                          right: 20,
                          child: Container(
                            height: 50,
                            width: 50,
                            padding: const EdgeInsets.all(1),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              color: ternaryColor,
                            ),
                            child: IconButton(
                              icon: Icon(Icons.favorite_border,
                                  color: primaryColor, size: 25),
                              onPressed: () {},
                            ),
                          ),
                        ),
                        Positioned(
                          top: 317,
                          right: 30,
                          child: Container(
                            height: 65,
                            width: 65,
                            padding: const EdgeInsets.all(17),
                            decoration: BoxDecoration(
                              color: primaryColor,
                              borderRadius: BorderRadius.circular(50),
                            ),
                            child: Row(
                              children: [
                                Text(
                                  "${attrResponse!['ratings']}",
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 21,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width: 300,
                                    child: Text(
                                      attrResponse!['name'] ??
                                          "Attraction Name",
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: GoogleFonts.montserrat(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                        fontSize: 28,
                                      ),
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Icon(Icons.location_on,
                                          size: 16, color: primaryColor),
                                      const SizedBox(height: 40, width: 5),
                                      SizedBox(
                                        width: 250,
                                        child: Text(
                                          attrResponse!['address'] ??
                                              "No address",
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 2,
                                          style: const TextStyle(
                                              color: Colors.grey),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: [
                                InfoButton(
                                  icon: Icons.event,
                                  label: attrResponse!['duration'] ?? "N/A",
                                ),
                                const SizedBox(width: 20),
                                InfoButton(
                                  icon: Icons.schedule,
                                  label: attrResponse!['timings'] ?? "N/A",
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),
                          Text(
                            "Description",
                            style: GoogleFonts.montserrat(
                              fontWeight: FontWeight.w500,
                              color: const Color.fromARGB(255, 255, 255, 255),
                              fontSize: 20,
                            ),
                          ),
                          const SizedBox(height: 8),
                          ReadMoreText(
                            attrResponse!["about"],
                            lessStyle: const TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF1EFEBB)),
                            moreStyle: const TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF1EFEBB)),
                            style: const TextStyle(
                                color: Colors.grey, fontSize: 15),
                          ),
                          const SizedBox(height: 32),
                          Padding(
                            padding: const EdgeInsets.only(left: 0),
                            child: Text(
                              "${attrResponse!["review_count"]} Reviews",
                              style: GoogleFonts.montserrat(
                                fontWeight: FontWeight.w500,
                                color: const Color.fromARGB(255, 255, 255, 255),
                                fontSize: 20,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 0),
                            child: SizedBox(
                              height: 200,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: attrResponse!['reviews'].length,
                                itemBuilder: (context, index) {
                                  final review =
                                      attrResponse!['reviews'][index];
                                  return Container(
                                    width: 300,
                                    margin: const EdgeInsets.only(right: 10),
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: ternaryColor,
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              review['user'],
                                              style: TextStyle(
                                                  color: primaryColor,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Row(
                                              children: [
                                                Icon(Icons.star,
                                                    size: 16,
                                                    color: primaryColor),
                                                const SizedBox(width: 4),
                                                Text(
                                                  review['rating'].toString(),
                                                  style: const TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          review['title'],
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w600),
                                        ),
                                        const SizedBox(height: 15),
                                        Text(
                                          review['text'],
                                          maxLines: 3,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                              color: Colors.grey),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
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

class InfoButton extends StatelessWidget {
  final IconData icon;
  final String label;
  var primaryColor = const Color(0xFF1EFEBB);
  var secondaryColor = const Color(0xFF02050A);
  var ternaryColor = const Color(0xFF1B1E23);

  InfoButton({super.key, required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 32, 32, 32),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Icon(icon, size: 20, color: primaryColor),
          const SizedBox(width: 10),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
