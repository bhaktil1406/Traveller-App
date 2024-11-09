import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:tourist_app/pages/Homepage2.dart';
import 'package:tourist_app/pages/register.dart';
import 'package:flutter/services.dart';

class loginpage extends StatefulWidget {
  const loginpage({super.key});

  @override
  State<loginpage> createState() => _loginpageState();
}

class _loginpageState extends State<loginpage> {
  TextEditingController email = TextEditingController();
  TextEditingController pass = TextEditingController();
  bool isLoadind = false;
  bool isLoadind2 = false;
  final secondayColor = const Color(0xFF1EFEBB);

  Future<User?> loginUserWithEmailAndPassword(
      String email, String password, BuildContext context) async {
    try {
      // Attempt to sign in with email and password
      final cred = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      return cred.user;
    } on FirebaseAuthException catch (e11) {
      // Handle Firebase-specific exceptions
      if (e11.code == 'wrong-password' || e11.code == 'user-not-found') {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
            "Incorrect email or password",
            style: TextStyle(color: Colors.red),
          ),
        ));
      } else if (e11.code == 'invalid-email') {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
            "Invalid email format",
            style: TextStyle(color: Colors.red),
          ),
        ));
      } else if (e11.code == 'invalid-credential') {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
            "Invalid credentials. Please try again.",
            style: TextStyle(color: Colors.red),
          ),
        ));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
            "An error occurred: ${e11.message}",
            style: const TextStyle(color: Colors.red),
          ),
        ));
      }
      print(e11); // For debugging purposes
    } on PlatformException catch (e) {
      // Handle platform-specific exceptions
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          "An unexpected error occurred: ${e.message}",
          style: const TextStyle(color: Colors.red),
        ),
      ));
    } catch (e) {
      // Handle any other exceptions that might occur
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          "An unexpected error occurred: $e",
          style: const TextStyle(color: Colors.red),
        ),
      ));
      print(e); // For debugging purposes
    }
    return null;
  }

// Function to call login and navigate upon success
  Future<void> si(BuildContext context, String email, String password) async {
    final user = await loginUserWithEmailAndPassword(email, password, context);
    if (user != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) =>
                const Homepage2()), // Replace with your homepage widget
      );
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Login successful"),
      ));
    }
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
                Color.fromARGB(105, 0, 0, 0),
                Color.fromARGB(177, 0, 0, 0),
                Color.fromARGB(255, 0, 0, 0)
              ], begin: Alignment.topRight, end: Alignment.bottomRight),
            ),
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                          "Login To Your Account",
                          style: TextStyle(
                            fontSize: 25,
                            color: Color(0xFF1EFEBB),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 5),
                      child: Container(
                        height: 60,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: const Color(0xFF1EFEBB)),
                          color: Colors.black,
                          // boxShadow: [
                          //   const BoxShadow(
                          //     color: Color(0xFF1EFEBB),
                          //     blurRadius: 7,
                          //     offset: Offset.zero,
                          //     blurStyle: BlurStyle.solid,
                          //   ),
                          // ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 30),
                          child: TextField(
                            controller: email,
                            style: const TextStyle(color: Color(0xFF1EFEBB)),
                            decoration: const InputDecoration(
                              // prefixIcon: const Icon(
                              //   Icons.email,
                              //   size: 25,
                              //   color: Color(0xFF1EFEBB),
                              // ),
                              labelText: "Email",
                              labelStyle: TextStyle(
                                color: Color(0xFF1EFEBB),
                                fontWeight: FontWeight.normal,
                                fontSize: 20,
                              ),
                              border: InputBorder.none,
                              // hintText: "Enter your email",
                              // hintStyle: TextStyle(color: Color(0xFF1EFEBB)),
                            ),
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
                          color: Colors.black,
                          // boxShadow: [
                          //   const BoxShadow(
                          //     color: Color(0xFF1EFEBB),
                          //     blurRadius: 7,
                          //     offset: Offset.zero,
                          //     blurStyle: BlurStyle.solid,
                          //   ),
                          // ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 30),
                          child: TextField(
                            controller: pass,
                            style: const TextStyle(color: Color(0xFF1EFEBB)),
                            decoration: const InputDecoration(
                              // prefixIcon: const Icon(
                              //   Icons.lock,
                              //   size: 25,
                              //   color: Color(0xFF1EFEBB),
                              // ),
                              labelText: "Password",
                              labelStyle: TextStyle(
                                color: Color(0xFF1EFEBB),
                                fontWeight: FontWeight.normal,
                                fontSize: 20,
                              ),
                              border: InputBorder.none,
                              // hintText: "Enter your password",
                              // hintStyle: TextStyle(color: Color(0xFF1EFEBB)),
                            ),
                            obscureText: true,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 50, vertical: 5),
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
                                  //   const BoxShadow(
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
                                      isLoadind2 =
                                          true; // Start loading when the button is pressed
                                    });

                                    try {
                                      // Call the login function and pass email, password, and context
                                      await si(context, email.text, pass.text);
                                    } finally {
                                      // Stop loading after the operation finishes (success or failure)
                                      setState(() {
                                        isLoadind2 = false;
                                      });
                                    }
                                  },
                                  child: isLoadind2
                                      ? const CircularProgressIndicator() // Show loader while processing
                                      : const Text(
                                          "Login"), // Button text when not loading
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
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                        color: const Color(0xFF1EFEBB)),
                                    color: Colors.black,
                                    // boxShadow: [
                                    //   const BoxShadow(
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
                        //             builder: (context) => const phoneregi()));
                        //   },
                        //   child: Container(
                        //     height: 50,
                        //     width: 150,
                        //     decoration: BoxDecoration(
                        //       borderRadius: BorderRadius.circular(20),
                        //       border:
                        //           Border.all(color: const Color(0xFF1EFEBB)),
                        //       color: Colors.black,
                        //       boxShadow: [
                        //         const BoxShadow(
                        //           color: Color(0xFF1EFEBB),
                        //           blurRadius: 7,
                        //           offset: Offset.zero,
                        //           blurStyle: BlurStyle.solid,
                        //         ),
                        //       ],
                        //     ),
                        //     child: Row(
                        //       children: [
                        //         const Padding(
                        //             padding: EdgeInsets.all(12.0),
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
                      height: 30,
                    ),
                    Center(
                      child: Container(
                          child: RichText(
                        text: TextSpan(
                          children: <TextSpan>[
                            const TextSpan(
                                text: 'Do not have an account?',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 18)),
                            TextSpan(
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: ((context) =>
                                                const register())));
                                  },
                                text: ' Register here',
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
