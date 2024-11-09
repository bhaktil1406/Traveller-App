// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/gestures.dart';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:tourist_app/pages/Homepage2.dart';
// import 'package:tourist_app/pages/loginpage.dart';
// import 'package:google_sign_in/google_sign_in.dart';

// class register extends StatefulWidget {
//   const register({super.key});

//   @override
//   State<register> createState() => _registerState();
// }

// class _registerState extends State<register> {
//   TextEditingController name = TextEditingController();
//   TextEditingController email = TextEditingController();
//   TextEditingController pass = TextEditingController();
//   bool isLoadind = false;
//   bool isLoadind2 = false;
//   // Add the password validation function here

//   bool validatePassword(String password) {
//     String pattern =
//         r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$';
//     RegExp regex = RegExp(pattern);
//     return regex.hasMatch(password);
//   }

//   // Modify this function to use the password validation
//   Future<User?> createUserWithEmailAndPassword(
//       String email, String password, BuildContext context) async {
//     if (!validatePassword(password)) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text(
//               "Password must contain at least one uppercase letter, one lowercase letter, one digit, one special character, and be at least 8 characters long"),
//         ),
//       );
//       return null;
//     }
//     try {
//       final cred = await FirebaseAuth.instance
//           .createUserWithEmailAndPassword(email: email, password: password);
//       if (cred.user != null) {
//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(builder: (context) => const Homepage2()),
//         );
//       }
//       return cred.user;
//     } on FirebaseAuthException catch (e) {
//       if (e.code == 'weak-password') {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text("Password is too weak")),
//         );
//       } else if (e.code == 'email-already-in-use') {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text("Email is already registered")),
//         );
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text("Something went wrong")),
//         );
//       }
//     }
//     return null;
//   }

// // fon login with google
//   Future<UserCredential?> loginWithGoogle() async {
//     try {
//       final googleUser = await GoogleSignIn().signIn();
//       final googleAuth = await googleUser?.authentication;
//       final cred = GoogleAuthProvider.credential(
//           idToken: googleAuth?.idToken, accessToken: googleAuth?.accessToken);
//       final userCredential =
//           await FirebaseAuth.instance.signInWithCredential(cred);
//       if (userCredential.user != null) {
//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(builder: (context) => const Homepage2()),
//         );
//       }
//       return userCredential;
//     } catch (e) {
//       print(e.toString());
//     }
//     return null;
//   }

//   Future<String?> getCurrentUserId() async {
//     User? user = FirebaseAuth.instance.currentUser;
//     return user?.uid;
//   }

//   void SaveRegisterData() async {
//     try {
//       String? userId = await getCurrentUserId();
//       if (userId != null) {
//         Map<String, dynamic> data = {
//           'uid': userId,
//           'name': name.text,
//           'email': email.text,
//           'pass': pass.text,
//           'liked': [],
//         };
//         await FirebaseFirestore.instance
//             .collection('user')
//             .doc(userId)
//             .set(data);
//         ScaffoldMessenger.of(context)
//             .showSnackBar(const SnackBar(content: Text("Data added")));
//       }
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("Failed to add data: $e")),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color.fromARGB(41, 93, 93, 91),
//       body: Stack(
//         children: [
//           Container(
//             child: Image.asset(
//               'assets/bg3.jpeg',
//             ),
//           ),
//           Container(
//             decoration: const BoxDecoration(
//               gradient: LinearGradient(colors: [
//                 Color.fromARGB(0, 0, 0, 0),
//                 Color.fromARGB(35, 0, 0, 0),
//                 Color.fromARGB(102, 0, 0, 0),
//                 Color.fromARGB(255, 0, 0, 0)
//               ], begin: Alignment.topRight, end: Alignment.bottomRight),
//             ),
//             child: Center(
//               child: SingleChildScrollView(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Center(
//                       child: Padding(
//                         padding: const EdgeInsets.symmetric(horizontal: 20),
//                         child: Text(
//                           "LET'S GET STARTED",
//                           style: GoogleFonts.aboreto(
//                             textStyle: const TextStyle(
//                               fontSize: 25,
//                               color: Color(0xFF1EFEBB),
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                     const SizedBox(height: 30),
//                     Padding(
//                       padding: const EdgeInsets.symmetric(
//                           horizontal: 30, vertical: 5),
//                       child: Container(
//                         height: 60,
//                         decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(10),
//                           border: Border.all(color: const Color(0xFF1EFEBB)),
//                           color: Colors.black.withOpacity(0.5),

