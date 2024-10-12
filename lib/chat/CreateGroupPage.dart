// create_group_page.dart
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'group_service.dart';

class CreateGroupPage extends StatelessWidget {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController stateController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  CreateGroupPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Create Group")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: "Group Title"),
            ),
            TextField(
              controller: stateController,
              decoration: const InputDecoration(labelText: "State Name"),
            ),
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(labelText: "Group Description"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                String title = titleController.text;
                String state = stateController.text;
                String description = descriptionController.text;
                String userId = FirebaseAuth.instance.currentUser!.uid;

                createGroup(title, state, description, userId).then((_) {
                  Navigator.pop(context);
                });
              },
              child: const Text("Create Group"),
            ),
          ],
        ),
      ),
    );
  }
}
