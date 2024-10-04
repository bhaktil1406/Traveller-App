import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tourist_app/pages/home.dart';
import 'package:tourist_app/pages/Homepage2.dart';
import 'package:tourist_app/pages/loginpage.dart';
import 'package:tourist_app/pages/phoneregi.dart';
import 'package:google_sign_in/google_sign_in.dart';

class register extends StatefulWidget {
  @override
  State<register> createState() => _registerState();
}

class _registerState extends State<register> {
  TextEditingController name = new TextEditingController();
  TextEditingController email = new TextEditingController();
  TextEditingController pass = new TextEditingController();
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
        SnackBar(
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
          MaterialPageRoute(builder: (context) => Homepage2()),
        );
      }
      return cred.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Password is too weak")),
        );
      } else if (e.code == 'email-already-in-use') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Email is already registered")),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Something went wrong")),
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
          MaterialPageRoute(builder: (context) => Homepage2()),
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
      backgroundColor: Color.fromARGB(41, 93, 93, 91),
      body: Stack(
        children: [
          Container(
            child: Image.asset(
              'assets/bc1.jpg',
            ),
          ),
          // Container(
          //   height: 200,
          //   decoration: BoxDecoration(
          //     gradient: const LinearGradient(colors: [
          //       Color.fromARGB(255, 220, 94, 85),
          //       Color.fromARGB(255, 172, 48, 226)
          //     ], begin: Alignment.topRight, end: Alignment.bottomRight),
          //   ),
          // ),
          Container(
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [
                Color.fromARGB(141, 0, 0, 0),
                Color.fromARGB(174, 0, 0, 0),
                Color.fromARGB(255, 0, 0, 0),
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
                            textStyle: TextStyle(
                              fontSize: 50,
                              color: Color(0xfffed0a9),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 30),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 5),
                      child: Container(
                        height: 70,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: const Color(0xfffed0a9)),
                          color: Colors.black,
                          boxShadow: [
                            BoxShadow(
                              color: Color(0xfffed0a9),
                              blurRadius: 7,
                              offset: Offset.zero,
                              blurStyle: BlurStyle.solid,
                            ),
                          ],
                        ),
                        child: TextField(
                          controller: name,
                          style: TextStyle(color: Color(0xfffed0a9)),
                          decoration: InputDecoration(
                            prefixIcon: Icon(
                              Icons.person,
                              color: Color(0xfffed0a9),
                              size: 25,
                            ),
                            labelText: "Name",
                            labelStyle: GoogleFonts.afacad(
                              textStyle: TextStyle(
                                color: Color(0xfffed0a9),
                                fontWeight: FontWeight.normal,
                                fontSize: 25,
                              ),
                            ),
                            border: InputBorder.none,
                            // hintText: "Enter your name",
                            // hintStyle: TextStyle(color: Color(0xfffed0a9)),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 5),
                      child: Container(
                        height: 70,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Color(0xfffed0a9)),
                          color: Colors.black,
                          boxShadow: [
                            BoxShadow(
                              color: Color(0xfffed0a9),
                              blurRadius: 7,
                              offset: Offset.zero,
                              blurStyle: BlurStyle.solid,
                            ),
                          ],
                        ),
                        child: TextField(
                          controller: email,
                          style: TextStyle(color: Color(0xfffed0a9)),
                          decoration: InputDecoration(
                            prefixIcon: Icon(
                              Icons.email,
                              size: 25,
                              color: Color(0xfffed0a9),
                            ),
                            labelText: "Email",
                            labelStyle: GoogleFonts.afacad(
                              textStyle: TextStyle(
                                color: Color(0xfffed0a9),
                                fontWeight: FontWeight.normal,
                                fontSize: 25,
                              ),
                            ),
                            border: InputBorder.none,
                            // hintText: "Enter your email",
                            // hintStyle: TextStyle(color: Color(0xfffed0a9)),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 5),
                      child: Container(
                        height: 70,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Color(0xfffed0a9)),
                          color: Colors.black,
                          boxShadow: [
                            BoxShadow(
                              color: Color(0xfffed0a9),
                              blurRadius: 7,
                              offset: Offset.zero,
                              blurStyle: BlurStyle.solid,
                            ),
                          ],
                        ),
                        child: TextField(
                          controller: pass,
                          style: TextStyle(color: Color(0xfffed0a9)),
                          decoration: InputDecoration(
                            prefixIcon: Icon(
                              Icons.lock,
                              size: 25,
                              color: Color(0xfffed0a9),
                            ),
                            labelText: "Password",
                            labelStyle: GoogleFonts.afacad(
                              textStyle: TextStyle(
                                color: Color(0xfffed0a9),
                                fontWeight: FontWeight.normal,
                                fontSize: 25,
                              ),
                            ),
                            border: InputBorder.none,
                            // hintText: "Enter your password",
                            // hintStyle: TextStyle(color: Color(0xfffed0a9)),
                          ),
                          obscureText: true,
                        ),
                      ),
                    ),
                    SizedBox(height: 30),
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 5),
                        child: isLoadind2
                            ? CircularProgressIndicator(
                                color: const Color(0xfffed0a9),
                              )
                            : Container(
                                height: 70,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(color: Color(0xfffed0a9)),
                                  color: Color(0xfffed0a9),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Color(0xfffed0a9),
                                      blurRadius: 7,
                                      offset: Offset.zero,
                                      blurStyle: BlurStyle.solid,
                                    ),
                                  ],
                                ),
                                child: TextButton(
                                  onPressed: () async {
                                    setState(() {
                                      isLoadind2 = true;
                                    });
                                    try {
                                      await createUserWithEmailAndPassword(
                                          email.text, pass.text, context);
                                    } finally {
                                      setState(() {
                                        isLoadind2 = false;
                                      });
                                    }
                                  },
                                  child: Text(
                                    "Register",
                                    style: GoogleFonts.lato(
                                      textStyle: TextStyle(
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
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Divider(
                        color: Color(0xfffed0a9),
                        thickness: 2,
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        isLoadind
                            ? CircularProgressIndicator(
                                color: Color(0xfffed0a9),
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
                                  width: 150,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    border:
                                        Border.all(color: Color(0xfffed0a9)),
                                    color: Colors.black,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Color(0xfffed0a9),
                                        blurRadius: 7,
                                        offset: Offset.zero,
                                        blurStyle: BlurStyle.solid,
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(12.0),
                                        child: Image.asset(
                                          'assets/google.png',
                                        ),
                                      ),
                                      Text(
                                        "Google login",
                                        style:
                                            TextStyle(color: Color(0xfffed0a9)),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => phoneregi()));
                          },
                          child: Container(
                            height: 50,
                            width: 150,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: Color(0xfffed0a9)),
                              color: Colors.black,
                              boxShadow: [
                                BoxShadow(
                                  color: Color(0xfffed0a9),
                                  blurRadius: 7,
                                  offset: Offset.zero,
                                  blurStyle: BlurStyle.solid,
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Icon(
                                      Icons.phone,
                                      color: Color(0xfffed0a9),
                                    )),
                                Text(
                                  "phone login",
                                  style: TextStyle(color: Color(0xfffed0a9)),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
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
                                                loginpage())));
                                  },
                                text: ' login here',
                                style: const TextStyle(
                                    color: Color(0xfffed0a9),
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
