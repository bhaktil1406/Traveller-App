import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:tourist_app/pages/home.dart';
import 'package:tourist_app/pages/Homepage2.dart';
import 'package:tourist_app/pages/phoneregi.dart';

class loginpage extends StatefulWidget {
  @override
  State<loginpage> createState() => _loginpageState();
}

class _loginpageState extends State<loginpage> {
  TextEditingController email = new TextEditingController();
  TextEditingController pass = new TextEditingController();
  bool isLoadind = false;
  bool isLoadind2 = false;

  Future<User?> loginUserWithEmailAndPassword(
      String email, String password, BuildContext context) async {
    try {
      final cred = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      if (cred.user != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Homepage2()),
        );
      }
      return cred.user;
    } on FirebaseAuthException catch (e11) {
      if (e11.code == 'invalid-credential') {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
          "Incorrect credentials",
          style: TextStyle(color: Colors.red),
        )));
      }
      print(e11);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(41, 93, 93, 91),
      body: Stack(
        children: [
          Container(
            child: Image.asset(
              'assets/bc1.jpg',
            ),
          ),
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(colors: [
                Color.fromARGB(141, 0, 0, 0),
                Color.fromARGB(204, 0, 0, 0),
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
                          "Welcom back",
                          style: GoogleFonts.aboreto(
                            textStyle: const TextStyle(
                              fontSize: 50,
                              color: Color(0xfffed0a9),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
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
                            const BoxShadow(
                              color: Color(0xfffed0a9),
                              blurRadius: 7,
                              offset: Offset.zero,
                              blurStyle: BlurStyle.solid,
                            ),
                          ],
                        ),
                        child: TextField(
                          controller: email,
                          style: const TextStyle(color: Color(0xfffed0a9)),
                          decoration: InputDecoration(
                            prefixIcon: const Icon(
                              Icons.email,
                              size: 25,
                              color: Color(0xfffed0a9),
                            ),
                            labelText: "Email",
                            labelStyle: GoogleFonts.afacad(
                              textStyle: const TextStyle(
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
                    const SizedBox(height: 10),
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
                            const BoxShadow(
                              color: Color(0xfffed0a9),
                              blurRadius: 7,
                              offset: Offset.zero,
                              blurStyle: BlurStyle.solid,
                            ),
                          ],
                        ),
                        child: TextField(
                          controller: pass,
                          style: const TextStyle(color: Color(0xfffed0a9)),
                          decoration: InputDecoration(
                            prefixIcon: const Icon(
                              Icons.lock,
                              size: 25,
                              color: Color(0xfffed0a9),
                            ),
                            labelText: "Password",
                            labelStyle: GoogleFonts.afacad(
                              textStyle: const TextStyle(
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
                    const SizedBox(height: 30),
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
                                  border: Border.all(
                                      color: const Color(0xfffed0a9)),
                                  color: const Color(0xfffed0a9),
                                  boxShadow: [
                                    const BoxShadow(
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
                                      await loginUserWithEmailAndPassword(
                                          email.text, pass.text, context);
                                    } finally {
                                      setState(() {
                                        isLoadind2 = false;
                                      });
                                    }
                                  },
                                  child: Text(
                                    "Login",
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
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Divider(
                        color: Color(0xfffed0a9),
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
                                    border: Border.all(
                                        color: const Color(0xfffed0a9)),
                                    color: Colors.black,
                                    boxShadow: [
                                      const BoxShadow(
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
                                    builder: (context) => const phoneregi()));
                          },
                          child: Container(
                            height: 50,
                            width: 150,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              border:
                                  Border.all(color: const Color(0xfffed0a9)),
                              color: Colors.black,
                              boxShadow: [
                                const BoxShadow(
                                  color: Color(0xfffed0a9),
                                  blurRadius: 7,
                                  offset: Offset.zero,
                                  blurStyle: BlurStyle.solid,
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                const Padding(
                                    padding: EdgeInsets.all(12.0),
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