//                           // boxShadow: [
//                           //   BoxShadow(
//                           //     color: Color(0xFF1EFEBB),
//                           //     blurRadius: 7,
//                           //     offset: Offset.zero,
//                           //     blurStyle: BlurStyle.solid,
//                           //   ),
//                           // ],
//                         ),
//                         child: TextField(
//                           controller: name,
//                           style: const TextStyle(color: Color(0xFF1EFEBB)),
//                           decoration: InputDecoration(
//                             prefixIcon: const Icon(
//                               Icons.person,
//                               color: Color(0xFF1EFEBB),
//                               size: 20,
//                             ),
//                             labelText: "Name",
//                             labelStyle: GoogleFonts.afacad(
//                               textStyle: const TextStyle(
//                                 color: Color(0xFF1EFEBB),
//                                 fontWeight: FontWeight.normal,
//                                 fontSize: 20,
//                               ),
//                             ),
//                             border: InputBorder.none,
//                             // hintText: "Enter your name",
//                             // hintStyle: TextStyle(color: Color(0xFF1EFEBB)),
//                           ),
//                         ),
//                       ),
//                     ),
//                     const SizedBox(height: 10),
//                     Padding(
//                       padding: const EdgeInsets.symmetric(
//                           horizontal: 30, vertical: 5),
//                       child: Container(
//                         height: 60,
//                         decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(10),
//                           border: Border.all(color: const Color(0xFF1EFEBB)),
//                           color: Colors.black.withOpacity(0.5),
//                           // boxShadow: [
//                           //   BoxShadow(
//                           //     color: Color(0xFF1EFEBB),
//                           //     blurRadius: 7,
//                           //     offset: Offset.zero,
//                           //     blurStyle: BlurStyle.solid,
//                           //   ),
//                           // ],
//                         ),
//                         child: TextField(
//                           controller: email,
//                           style: const TextStyle(color: Color(0xFF1EFEBB)),
//                           decoration: InputDecoration(
//                             prefixIcon: const Icon(
//                               Icons.email,
//                               size: 20,
//                               color: Color(0xFF1EFEBB),
//                             ),
//                             labelText: "Email",
//                             labelStyle: GoogleFonts.afacad(
//                               textStyle: const TextStyle(
//                                 color: Color(0xFF1EFEBB),
//                                 fontWeight: FontWeight.normal,
//                                 fontSize: 20,
//                               ),
//                             ),
//                             border: InputBorder.none,
//                             // hintText: "Enter your email",
//                             // hintStyle: TextStyle(color: Color(0xFF1EFEBB)),
//                           ),
//                         ),
//                       ),
//                     ),
//                     const SizedBox(height: 10),
//                     Padding(
//                       padding: const EdgeInsets.symmetric(
//                           horizontal: 30, vertical: 5),
//                       child: Container(
//                         height: 60,
//                         decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(10),
//                           border: Border.all(color: const Color(0xFF1EFEBB)),
//                           color: Colors.black.withOpacity(0.5),
//                           // boxShadow: [
//                           //   BoxShadow(
//                           //     color: Color(0xFF1EFEBB),
//                           //     blurRadius: 7,
//                           //     offset: Offset.zero,
//                           //     blurStyle: BlurStyle.solid,
//                           //   ),
//                           // ],
//                         ),
//                         child: TextField(
//                           controller: pass,
//                           style: const TextStyle(color: Color(0xFF1EFEBB)),
//                           decoration: InputDecoration(
//                             prefixIcon: const Icon(
//                               Icons.lock,
//                               size: 20,
//                               color: Color(0xFF1EFEBB),
//                             ),
//                             labelText: "Password",
//                             labelStyle: GoogleFonts.afacad(
//                               textStyle: const TextStyle(
//                                 color: Color(0xFF1EFEBB),
//                                 fontWeight: FontWeight.normal,
//                                 fontSize: 20,
//                               ),
//                             ),
//                             border: InputBorder.none,
//                             // hintText: "Enter your password",
//                             // hintStyle: TextStyle(color: Color(0xFF1EFEBB)),
//                           ),
//                           obscureText: true,
//                         ),
//                       ),
//                     ),
//                     const SizedBox(height: 30),
//                     Center(
//                       child: Padding(
//                         padding: const EdgeInsets.symmetric(
//                             horizontal: 30, vertical: 5),
//                         child: isLoadind2
//                             ? const CircularProgressIndicator(
//                                 color: Color(0xFF1EFEBB),
//                               )
//                             : Container(
//                                 height: 60,
//                                 width: double.infinity,
//                                 decoration: BoxDecoration(
//                                   borderRadius: BorderRadius.circular(50),
//                                   border: Border.all(
//                                       color: const Color(0xFF1EFEBB)),
//                                   color: const Color(0xFF1EFEBB),
//                                   // boxShadow: [
//                                   //   BoxShadow(
//                                   //     color: Color(0xFF1EFEBB),
//                                   //     blurRadius: 7,
//                                   //     offset: Offset.zero,
//                                   //     blurStyle: BlurStyle.solid,
//                                   //   ),
//                                   // ],
//                                 ),
//                                 child: TextButton(
//                                   onPressed: () async {
//                                     setState(() {
//                                       isLoadind2 = true;
//                                     });
//                                     try {
//                                       await createUserWithEmailAndPassword(
//                                           email.text, pass.text, context);
//                                       SaveRegisterData();
//                                     } finally {
//                                       setState(() {
//                                         isLoadind2 = false;
//                                       });
//                                     }
//                                   },
//                                   child: Text(
//                                     "Register",
//                                     style: GoogleFonts.lato(
//                                       textStyle: const TextStyle(
//                                           fontSize: 20,
//                                           color: Colors.black,
//                                           fontWeight: FontWeight.w900),
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                       ),
//                     ),
//                     const SizedBox(
//                       height: 30,
//                     ),
//                     const Padding(
//                       padding: EdgeInsets.symmetric(horizontal: 20),
//                       child: Divider(
//                         color: Color(0xFF1EFEBB),
//                         thickness: 2,
//                       ),
//                     ),
//                     const SizedBox(
//                       height: 30,
//                     ),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                       children: [
//                         isLoadind
//                             ? const CircularProgressIndicator(
//                                 color: Color(0xFF1EFEBB),
//                               )
//                             : GestureDetector(
//                                 onTap: () async {
//                                   setState(() {
//                                     isLoadind = true;
//                                   });
//                                   await loginWithGoogle();
//                                   setState(() {
//                                     isLoadind = false;
//                                   });
//                                 },
//                                 child: Container(
//                                   height: 50,
//                                   width: 50,
//                                   decoration: BoxDecoration(
//                                     borderRadius: BorderRadius.circular(50),
//                                     border: Border.all(
//                                         color: const Color(0xFF1EFEBB)),
//                                     color: Colors.black,
//                                     // boxShadow: [
//                                     //   BoxShadow(
//                                     //     color: Color(0xFF1EFEBB),
//                                     //     blurRadius: 7,
//                                     //     offset: Offset.zero,
//                                     //     blurStyle: BlurStyle.solid,
//                                     //   ),
//                                     // ],
//                                   ),
//                                   child: Row(
//                                     children: [
//                                       Padding(
//                                         padding: const EdgeInsets.all(12.0),
//                                         child: Image.asset(
//                                           'assets/google.png',
//                                         ),
//                                       ),
//                                       // Text(
//                                       //   "Google login",
//                                       //   style:
//                                       //       TextStyle(color: Color(0xFF1EFEBB)),
//                                       // ),
//                                     ],
//                                   ),
//                                 ),
//                               ),
//                         // GestureDetector(
//                         //   onTap: () {
//                         //     Navigator.push(
//                         //         context,
//                         //         MaterialPageRoute(
//                         //             builder: (context) => phoneregi()));
//                         //   },
//                         //   child: Container(
//                         //     height: 50,
//                         //     width: 150,
//                         //     decoration: BoxDecoration(
//                         //       borderRadius: BorderRadius.circular(20),
//                         //       border: Border.all(color: Color(0xFF1EFEBB)),
//                         //       color: Colors.black,
//                         //       boxShadow: [
//                         //         BoxShadow(
//                         //           color: Color(0xFF1EFEBB),
//                         //           blurRadius: 7,
//                         //           offset: Offset.zero,
//                         //           blurStyle: BlurStyle.solid,
//                         //         ),
//                         //       ],
//                         //     ),
//                         //     child: Row(
//                         //       children: [
//                         //         Padding(
//                         //             padding: const EdgeInsets.all(12.0),
//                         //             child: Icon(
//                         //               Icons.phone,
//                         //               color: Color(0xFF1EFEBB),
//                         //             )),
//                         //         Text(
//                         //           "phone login",
//                         //           style: TextStyle(color: Color(0xFF1EFEBB)),
//                         //         ),
//                         //       ],
//                         //     ),
//                         //   ),
//                         // ),
//                       ],
//                     ),
//                     const SizedBox(
//                       height: 20,
//                     ),
//                     Center(
//                       child: Container(
//                           child: RichText(
//                         text: TextSpan(
//                           children: <TextSpan>[
//                             const TextSpan(
//                                 text: 'already register?',
//                                 style: TextStyle(
//                                     color: Colors.white, fontSize: 18)),
//                             TextSpan(
//                                 recognizer: TapGestureRecognizer()
//                                   ..onTap = () {
//                                     Navigator.push(
//                                         context,
//                                         MaterialPageRoute(
//                                             builder: ((context) =>
//                                                 const loginpage())));
//                                   },
//                                 text: ' login here',
//                                 style: const TextStyle(
//                                     color: Color(0xFF1EFEBB),
//                                     fontSize: 18,
//                                     fontWeight: FontWeight.bold)),
//                           ],
//                         ),
//                       )),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tourist_app/pages/categories.dart';
import 'package:tourist_app/pages/Homepage2.dart';
// import 'package:tourist_app/pages/categories.dart';
import 'package:tourist_app/pages/loginpage.dart';
import 'package:google_sign_in/google_sign_in.dart';

