import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:tourist_app/pages/AttractionPage.dart';

class CategoryPage extends StatefulWidget {
  final int categoryId;
  final String label;
  const CategoryPage(
      {required this.label, required this.categoryId, super.key});

  @override
  _CategoryPageState createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  bool isLoading = true;
  var apiUri = "https://traveller-app-api.onrender.com";
  List<dynamic> attrList = [];

  @override
  void initState() {
    super.initState();
    fetchCategoryAttractions();
  }

  Future fetchCategoryAttractions() async {
    try {
      http.Response response = await http.get(Uri.parse(
          "$apiUri/category/${widget.categoryId}")); // Use categoryId dynamically
      if (response.statusCode == 200) {
        setState(() {
          attrList =
              json.decode(response.body)['data'] ?? []; // Handle null case
          isLoading = false;
        });
      } else {
        // Handle the error case where statusCode is not 200
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      // Handle any exceptions during the HTTP request
      setState(() {
        isLoading = false;
      });
      print('Error fetching attractions: $e');
    }
  }

  // Function to fetch detailed information about attractions using the liked IDs

  // Function to build individual cards using the provided builder
  Widget _buildAttrCard(
      int id, String name, String imagePath, String city, String state) {
    return Container(
      height: 310,
      width: double.infinity, // Make sure the width fills the container
      margin: const EdgeInsets.symmetric(
          vertical: 10), // Add vertical spacing between cards
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
            onTap: () async {
              // Navigate to the AttractionPage
              await Navigator.push(
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
                color: Color.fromARGB(255, 95, 95, 95),
                fontSize: 17,
              ),
              overflow: TextOverflow.fade,
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 18, 17, 17),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 18, 17, 17),
        title: Text(widget.label, style: const TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator()) // Show loading spinner
          : attrList.isEmpty
              ? const Center(
                  child: Text(
                    'No attractions found.',
                    style: TextStyle(color: Colors.white),
                  ),
                ) // Show if no attractions are found
              : ListView.builder(
                  itemCount: attrList.length,
                  padding: const EdgeInsets.all(10),
                  itemBuilder: (context, index) {
                    var attraction = attrList[index];
                    return _buildAttrCard(
                      attraction["id"], // Assuming each attraction has an id
                      attraction["name"], // Assuming each attraction has a name
                      attraction[
                          "cover_img"], // Assuming each attraction has an image path
                      attraction["city_name"],
                      attraction[
                          "state_name"], // Assuming each attraction has a state
                    );
                  },
                ),
    );
  }
}
