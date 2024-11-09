import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:card_swiper/card_swiper.dart';
import 'package:readmore/readmore.dart';
import 'package:tourist_app/pages/AttractionPage.dart';

class Statedetailspage extends StatefulWidget {
  final int stateid; // State ID passed from the previous screen

  const Statedetailspage({required this.stateid, super.key});

  @override
  State<Statedetailspage> createState() => _StatedetailspageState();
}

class _StatedetailspageState extends State<Statedetailspage> {
  var primaryColor = const Color(0xFF1EFEBB);
  var secondaryColor = const Color(0xFF02050A);
  var ternaryColor = const Color(0xFF1B1E23);
  Map? stateResponse;
  Map? weatherData; // To store the weather data

  // Fetch State Data
  Future<void> fetchStateData() async {
    try {
      final response = await http.get(Uri.parse(
          'https://traveller-app-api.onrender.com/states/${widget.stateid}'));

      if (response.statusCode == 200) {
        setState(() {
          stateResponse = json.decode(response.body)['data'];
        });
        // After fetching state data, fetch weather
        fetchWeatherData(); // Fetch weather data after state data
      } else {
        throw Exception('Failed to load state data');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  // Fetch Weather Data from OpenWeatherMap API
  Future<void> fetchWeatherData() async {
    const String apiKey =
        '723db24d756715af21e93dce724f6394'; // Replace with your API key
    final String city = stateResponse!['state_data']['state_capital'];

    try {
      final response = await http.get(Uri.parse(
          'https://api.openweathermap.org/data/2.5/weather?q=$city&appid=$apiKey&units=metric'));
      print('Weather API response: ${response.body}'); // Add this line

      if (response.statusCode == 200) {
        setState(() {
          weatherData = json.decode(response.body);
        });
      } else {
        throw Exception('Failed to load weather data');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchStateData();
    fetchWeatherData();
  }

  @override
  Widget build(BuildContext context) {
    if (stateResponse == null) {
      return Scaffold(
        backgroundColor: Colors.grey[100],
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    final stateInfo = stateResponse!['state_data'];
    final attractions = stateResponse!['attr_data'];

    return Scaffold(
      backgroundColor: const Color.fromARGB(41, 93, 93, 91),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // State Image
                Stack(
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
                          stateInfo['state_image'] + "?w=500&h=-1&s=1" ?? '',
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: double.infinity,
                          errorBuilder: (context, error, stackTrace) {
                            return const Center(
                              child: Icon(Icons.error, color: Colors.red),
                            );
                          },
                          loadingBuilder: (context, child, progress) {
                            return progress == null
                                ? child
                                : const Center(
                                    child: CircularProgressIndicator());
                          },
                        ),
                      ),
                    ),
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
                const SizedBox(height: 5),
                // State Information
                Container(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        stateInfo['state_name'] ?? 'Unknown State',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 28,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Row(
                        children: [
                          const Icon(Icons.location_on,
                              color: Color(0xFF1EFEBB), size: 16),
                          const SizedBox(width: 10),
                          Text(
                            stateInfo?["state_capital"] ?? 'No capital info',
                            style: const TextStyle(
                              color: Colors.grey,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        "About",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
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
                        style: const TextStyle(color: Colors.grey),
                        moreStyle: const TextStyle(
                            color: Color(0xFF1EFEBB),
                            fontWeight: FontWeight.bold),
                        lessStyle: const TextStyle(
                            color: Color(0xFF1EFEBB),
                            fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 20),
                      // Display weather information

                      // Image.asset(
                      //   "assets/weather2.png",
                      //   height: 30,
                      //   width: 30,
                      // ),
                      // const SizedBox(width: 10),
                      // weatherData == null
                      //     ? Text(
                      //         "Weather data not available",
                      //         style: TextStyle(color: Colors.white),
                      //       )
                      //     : Text(
                      //         "${weatherData!['main']['temp']}°C, ${weatherData!['weather'][0]['description']}",
                      //         style: TextStyle(color: Colors.white),
                      //       ),
                      Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                        elevation: 5,
                        color: Colors
                            .black, // You can choose a different color based on your theme
                        margin: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 10),
                        child: Padding(
                          padding: const EdgeInsets.all(18),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // Weather Icon (replace asset with API icon if needed)
                              weatherData == null
                                  ? Image.asset(
                                      "assets/weather2.png",
                                      height: 50,
                                      width: 50,
                                    )
                                  : Image.network(
                                      "http://openweathermap.org/img/wn/${weatherData!['weather'][0]['icon']}@2x.png",
                                      height: 50,
                                      width: 50,
                                      fit: BoxFit.cover,
                                      color: primaryColor,
                                    ),

                              // Space between icon and text
                              const SizedBox(width: 20),

                              // Weather Details
                              weatherData == null
                                  ? const Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Fetching Weather data...",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 18),
                                          ),
                                        ],
                                      ),
                                    )
                                  : Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          // Temperature
                                          Text(
                                            "${weatherData!['main']['temp']}°C",
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Color.fromARGB(
                                                  255, 255, 255, 255),
                                              fontSize: 24,
                                            ),
                                          ),
                                          const SizedBox(height: 8),

                                          // Weather Description
                                          Text(
                                            "${weatherData!['weather'][0]['description']}",
                                            style: const TextStyle(
                                              fontWeight: FontWeight.w300,
                                              color: Color.fromARGB(
                                                  255, 152, 152, 152),
                                              fontSize: 16,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),

                              // Optional: Add location or other details
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                // Most Attracted Places
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Attractions",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 22,
                        ),
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        height: 320, // Set the height for the swiper
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
                                margin: const EdgeInsets.symmetric(
                                    vertical: 20, horizontal: 0),
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
                                      borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(20),
                                        topRight: Radius.circular(20),
                                      ),
                                      child: Image.network(
                                        attraction['cover_img'] +
                                            "?w=500&h=-1&s=1",
                                        height: 180,
                                        width: double.infinity,
                                        fit: BoxFit.cover,
                                        errorBuilder:
                                            (context, error, stackTrace) {
                                          return const Center(
                                            child: Icon(Icons.error,
                                                color: Colors.red),
                                          );
                                        },
                                        loadingBuilder:
                                            (context, child, progress) {
                                          return progress == null
                                              ? child
                                              : const Center(
                                                  child:
                                                      CircularProgressIndicator());
                                        },
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 5, horizontal: 20),
                                      child: Text(
                                        attraction['name'] ?? 'Unknown Place',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 23,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 5, horizontal: 20),
                                      child: Text(
                                        attraction['city_name'] ??
                                            'Unknown City',
                                        style: TextStyle(
                                          color: Colors.grey[400],
                                          fontSize: 17,
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