class register extends StatefulWidget {
  const register({super.key});

  @override
  State<register> createState() => _registerState();
}

class _registerState extends State<register> {
  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController pass = TextEditingController();
  bool isLoadind = false;
  bool isLoadind2 = false;
  // Add the password validation function here

  bool validatePassword(String password) {
    String pattern =
        r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$';
    RegExp regex = RegExp(pattern);
    return regex.hasMatch(password);
  }

  // Modify this function to use the password validation
  Future<User?> createUserWithEmailAndPassword(
      String email, String password, BuildContext context) async {
    if (!validatePassword(password)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
              "Password must contain at least one uppercase letter, one lowercase letter, one digit, one special character, and be at least 8 characters long"),
        ),
      );
      return null;
    }
    try {
      final cred = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      if (cred.user != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const Homepage2()),
        );
      }
      return cred.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Password is too weak")),
        );
      } else if (e.code == 'email-already-in-use') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Email is already registered")),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Something went wrong")),
        );
      }
    }
    return null;
  }

// fon login with google
  Future<UserCredential?> loginWithGoogle() async {
    try {
      final googleUser = await GoogleSignIn().signIn();
      final googleAuth = await googleUser?.authentication;
      final cred = GoogleAuthProvider.credential(
          idToken: googleAuth?.idToken, accessToken: googleAuth?.accessToken);
      final userCredential =
          await FirebaseAuth.instance.signInWithCredential(cred);
      if (userCredential.user != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const Homepage2()),
        );
      }
      return userCredential;
    } catch (e) {
      print(e.toString());
    }
    return null;
  }

  String? getCurrentUserId() {
    User? user = FirebaseAuth.instance.currentUser;
    return user?.uid;
  }

  void SaveRegisterData() {
    try {
      String? userId = getCurrentUserId();
      if (userId != null) {
        Map<String, dynamic> data = {
          'uid': userId,
          'name': name.text,
          'email': email.text,
          'pass': pass.text,
          'liked': [],
          'categories': []
        };
        FirebaseFirestore.instance.collection('user').doc(userId).set(data);
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("Data added")));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to add data: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(41, 93, 93, 91),
      body: Stack(
        children: [
          Container(
            child: Image.asset(
              'assets/bg3.jpeg',
            ),
          ),
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(colors: [
                Color.fromARGB(0, 0, 0, 0),
                Color.fromARGB(35, 0, 0, 0),
                Color.fromARGB(102, 0, 0, 0),
                Color.fromARGB(255, 0, 0, 0)
              ], begin: Alignment.topRight, end: Alignment.bottomRight),
            ),
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                          "LET'S GET STARTED",
                          style: GoogleFonts.aboreto(
                            textStyle: const TextStyle(
                              fontSize: 25,
                              color: Color(0xFF1EFEBB),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 5),
                      child: Container(
                        height: 60,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: const Color(0xFF1EFEBB)),
                          color: Colors.black.withOpacity(0.5),

                          // boxShadow: [
                          //   BoxShadow(
                          //     color: Color(0xFF1EFEBB),
                          //     blurRadius: 7,
                          //     offset: Offset.zero,
                          //     blurStyle: BlurStyle.solid,
                          //   ),
                          // ],
                        ),
                        child: TextField(
                          controller: name,
                          style: const TextStyle(color: Color(0xFF1EFEBB)),
                          decoration: InputDecoration(
                            prefixIcon: const Icon(
                              Icons.person,
                              color: Color(0xFF1EFEBB),
                              size: 20,
                            ),
                            labelText: "Name",
                            labelStyle: GoogleFonts.afacad(
                              textStyle: const TextStyle(
                                color: Color(0xFF1EFEBB),
                                fontWeight: FontWeight.normal,
                                fontSize: 20,
                              ),
                            ),
                            border: InputBorder.none,
                            // hintText: "Enter your name",
                            // hintStyle: TextStyle(color: Color(0xFF1EFEBB)),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 5),
                      child: Container(
                        height: 60,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: const Color(0xFF1EFEBB)),
                          color: Colors.black.withOpacity(0.5),
                          // boxShadow: [
                          //   BoxShadow(
                          //     color: Color(0xFF1EFEBB),
                          //     blurRadius: 7,
                          //     offset: Offset.zero,
                          //     blurStyle: BlurStyle.solid,
                          //   ),
                          // ],
                        ),
                        child: TextField(
                          controller: email,
                          style: const TextStyle(color: Color(0xFF1EFEBB)),
                          decoration: InputDecoration(
                            prefixIcon: const Icon(
                              Icons.email,
                              size: 20,
                              color: Color(0xFF1EFEBB),
                            ),
                            labelText: "Email",
                            labelStyle: GoogleFonts.afacad(
                              textStyle: const TextStyle(
                                color: Color(0xFF1EFEBB),
                                fontWeight: FontWeight.normal,
                                fontSize: 20,
                              ),
                            ),
                            border: InputBorder.none,
                            // hintText: "Enter your email",
                            // hintStyle: TextStyle(color: Color(0xFF1EFEBB)),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 5),
                      child: Container(
                        height: 60,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: const Color(0xFF1EFEBB)),
                          color: Colors.black.withOpacity(0.5),
                          // boxShadow: [
                          //   BoxShadow(
                          //     color: Color(0xFF1EFEBB),
                          //     blurRadius: 7,
                          //     offset: Offset.zero,
                          //     blurStyle: BlurStyle.solid,
                          //   ),
                          // ],
                        ),
                        child: TextField(
                          controller: pass,
                          style: const TextStyle(color: Color(0xFF1EFEBB)),
                          decoration: InputDecoration(
                            prefixIcon: const Icon(
                              Icons.lock,
                              size: 20,
                              color: Color(0xFF1EFEBB),
                            ),
                            labelText: "Password",
                            labelStyle: GoogleFonts.afacad(
                              textStyle: const TextStyle(
                                color: Color(0xFF1EFEBB),
                                fontWeight: FontWeight.normal,
                                fontSize: 20,
                              ),
                            ),
                            border: InputBorder.none,
                            // hintText: "Enter your password",
                            // hintStyle: TextStyle(color: Color(0xFF1EFEBB)),
                          ),
                          obscureText: true,
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 30, vertical: 5),
                        child: isLoadind2
                            ? const CircularProgressIndicator(
                                color: Color(0xFF1EFEBB),
                              )
                            : Container(
                                height: 60,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50),
                                  border: Border.all(
                                      color: const Color(0xFF1EFEBB)),
                                  color: const Color(0xFF1EFEBB),
                                  // boxShadow: [
                                  //   BoxShadow(
                                  //     color: Color(0xFF1EFEBB),
                                  //     blurRadius: 7,
                                  //     offset: Offset.zero,
                                  //     blurStyle: BlurStyle.solid,
                                  //   ),
                                  // ],
                                ),
                                child: TextButton(
                                  onPressed: () async {
                                    setState(() {
                                      isLoadind2 = true;
                                    });
                                    try {
                                      await createUserWithEmailAndPassword(
                                          email.text, pass.text, context);
                                      SaveRegisterData();
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (e) =>
                                                  const Categories()));
                                    } finally {
                                      setState(() {
                                        isLoadind2 = false;
                                      });
                                    }
                                  },
                                  child: Text(
                                    "Register",
                                    style: GoogleFonts.lato(
                                      textStyle: const TextStyle(
                                          fontSize: 20,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w900),
                                    ),
                                  ),
                                ),
                              ),
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Divider(
                        color: Color(0xFF1EFEBB),
                        thickness: 2,
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        isLoadind
                            ? const CircularProgressIndicator(
                                color: Color(0xFF1EFEBB),
                              )
                            : GestureDetector(
                                onTap: () async {
                                  setState(() {
                                    isLoadind = true;
                                  });
                                  await loginWithGoogle();
                                  setState(() {
                                    isLoadind = false;
                                  });
                                },
                                child: Container(
                                  height: 50,
                                  width: 50,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(50),
                                    border: Border.all(
                                        color: const Color(0xFF1EFEBB)),
                                    color: Colors.black,
                                    // boxShadow: [
                                    //   BoxShadow(
                                    //     color: Color(0xFF1EFEBB),
                                    //     blurRadius: 7,
                                    //     offset: Offset.zero,
                                    //     blurStyle: BlurStyle.solid,
                                    //   ),
                                    // ],
                                  ),
                                  child: Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(12.0),
                                        child: Image.asset(
                                          'assets/google.png',
                                        ),
                                      ),
                                      // Text(
                                      //   "Google login",
                                      //   style:
                                      //       TextStyle(color: Color(0xFF1EFEBB)),
                                      // ),
                                    ],
                                  ),
                                ),
                              ),
                        // GestureDetector(
                        //   onTap: () {
                        //     Navigator.push(
                        //         context,
                        //         MaterialPageRoute(
                        //             builder: (context) => phoneregi()));
                        //   },
                        //   child: Container(
                        //     height: 50,
                        //     width: 150,
                        //     decoration: BoxDecoration(
                        //       borderRadius: BorderRadius.circular(20),
                        //       border: Border.all(color: Color(0xFF1EFEBB)),
                        //       color: Colors.black,
                        //       boxShadow: [
                        //         BoxShadow(
                        //           color: Color(0xFF1EFEBB),
                        //           blurRadius: 7,
                        //           offset: Offset.zero,
                        //           blurStyle: BlurStyle.solid,
                        //         ),
                        //       ],
                        //     ),
                        //     child: Row(
                        //       children: [
                        //         Padding(
                        //             padding: const EdgeInsets.all(12.0),
                        //             child: Icon(
                        //               Icons.phone,
                        //               color: Color(0xFF1EFEBB),
                        //             )),
                        //         Text(
                        //           "phone login",
                        //           style: TextStyle(color: Color(0xFF1EFEBB)),
                        //         ),
                        //       ],
                        //     ),
                        //   ),
                        // ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Center(
                      child: Container(
                          child: RichText(
                        text: TextSpan(
                          children: <TextSpan>[
                            const TextSpan(
                                text: 'already register?',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 18)),
                            TextSpan(
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: ((context) =>
                                                const loginpage())));
                                  },
                                text: ' login here',
                                style: const TextStyle(
                                    color: Color(0xFF1EFEBB),
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold)),
                          ],
                        ),
                      )),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
