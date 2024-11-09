import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';
import 'package:readmore/readmore.dart';
import 'package:tourist_app/utils/liked.dart';
// import 'package:intl/intl.dart';
// import 'package:intl/date_symbol_data_local.dart';

class AttractionPage extends StatefulWidget {
  final int attrId;
  const AttractionPage({required this.attrId, super.key});

  @override
  _AttractionPageState createState() => _AttractionPageState();
}

var primaryColor = const Color(0xFF1EFEBB);
var secondaryColor = const Color(0xFF02050A);
var ternaryColor = const Color(0xFF1B1E23);

class _AttractionPageState extends State<AttractionPage> {
  var apiUri = "https://traveller-app-api.onrender.com/attractions/";
  Map? attrResponse;
  bool isLoading = true;
  List weatherData = [];
  bool toggle = false; // Initial value for liked status

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
          isLoading = false;
          fetchWeatherData(attrResponse!["lat"], attrResponse!["long"]);
        });

        checkLikedAsync(attrResponse!["id"]);
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

  void checkLikedAsync(int attrId) async {
    bool liked = await checkLiked(attrId); // Await the liked check
    setState(() {
      toggle = liked; // Update the liked status
    });
  }

  Future<void> fetchWeatherData(double lat, double long) async {
    final url =
        'https://api.open-meteo.com/v1/forecast?latitude=$lat&longitude=$long&past_days=2&forecast_days=3&daily=temperature_2m_max,temperature_2m_min&timezone=auto';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        weatherData = List.generate(5, (index) {
          DateTime date = DateTime.parse(data['daily']['time'][index]);
          return {
            'date': date,
            'max': data['daily']['temperature_2m_max'][index],
            'min': data['daily']['temperature_2m_min'][index],
          };
        });
      });
    } else {
      throw Exception('Failed to load weather data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: secondaryColor,
        body: isLoading
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
                              icon: toggle
                                  ? Icon(Icons.favorite,
                                      color: primaryColor, size: 25)
                                  : Icon(Icons.favorite_border,
                                      color: primaryColor, size: 25),
                              onPressed: () {
                                updateLiked(attrResponse!["id"]);
                                setState(() {
                                  toggle = !toggle;
                                });
                              },
                            ),
                          ),
                        ),
                        Positioned(
                          top: 317,
                          right: 30,
                          child: Container(
                            padding: const EdgeInsets.all(15),
                            decoration: BoxDecoration(
                              color: primaryColor,
                              borderRadius: BorderRadius.circular(100),
                            ),
                            child: Center(
                              child: Row(
                                children: [
                                  Text(
                                    "${attrResponse!['ratings']}",
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 23,
                                    ),
                                  ),
                                ],
                              ),
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
                                      style: const TextStyle(
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
                          const Text(
                            "Description",
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: Color.fromARGB(255, 255, 255, 255),
                              fontSize: 20,
                            ),
                          ),
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
                          const SizedBox(height: 20),
                          const Text(
                            "Location",
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                              fontSize: 20,
                            ),
                          ),
                          const SizedBox(height: 10),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: SizedBox(
                              height: 200,
                              child: FlutterMap(
                                options: MapOptions(
                                  initialCenter: LatLng(attrResponse!['lat'],
                                      attrResponse!['long']),
                                  initialZoom: 13.0,
                                  interactionOptions: const InteractionOptions(
                                        flags: InteractiveFlag.pinchZoom | InteractiveFlag.drag),
                                  backgroundColor: Colors.black,
                                ),
                                children: [
                                  ColorFiltered(
                                    colorFilter: const ColorFilter.matrix(<double>[
                                      -0.2126, -0.7152, -0.0722, 0, 255, // Red channel
                                      -0.2126, -0.7152, -0.0722, 0, 255, // Green channel
                                      -0.2126, -0.7152, -0.0722, 0, 255, // Blue channel
                                      0,       0,       0,       1, 0,   // Alpha channel
                                    ]),
                                    child: TileLayer(
                                      urlTemplate:
                                          'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                                      subdomains: const ['a', 'b', 'c'],
                                      userAgentPackageName: 'com.example.app',
                                    ),
                                  ),
                                  MarkerLayer(
                                    markers: [
                                      Marker(
                                        point: LatLng(attrResponse!['lat'],
                                            attrResponse!['long']),
                                        width: 80,
                                        height: 80,
                                        child: const Icon(
                                          Icons.location_on,
                                          color: Color(0xFF1EFEBB),
                                          size: 40.0,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          const Text(
                            "Weather",
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                              fontSize: 20,
                            ),
                          ),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children:
                                  List.generate(weatherData.length, (index) {
                                return WeatherSection(
                                  date: weatherData[index]['date'],
                                  maxTemp: weatherData[index]['max'],
                                  minTemp: weatherData[index]['min'],
                                );
                              }),
                            ),
                          ),
                          const SizedBox(height: 20),
                          Text(
                            "${attrResponse!["review_count"]} Reviews",
                            style: const TextStyle(
                              fontWeight: FontWeight.w500,
                              color: Color.fromARGB(255, 255, 255, 255),
                              fontSize: 20,
                            ),
                          ),
                          const SizedBox(height: 8),
                          SizedBox(
                            height: 200,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: attrResponse!['reviews'].length,
                              itemBuilder: (context, index) {
                                final review = attrResponse!['reviews'][index];
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
                                        style:
                                            const TextStyle(color: Colors.grey),
                                      ),
                                    ],
                                  ),
                                );
                              },
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
  final primaryColor = const Color(0xFF1EFEBB);
  final secondaryColor = const Color(0xFF02050A);
  final ternaryColor = const Color(0xFF1B1E23);

  const InfoButton({super.key, required this.icon, required this.label});

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

class WeatherSection extends StatelessWidget {
  final DateTime date;
  final double maxTemp;
  final double minTemp;

  const WeatherSection(
      {super.key, required this.date, required this.maxTemp, required this.minTemp});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8.0),
      padding: const EdgeInsets.all(16.0),
      width: 150,
      decoration: BoxDecoration(
        color: const Color(0xFF1B1E23),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("${date.day}.${date.month}.${date.year}",
              style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white)),
          const SizedBox(height: 10),
          Text('Max: ${maxTemp.toStringAsFixed(1)}°C',
              style: const TextStyle(fontSize: 16, color: Colors.grey)),
          Text('Min: ${minTemp.toStringAsFixed(1)}°C',
              style: const TextStyle(fontSize: 16, color: Colors.grey)),
        ],
      ),
    );
  }
}
