import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

var primaryColor = const Color(0xFF1EFEBB);
var secondaryColor = const Color(0xFF02050A);
var ternaryColor = const Color(0xFF1B1E23);

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ItineraryScreen(destination: 'Manali', totalDays: 5),
    );
  }
}

class ItineraryScreen extends StatelessWidget {
  final String destination;
  final int totalDays;

  ItineraryScreen({required this.destination, required this.totalDays});

  List<Map<String, String>> generateItinerary() {
    // Sample itinerary details, replace this with actual details for each destination
    List<Map<String, String>> itinerary = [];
    for (int i = 1; i <= totalDays; i++) {
      itinerary.add({
        'day': 'Day $i',
        'description': 'Activity details for day $i in $destination',
      });
    }
    return itinerary;
  }

  @override
  Widget build(BuildContext context) {
    final itineraryList = generateItinerary();

    return Scaffold(
      backgroundColor: secondaryColor,
      appBar: AppBar(
        title: Text(
          '$destination Itinerary Plan',
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: itineraryList.length,
          itemBuilder: (context, index) {
            final day = itineraryList[index];
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  day['day']!,
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                SizedBox(height: 4),
                Row(
                  children: [
                    Container(
                      width: 2,
                      height: 60,
                      color: Colors.white,
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        day['description']!,
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
              ],
            );
          },
        ),
      ),
    );
  }
}
