import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PostDetailsPage extends StatelessWidget {
  final String postId;

  PostDetailsPage({required this.postId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Post Details')),
      backgroundColor: Colors.black,
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance.collection('feed').doc(postId).get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error loading post'));
          }
          if (!snapshot.hasData || !snapshot.data!.exists) {
            return Center(child: Text('Post not found'));
          }

          var post = snapshot.data!;
          var postData = post.data() as Map<String, dynamic>?; // Convert to Map
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  postData?['title'] ?? 'Untitled Post',
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                SizedBox(height: 10),
                postData != null &&
                        postData.containsKey('imageUrl') &&
                        postData['imageUrl'] != null
                    ? Image.network(postData['imageUrl'])
                    : Icon(Icons.image_not_supported,
                        size: 150, color: Colors.grey),
                SizedBox(height: 20),
                Text(
                  postData?['description'] ?? 'No Description Available',
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
