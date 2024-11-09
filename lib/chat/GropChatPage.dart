import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class GroupChatPage extends StatefulWidget {
  final String groupId;

  const GroupChatPage({super.key, required this.groupId});

  @override
  _GroupChatPageState createState() => _GroupChatPageState();
}

var primaryColor = Color(0xFF1EFEBB);
var secondayColor = Color(0xFF02050A);
var ternaryColor = Color(0xFF1B1E23);

class _GroupChatPageState extends State<GroupChatPage> {
  final TextEditingController messageController = TextEditingController();
  String currentUserId = FirebaseAuth.instance.currentUser!.uid;

  Stream<List<Map<String, dynamic>>> getMessages() {
    return FirebaseFirestore.instance
        .collection('groups')
        .doc(widget.groupId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => doc.data()).toList();
    });
  }

  Future<void> sendMessage(String message, String userId) async {
    if (message.isNotEmpty) {
      await FirebaseFirestore.instance
          .collection('groups')
          .doc(widget.groupId)
          .collection('messages')
          .add({
        'message': message,
        'senderId': userId,
        'timestamp': FieldValue.serverTimestamp(),
      });
    }
  }

  Future<String?> getUsername(String userId) async {
    DocumentSnapshot userDoc =
        await FirebaseFirestore.instance.collection('user').doc(userId).get();
    return userDoc['name'];
  }

  void leaveGroup() async {
    await FirebaseFirestore.instance
        .collection('groups')
        .doc(widget.groupId)
        .collection('members')
        .doc(currentUserId)
        .delete();
    Navigator.pop(context);
  }

  void removeUser(String userId) async {
    await FirebaseFirestore.instance
        .collection('groups')
        .doc(widget.groupId)
        .collection('members')
        .doc(userId)
        .delete();
  }

  Future<String> getGroupTitle() async {
    DocumentSnapshot groupDoc = await FirebaseFirestore.instance
        .collection('groups')
        .doc(widget.groupId)
        .get();
    return groupDoc['title'];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 18, 17, 17),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 18, 17, 17),
        titleTextStyle: TextStyle(
            color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
        iconTheme: IconThemeData(color: Colors.white, size: 20),
        title: FutureBuilder<String>(
          future: getGroupTitle(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Text('Loading...');
            }
            return Text(snapshot.data ?? 'Group Chat');
          },
        ),
        // actions: [
        //   PopupMenuButton<String>(
        //     onSelected: (value) {
        //       if (value == 'leave') {
        //         leaveGroup();
        //       } else if (value == 'remove') {
        //         // Prompt to enter the user ID to remove
        //         showDialog(
        //           context: context,
        //           builder: (context) {
        //             return AlertDialog(
        //               title: Text('Remove User'),
        //               content: TextField(
        //                 decoration: InputDecoration(labelText: 'User ID'),
        //                 onSubmitted: (userId) {
        //                   removeUser(userId);
        //                   Navigator.pop(context);
        //                 },
        //               ),
        //             );
        //           },
        //         );
        //       }
        //     },
        //     itemBuilder: (context) => [
        //       const PopupMenuItem(value: 'leave', child: Text('Leave Group')),
        //       const PopupMenuItem(
        //           value: 'remove', child: Text('Remove User from Group')),
        //     ],
        //   ),
        // ],
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<List<Map<String, dynamic>>>(
              stream: getMessages(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                List<Map<String, dynamic>> messages = snapshot.data!;
                return ListView.builder(
                  reverse: true,
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    Map<String, dynamic> message = messages[index];
                    bool isCurrentUser = message['senderId'] == currentUserId;

                    return FutureBuilder<String?>(
                      future: getUsername(message['senderId']),
                      builder: (context, userSnapshot) {
                        String? username = userSnapshot.data ?? 'Unknown';

                        return Align(
                          alignment: isCurrentUser
                              ? Alignment.centerRight
                              : Alignment.centerLeft,
                          child: Container(
                            margin: const EdgeInsets.symmetric(
                                vertical: 5, horizontal: 10),
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: isCurrentUser
                                  ? primaryColor
                                  : Color.fromARGB(255, 126, 125, 125),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  username,
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 12,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  message['message'],
                                  style: const TextStyle(
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: messageController,
                    style: const TextStyle(color: Colors.white),
                    cursorColor: Colors.white,
                    decoration: InputDecoration(
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: primaryColor),
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: primaryColor),
                      ),
                      labelText: "Enter message",
                      labelStyle: const TextStyle(color: Colors.white54),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send, color: Colors.white),
                  onPressed: () {
                    sendMessage(messageController.text, currentUserId);
                    messageController.clear();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
