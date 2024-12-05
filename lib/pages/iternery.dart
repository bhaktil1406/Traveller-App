import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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
      home: VacationInputScreen(),
    );
  }
}

class VacationInputScreen extends StatefulWidget {
  @override
  _VacationInputScreenState createState() => _VacationInputScreenState();
}

class _VacationInputScreenState extends State<VacationInputScreen> {
  final _destinationController = TextEditingController();
  final _daysController = TextEditingController();
  String _vacationType = "Relaxation";
  bool _isLoading = false;

  Future<void> navigateToItinerary() async {
    final destination = _destinationController.text;
    final days = int.tryParse(_daysController.text) ?? 0;

    if (destination.isNotEmpty && days > 0) {
      setState(() {
        _isLoading = true;
      });

      final response = await fetchItinerary(destination, days, _vacationType);

      setState(() {
        _isLoading = false;
      });

      if (response != null && response['data'] != null) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                ItineraryScreen(itineraryData: response['data']),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to fetch itinerary!')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter valid details!')),
      );
    }
  }

  Future<Map<String, dynamic>?> fetchItinerary(
      String destination, int days, String vacationType) async {
    final prompt =
        "Give an itinerary for ${destination} destination for ${days} days for ${vacationType} trip";

    final url = Uri.parse(
        'https://oriented-termite-leading.ngrok-free.app/itinerary');
    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'ngrok-skip-browser-warning': "0"
        },
        body: jsonEncode({"prompt": prompt}),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        print('Failed to load itinerary. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching itinerary: $e');
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: secondaryColor,
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 18, 17, 17),
        title:
            const Text("AI Itinerary", style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
        leading: InkWell(
            onTap: () {
              Navigator.pushNamed(context, "home");
            },
            child: Icon(
              Icons.arrow_back,
              color: Colors.white,
            )),
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: _destinationController,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: 'Destination',
                    labelStyle: TextStyle(color: Colors.white),
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 16),
                TextField(
                  controller: _daysController,
                  keyboardType: TextInputType.number,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: 'Number of Days',
                    labelStyle: TextStyle(color: Colors.white),
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: _vacationType,
                  items: [
                    'Relaxation',
                    'Adventure',
                    'Cultural',
                    'Romantic',
                    'Family',
                  ].map((type) {
                    return DropdownMenuItem(
                      value: type,
                      child: Text(type),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _vacationType = value!;
                    });
                  },
                  decoration: InputDecoration(
                    labelText: 'Type of Vacation',
                    labelStyle: TextStyle(color: Colors.white),
                    border: OutlineInputBorder(),
                  ),
                  dropdownColor: ternaryColor,
                  style: TextStyle(color: Colors.white),
                ),
                SizedBox(height: 24),
                Center(
                  child: ElevatedButton(
                    onPressed: navigateToItinerary,
                    child: Text('Create Itinerary'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (_isLoading)
            Container(
              color: Colors.black54,
              child: Center(
                child: CircularProgressIndicator(color: primaryColor),
              ),
            ),
        ],
      ),
    );
  }
}

class ItineraryScreen extends StatelessWidget {
  final List itineraryData;

  ItineraryScreen({required this.itineraryData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: secondaryColor,
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 18, 17, 17),
        title:
            const Text("Your Itinerary", style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: ListView.builder(
        itemCount: itineraryData.length,
        itemBuilder: (context, index) {
          final day = itineraryData[index];
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                day['day'],
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
                      day['description'],
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
    );
  }
}
