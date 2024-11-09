// group_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'group_model.dart';

Future<void> createGroup(
    String title, String state, String description, String userId) async {
  try {
    DocumentReference groupRef =
        FirebaseFirestore.instance.collection('groups').doc();
    Group newGroup = Group(
      id: groupRef.id,
      title: title,
      state: state,
      description: description,
      participants: [userId],
    );

    await groupRef.set(newGroup.toMap());
  } catch (e) {
    print("Error creating group: $e");
  }
}

Future<void> joinGroup(String groupId, String userId) async {
  try {
    DocumentReference groupRef =
        FirebaseFirestore.instance.collection('groups').doc(groupId);

    await groupRef.update({
      'participants': FieldValue.arrayUnion([userId])
    });
  } catch (e) {
    print("Error joining group: $e");
  }
}

Stream<List<Group>> getGroups() {
  return FirebaseFirestore.instance
      .collection('groups')
      .snapshots()
      .map((snapshot) {
    return snapshot.docs.map((doc) => Group.fromMap(doc.data())).toList();
  });
}
