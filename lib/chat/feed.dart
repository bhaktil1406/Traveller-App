import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

var primaryColor = const Color(0xFF1EFEBB);
var secondaryColor = const Color(0xFF02050A);
var ternaryColor = const Color(0xFF1B1E23);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Traveler Feed',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: AuthWrapper(),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return FeedPage();
        } else {
          return LoginPage();
        }
      },
    );
  }
}

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: Center(
        child: ElevatedButton(
          child: Text('Sign in anonymously'),
          onPressed: () async {
            await FirebaseAuth.instance.signInAnonymously();
          },
        ),
      ),
    );
  }
}

class FeedPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: secondaryColor,
      appBar: AppBar(
        title: Text('Traveler Feed'),
        actions: [
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
            },
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('posts').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Something went wrong'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          return ListView(
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> data =
                  document.data()! as Map<String, dynamic>;
              return PostCard(
                post: Post(
                  id: document.id,
                  title: data['title'] ?? 'No Title',
                  content: data['content'] ?? 'No Content',
                  type: PostType.values[data['type'] as int? ?? 0],
                  creatorId: data['creatorId'] ?? 'Unknown',
                  imageUrl: data['imageUrl'] ?? '',
                  state: data['state'] ?? 'Unknown',
                ),
              );
            }).toList(),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showCreatePostDialog(context);
        },
        child: Icon(Icons.add),
        tooltip: 'Create a new post',
      ),
    );
  }

  void _showCreatePostDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Create a new post'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ElevatedButton(
                child: Text('Create Blog Post'),
                onPressed: () {
                  Navigator.of(context).pop();
                  _navigateToCreatePost(context, PostType.blog);
                },
              ),
              SizedBox(height: 10),
              ElevatedButton(
                child: Text('Create Itinerary Post'),
                onPressed: () {
                  Navigator.of(context).pop();
                  _navigateToCreatePost(context, PostType.itinerary);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _navigateToCreatePost(BuildContext context, PostType type) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => CreatePostPage(type: type),
      ),
    );
  }
}

class PostCard extends StatelessWidget {
  final Post post;

  PostCard({required this.post});

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;
    final isCreator = currentUser != null && currentUser.uid == post.creatorId;

    return Card(
      margin: EdgeInsets.all(8.0),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PostDetailPage(post: post),
            ),
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            if (post.imageUrl.isNotEmpty)
              Image.network(
                post.imageUrl,
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    post.title,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(
                    post.content.length > 100
                        ? '${post.content.substring(0, 100)}...'
                        : post.content,
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Type: ${post.type == PostType.blog ? 'Blog' : 'Itinerary'} | State: ${post.state}',
                    style: TextStyle(fontStyle: FontStyle.italic),
                  ),
                  if (isCreator)
                    ElevatedButton(
                      child: Text('Delete'),
                      onPressed: () {
                        _deletePost(context, post.id);
                      },
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _deletePost(BuildContext context, String postId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Post'),
          content: Text('Are you sure you want to delete this post?'),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Delete'),
              onPressed: () {
                FirebaseFirestore.instance
                    .collection('posts')
                    .doc(postId)
                    .delete();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

class CreatePostPage extends StatefulWidget {
  final PostType type;

  CreatePostPage({required this.type});

  @override
  _CreatePostPageState createState() => _CreatePostPageState();
}

class _CreatePostPageState extends State<CreatePostPage> {
  final _formKey = GlobalKey<FormState>();
  String _title = '';
  String _content = '';
  String _state = 'Select a state';
  File? _image;
  final picker = ImagePicker();

  List<String> _states = [
    'Select a state',
    'California',
    'New York',
    'Florida',
    'Texas',
    // Add more states as needed
  ];

  Future getImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            'Create ${widget.type == PostType.blog ? 'Blog' : 'Itinerary'} Post'),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(labelText: 'Title'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
                onSaved: (value) {
                  _title = value!;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                decoration: InputDecoration(labelText: 'Content'),
                maxLines: 5,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some content';
                  }
                  return null;
                },
                onSaved: (value) {
                  _content = value!;
                },
              ),
              SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _state,
                decoration: InputDecoration(labelText: 'State'),
                items: _states.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _state = newValue!;
                  });
                },
                validator: (value) {
                  if (value == 'Select a state') {
                    return 'Please select a state';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: getImage,
                child: Text('Pick an Image'),
              ),
              _image == null ? Text('No image selected.') : Image.file(_image!),
              SizedBox(height: 16),
              ElevatedButton(
                child: Text('Create Post'),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    _createPost();
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _createPost() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      String imageUrl = '';
      if (_image != null) {
        final ref = FirebaseStorage.instance
            .ref()
            .child('post_images')
            .child('${DateTime.now().toIso8601String()}.jpg');
        await ref.putFile(_image!);
        imageUrl = await ref.getDownloadURL();
      }

      FirebaseFirestore.instance.collection('posts').add({
        'title': _title,
        'content': _content,
        'type': widget.type.index,
        'creatorId': user.uid,
        'timestamp': FieldValue.serverTimestamp(),
        'imageUrl': imageUrl,
        'state': _state,
      }).then((value) {
        Navigator.of(context).pop();
      }).catchError((error) {
        print("Failed to add post: $error");
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('You must be signed in to create a post')),
      );
    }
  }
}

class PostDetailPage extends StatelessWidget {
  final Post post;

  PostDetailPage({required this.post});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(post.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (post.imageUrl.isNotEmpty)
              Image.network(
                post.imageUrl,
                height: 300,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    post.title,
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Type: ${post.type == PostType.blog ? 'Blog' : 'Itinerary'} | State: ${post.state}',
                    style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
                  ),
                  SizedBox(height: 16),
                  Text(
                    post.content,
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

enum PostType { blog, itinerary }

class Post {
  final String id;
  final String title;
  final String content;
  final PostType type;
  final String creatorId;
  final String imageUrl;
  final String state;

  Post({
    required this.id,
    required this.title,
    required this.content,
    required this.type,
    required this.creatorId,
    required this.imageUrl,
    required this.state,
  });
}
