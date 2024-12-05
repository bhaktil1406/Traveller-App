// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:image_picker/image_picker.dart';
// import 'dart:io';
// import 'package:flutter_image_compress/flutter_image_compress.dart';

// class AddPostPage extends StatefulWidget {
//   @override
//   _AddPostPageState createState() => _AddPostPageState();
// }

// class _AddPostPageState extends State<AddPostPage> {
//   final TextEditingController _titleController = TextEditingController();
//   final TextEditingController _descriptionController = TextEditingController();
//   File? _imageFile;
//   final picker = ImagePicker();

//   Future<File?> compressImage(File file) async {
//     final compressedFile = await FlutterImageCompress.compressAndGetFile(
//       file.absolute.path,
//       '${file.parent.path}/compressed_${DateTime.now().millisecondsSinceEpoch}.jpg',
//       quality: 75,
//     );
//     return compressedFile;
//   }

//   Future<void> _pickImage() async {
//     final pickedFile = await picker.pickImage(source: ImageSource.gallery);
//     setState(() {
//       _imageFile = pickedFile != null ? File(pickedFile.path) : null;
//     });
//   }

//   Future<String?> _uploadImage(File imageFile) async {
//     try {
//       File? compressedImage = await compressImage(imageFile);
//       if (compressedImage == null) return null;

//       final storageRef = FirebaseStorage.instance
//           .ref()
//           .child('feed_images/${DateTime.now().toIso8601String()}');
//       await storageRef.putFile(compressedImage);
//       return await storageRef.getDownloadURL();
//     } catch (e) {
//       print('Error uploading image: $e');
//       return null;
//     }
//   }

//   Future<void> _savePost() async {
//     if (_titleController.text.isEmpty ||
//         _descriptionController.text.isEmpty ||
//         _imageFile == null) return;

//     String? imageUrl = await _uploadImage(_imageFile!);

//     try {
//       await FirebaseFirestore.instance.collection('feed').add({
//         'title': _titleController.text,
//         'description': _descriptionController.text,
//         'imageUrl': imageUrl,
//         'timestamp': FieldValue.serverTimestamp(),
//       });

//       _titleController.clear();
//       _descriptionController.clear();
//       setState(() {
//         _imageFile = null;
//       });

//       Navigator.pop(context);
//     } catch (e) {
//       print('Error saving post: $e');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Add Post', style: TextStyle(color: Colors.white)),
//         backgroundColor: Colors.black,
//         iconTheme: IconThemeData(color: Colors.white),
//       ),
//       body: Container(
//         color: Colors.black,
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             TextField(
//               controller: _titleController,
//               style: TextStyle(color: Colors.white),
//               decoration: InputDecoration(
//                 labelText: 'Title',
//                 labelStyle: TextStyle(color: Colors.white),
//                 enabledBorder: UnderlineInputBorder(
//                   borderSide: BorderSide(color: Colors.white),
//                 ),
//                 focusedBorder: UnderlineInputBorder(
//                   borderSide: BorderSide(color: Colors.white),
//                 ),
//               ),
//             ),
//             TextField(
//               controller: _descriptionController,
//               style: TextStyle(
//                 color: Colors.white,
//               ),
//               maxLines: 5,
//               decoration: InputDecoration(
//                 labelText: 'Description',
//                 labelStyle: TextStyle(color: Colors.white),
//                 enabledBorder: UnderlineInputBorder(
//                   borderSide: BorderSide(color: Colors.white),
//                 ),
//                 focusedBorder: UnderlineInputBorder(
//                   borderSide: BorderSide(color: Colors.white),
//                 ),
//               ),
//             ),
//             const SizedBox(height: 20),
//             GestureDetector(
//               onTap: _pickImage,
//               child: _imageFile == null
//                   ? Container(
//                       height: 150,
//                       width: double.infinity,
//                       decoration: BoxDecoration(
//                         color: Colors.grey[600],
//                         borderRadius: BorderRadius.circular(12.0),
//                         border: Border.all(color: Colors.grey[400]!, width: 1),
//                       ),
//                       child: Icon(Icons.add_a_photo, color: Colors.grey[800]),
//                     )
//                   : ClipRRect(
//                       borderRadius: BorderRadius.circular(12.0),
//                       child: Image.file(
//                         _imageFile!,
//                         height: 150,
//                         width: double.infinity,
//                         fit: BoxFit.cover,
//                       ),
//                     ),
//             ),
//             const SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: _savePost,
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Color(0xFF0EFEBB), // Save Post button color
//               ),
//               child: Text('Save Post'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:flutter_image_compress/flutter_image_compress.dart';

class AddPostPage extends StatefulWidget {
  @override
  _AddPostPageState createState() => _AddPostPageState();
}

class _AddPostPageState extends State<AddPostPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  File? _imageFile;
  final picker = ImagePicker();

  Future<File?> compressImage(File file) async {
    final compressedFile = await FlutterImageCompress.compressAndGetFile(
      file.absolute.path,
      '${file.parent.path}/compressed_${DateTime.now().millisecondsSinceEpoch}.jpg',
      quality: 75,
    );
    return compressedFile;
  }

  Future<void> _pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _imageFile = pickedFile != null ? File(pickedFile.path) : null;
    });
  }

  Future<String?> _uploadImage(File imageFile) async {
    try {
      File? compressedImage = await compressImage(imageFile);
      if (compressedImage == null) return null;

      final storageRef = FirebaseStorage.instance
          .ref()
          .child('feed_images/${DateTime.now().toIso8601String()}');
      await storageRef.putFile(compressedImage);
      return await storageRef.getDownloadURL();
    } catch (e) {
      print('Error uploading image: $e');
      return null;
    }
  }

  Future<void> _savePost() async {
    if (_titleController.text.isEmpty ||
        _descriptionController.text.isEmpty ||
        _imageFile == null) return;

    String? imageUrl = await _uploadImage(_imageFile!);

    try {
      await FirebaseFirestore.instance.collection('feed').add({
        'title': _titleController.text,
        'description': _descriptionController.text,
        'imageUrl': imageUrl,
        'timestamp': FieldValue.serverTimestamp(),
      });

      _titleController.clear();
      _descriptionController.clear();
      setState(() {
        _imageFile = null;
      });

      Navigator.pop(context);
    } catch (e) {
      print('Error saving post: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Post', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Container(
        color: Colors.black,
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _titleController,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'Title',
                labelStyle: TextStyle(color: Colors.white),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _descriptionController,
              style: TextStyle(color: Colors.white),
              maxLines: null, // Allows the text field to expand with content
              decoration: InputDecoration(
                labelText: 'Description',
                labelStyle: TextStyle(color: Colors.white),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: _pickImage,
              child: _imageFile == null
                  ? Container(
                      height: 150,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.grey[600],
                        borderRadius: BorderRadius.circular(12.0),
                        border: Border.all(color: Colors.grey[400]!, width: 1),
                      ),
                      child: Icon(Icons.add_a_photo, color: Colors.grey[800]),
                    )
                  : ClipRRect(
                      borderRadius: BorderRadius.circular(12.0),
                      child: Image.file(
                        _imageFile!,
                        height: 150,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _savePost,
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF0EFEBB), // Save Post button color
              ),
              child: Text(
                'Save Post',
                style: TextStyle(color: Colors.black),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
