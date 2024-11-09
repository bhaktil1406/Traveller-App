import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

// final FirebaseAuth auth = FirebaseAuth.instance;

Future<bool> updateLiked(int attrId) async {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  User? currentUser = auth.currentUser;
  if (currentUser != null) {
    DocumentReference userDocRef =
        firestore.collection('user').doc(currentUser.uid);
    DocumentSnapshot userDoc = await userDocRef.get();
    if (userDoc.exists) {
      List<dynamic> currentLiked = userDoc.get("liked");
      if (currentLiked.contains(attrId)) {
        await userDocRef.update({
          "liked": FieldValue.arrayRemove([attrId])
        });

        return false;
      } else {
        await userDocRef.update({
          "liked": FieldValue.arrayUnion([attrId])
        });
        return true;
      }
      // print(userDocRef);
    }

    // return userDocRef;
    return false;
  } else {
    throw Exception('No user is currently signed in.');
  }
}

Future<bool> checkLiked(int attrId) async {
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  User? currentUser = auth.currentUser;

  if (currentUser != null) {
    // Get the document from Firestore using the user's UID
    DocumentReference userDocRef =
        firestore.collection('user').doc(currentUser.uid);
    DocumentSnapshot userDoc = await userDocRef.get();
    if (userDoc.exists) {
      List<dynamic> currentLiked = userDoc.get("liked");
      if (currentLiked.contains(attrId)) {
        print(userDoc.get("liked"));
        return true;
      } else {
        return false;
      }
      // print(userDocRef);
    }

    // return userDocRef;
    return false;
  } else {
    throw Exception('No user is currently signed in.');
  }
}

Future<List<dynamic>> getLiked() async {
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  User? currentUser = auth.currentUser;

  if (currentUser != null) {
    DocumentReference userDocRef =
        firestore.collection('user').doc(currentUser.uid);
    DocumentSnapshot userDoc = await userDocRef.get();
    if (userDoc.exists) {
      List<dynamic> currentLiked = userDoc.get("liked");
      return currentLiked;
    } else {
      return [];
    }
  } else {
    throw Exception('No user is currently signed in.');
  }
}
