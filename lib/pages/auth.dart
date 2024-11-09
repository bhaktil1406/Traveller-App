import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class auth {
  Future<String?> getCurrentUserId() async {
    User? user = FirebaseAuth.instance.currentUser;
    return user?.uid;
  }

  void SaveRegisterData(
      String uid, String email, String pass, BuildContext context) async {
    try {
      String? userId = await getCurrentUserId();
      if (userId != null) {
        Map<String, dynamic> data = {
          'uid': uid,
          'email': email,
          'pass': pass,
        };
        await FirebaseFirestore.instance.collection('user').doc(uid).set(data);
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("Data added")));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to add data: $e")),
      );
    }
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Function to fetch user data (name, email, etc.)
  Future<Map<String, String>> getUserData() async {
    User? user = _auth.currentUser;

    if (user != null) {
      String uid = user.uid;

      try {
        DocumentSnapshot userDoc =
            await _firestore.collection('user').doc(uid).get();

        String name = userDoc['name'];
        String email = user.email ?? 'No email';

        // Return user data as a map
        return {'name': name, 'email': email};
      } catch (e) {
        print("Error fetching user data: $e");
        return {'name': 'Unknown', 'email': 'Unknown'};
      }
    } else {
      // Return a default map when the user is not authenticated
      return {'name': 'Guest', 'email': 'No email'};
    }
  }

  // Function to like/unlike an attraction
  Future<void> toggleLikeAttraction(int attrId) async {
    User? user = _auth.currentUser;
    if (user != null) {
      String uid = user.uid;

      DocumentReference userDoc = _firestore.collection('user').doc(uid);

      // Get current liked attractions
      DocumentSnapshot userSnapshot = await userDoc.get();
      List<dynamic> likedAttractions = userSnapshot.get('likes') ?? [];

      // Toggle the like status
      if (likedAttractions.contains(attrId)) {
        // If the attraction is already liked, remove it
        likedAttractions.remove(attrId);
      } else {
        // Otherwise, add the attraction to the liked list
        likedAttractions.add(attrId);
      }

      // Update Firestore with the new likes array
      await userDoc.update({'likes': likedAttractions});
    }
  }

  // Function to fetch the liked attractions array
  Future<List<dynamic>> getLikedAttractions() async {
    User? user = _auth.currentUser;
    if (user != null) {
      String uid = user.uid;

      DocumentSnapshot userSnapshot =
          await _firestore.collection('users').doc(uid).get();
      return userSnapshot.get('likes') ?? [];
    }
    return [];
  }
}
