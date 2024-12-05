// group_list_page.dart
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:tourist_app/chat/CreateGroupPage.dart';
import 'package:tourist_app/chat/GropChatPage.dart';
import 'package:tourist_app/chat/group_model.dart';
import 'package:tourist_app/chat/group_service.dart';

class GroupListPage extends StatefulWidget {
  const GroupListPage({super.key});

  @override
  State<GroupListPage> createState() => _GroupListPageState();
}

const primaryColor = Color(0xFF1EFEBB);
const secondayColor = Color(0xFF02050A);
const ternaryColor = Color(0xFF1B1E23);

class _GroupListPageState extends State<GroupListPage> {
  int _selectedIndex = 2;

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
        Navigator.pushReplacementNamed(context, 'itinerary');
      } else if (_selectedIndex == 4) {
        Navigator.pushReplacementNamed(context, 'FeedPage');
      }
    });
  }

  String userId =
      FirebaseAuth.instance.currentUser!.uid; // Get current user's ID

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
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
                          icon: Icon(Icons.line_style_outlined),
                          label: 'AI Itinerary', // No label
                        ),
                        BottomNavigationBarItem(
                          icon: Icon(Icons.article_rounded),
                          label: 'Feed', // No label
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
        appBar: AppBar(
          backgroundColor: ternaryColor,
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.chat), text: "Joined Groups"),
              Tab(icon: Icon(Icons.group_add), text: "All Groups"),
            ],
            indicatorColor: primaryColor,
            labelColor: primaryColor,
          ),
        ),
        body: TabBarView(
          children: [
            // First Tab: Display groups the user has joined
            StreamBuilder<List<Group>>(
              stream: getGroups(), // Fetch all groups
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                List<Group> joinedGroups = snapshot.data!
                    .where((group) => group.participants.contains(userId))
                    .toList(); // Filter groups user joined
                if (joinedGroups.isEmpty) {
                  return const Center(
                      child: Text(
                    "You haven't joined any groups.",
                    style: TextStyle(color: Colors.white),
                  ));
                }

                return ListView.builder(
                  itemCount: joinedGroups.length,
                  itemBuilder: (context, index) {
                    Group group = joinedGroups[index];
                    return ListTile(
                      title: Text(
                        group.title,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                            fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        group.description,
                        style: TextStyle(color: Colors.white, fontSize: 15),
                      ),
                      onTap: () {
                        // Navigate to group chat page
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  GroupChatPage(groupId: group.id)),
                        );
                      },
                    );
                  },
                );
              },
            ),

            // Second Tab: Display all available groups with join button
            StreamBuilder<List<Group>>(
              stream: getGroups(), // Fetch all groups
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                List<Group> allGroups = snapshot.data!;
                return ListView.builder(
                  itemCount: allGroups.length,
                  itemBuilder: (context, index) {
                    Group group = allGroups[index];
                    bool isUserInGroup = group.participants.contains(userId);

                    return Card(
                      color: secondayColor,
                      elevation: 2,
                      margin: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 16),
                      child: ListTile(
                        title: Text(
                          group.title,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 17,
                              fontWeight: FontWeight.bold),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              group.description,
                              style:
                                  TextStyle(color: Colors.white, fontSize: 15),
                            ),
                            Text(
                              "Participants: ${group.participants.length}",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 14),
                            )
                          ],
                        ),
                        trailing: isUserInGroup
                            ? const Icon(Icons.check, color: Colors.green)
                            : ElevatedButton(
                                onPressed: () {
                                  joinGroup(group.id, userId); // Join group
                                },
                                child: const Text(
                                  "Join",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: primaryColor,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => CreateGroupPage()),
            );
          },
          child: const Icon(
            Icons.add,
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}
