import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'group_service.dart';

const primaryColor = Color(0xFF1EFEBB);
const secondayColor = Color(0xFF02050A);
const ternaryColor = Color(0xFF1B1E23);

class CreateGroupPage extends StatelessWidget {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController stateController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  CreateGroupPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 18, 17, 17),
      // appBar: AppBar(title: const Text("Create Group")),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              decoration: BoxDecoration(
                  color: secondayColor,
                  borderRadius: BorderRadius.circular(25),
                  border:
                      Border.all(color: const Color.fromARGB(255, 55, 55, 55))),
              child: Column(
                children: [
                  TextField(
                    controller: titleController,
                    cursorColor: Colors.white,
                    style: TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      labelStyle: TextStyle(color: Colors.white),
                      labelText: "Group Title",
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: primaryColor),
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: primaryColor),
                      ),
                    ),
                  ),
                  TextField(
                    controller: stateController,
                    cursorColor: Colors.white,
                    style: TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      labelStyle: TextStyle(color: Colors.white),
                      labelText: "State Name",
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: primaryColor),
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: primaryColor),
                      ),
                    ),
                  ),
                  TextField(
                    controller: descriptionController,
                    cursorColor: Colors.white,
                    style: TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      labelStyle: TextStyle(color: Colors.white),
                      labelText: "Group Description",
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: primaryColor),
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: primaryColor),
                      ),
                    ),
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
                    child: const Text(
                      "Create Group",
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold),
                    ),
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
