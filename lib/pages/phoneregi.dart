import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:tourist_app/pages/home.dart';
import 'package:tourist_app/pages/loginpage.dart';
import 'package:tourist_app/pages/otp.dart';

class phoneregi extends StatefulWidget {
  const phoneregi({super.key});

  static String verify = "";

  @override
  State<phoneregi> createState() => _phoneregiState();
}

class _phoneregiState extends State<phoneregi> {
  TextEditingController countryController = TextEditingController();
  var phone = "";
  bool isLoading = false;

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
          MaterialPageRoute(builder: (context) => const homepage()),
        );
      }
      return userCredential;
    } catch (e) {
      print(e.toString());
    }
    return null;
  }

  @override
  void initState() {
    // TODO: implement initState
    countryController.text = "+91";
    super.initState();
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
                        height: 55,
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
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 10,
                            ),
                            SizedBox(
                              width: 40,
                              child: TextField(
                                style: TextStyle(color: Color(0xfffed0a9)),
                                controller: countryController,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                            Text(
                              "|",
                              style: TextStyle(
                                  fontSize: 33, color: Color(0xfffed0a9)),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Expanded(
                                child: TextField(
                              onChanged: (val) {
                                phone = val;
                              },
                              style: TextStyle(color: Color(0xfffed0a9)),
                              keyboardType: TextInputType.phone,
                              decoration: InputDecoration(
                                // prefixIcon: Icon(
                                //   Icons.person,
                                //   color: Color(0xfffed0a9),
                                //   size: 25,
                                // ),
                                labelText: "Mobile no",
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
                            ))
                          ],
                        ),
                      ),
                    ),
                    // Padding(
                    //   padding: const EdgeInsets.symmetric(
                    //       horizontal: 20, vertical: 5),
                    //   child: Container(
                    //     height: 70,
                    //     decoration: BoxDecoration(
                    //       borderRadius: BorderRadius.circular(20),
                    //       border: Border.all(color: Color(0xfffed0a9)),
                    //       color: Colors.black,
                    //       boxShadow: [
                    //         BoxShadow(
                    //           color: Color(0xfffed0a9),
                    //           blurRadius: 7,
                    //           offset: Offset.zero,
                    //           blurStyle: BlurStyle.solid,
                    //         ),
                    //       ],
                    //     ),
                    //     child: Row(
                    //       children: [
                    //         TextField(
                    //           style: TextStyle(color: Color(0xfffed0a9)),
                    //           decoration: InputDecoration(
                    //             prefixIcon: Icon(
                    //               Icons.phone,
                    //               size: 25,
                    //               color: Color(0xfffed0a9),
                    //             ),
                    //             labelText: "Mobile no",
                    //             labelStyle: GoogleFonts.afacad(
                    //               textStyle: TextStyle(
                    //                 color: Color(0xfffed0a9),
                    //                 fontWeight: FontWeight.normal,
                    //                 fontSize: 25,
                    //               ),
                    //             ),
                    //             border: InputBorder.none,
                    //             // hintText: "Enter your email",
                    //             // hintStyle: TextStyle(color: Color(0xfffed0a9)),
                    //           ),
                    //         ),
                    //       ],
                    //     ),
                    //   ),
                    // ),
                    // SizedBox(height: 10),
                    // Padding(
                    //   padding: const EdgeInsets.symmetric(
                    //       horizontal: 20, vertical: 5),
                    //   child: Container(
                    //     height: 70,
                    //     decoration: BoxDecoration(
                    //       borderRadius: BorderRadius.circular(20),
                    //       border: Border.all(color: Color(0xfffed0a9)),
                    //       color: Colors.black,
                    //       boxShadow: [
                    //         BoxShadow(
                    //           color: Color(0xfffed0a9),
                    //           blurRadius: 7,
                    //           offset: Offset.zero,
                    //           blurStyle: BlurStyle.solid,
                    //         ),
                    //       ],
                    //     ),
                    //     child: TextField(
                    //       style: TextStyle(color: Color(0xfffed0a9)),
                    //       decoration: InputDecoration(
                    //         prefixIcon: Icon(
                    //           Icons.lock,
                    //           size: 25,
                    //           color: Color(0xfffed0a9),
                    //         ),
                    //         labelText: "Password",
                    //         labelStyle: GoogleFonts.afacad(
                    //           textStyle: TextStyle(
                    //             color: Color(0xfffed0a9),
                    //             fontWeight: FontWeight.normal,
                    //             fontSize: 25,
                    //           ),
                    //         ),
                    //         border: InputBorder.none,
                    //         // hintText: "Enter your password",
                    //         // hintStyle: TextStyle(color: Color(0xfffed0a9)),
                    //       ),
                    //       obscureText: true,
                    //     ),
                    //   ),
                    // ),
                    SizedBox(height: 30),
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 5),
                        child: Container(
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
                              await FirebaseAuth.instance.verifyPhoneNumber(
                                phoneNumber:
                                    '${countryController.text + phone}',
                                verificationCompleted:
                                    (PhoneAuthCredential credential) {},
                                verificationFailed:
                                    (FirebaseAuthException e) {},
                                codeSent:
                                    (String verificationId, int? resendToken) {
                                  phoneregi.verify = verificationId;
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => otp()));
                                },
                                codeAutoRetrievalTimeout:
                                    (String verificationId) {},
                              );
                              // Navigator.push(
                              //     context,
                              //     MaterialPageRoute(
                              //         builder: (context) => otp()));
                            },
                            child: Text(
                              "Send the code",
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
                        GestureDetector(
                          onTap: () async {
                            setState(() {
                              isLoading = true;
                            });
                            await loginWithGoogle();
                            setState(() {
                              isLoading = false;
                            });
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
                                  child: Image.asset(
                                    'assets/google.png',
                                  ),
                                ),
                                Text(
                                  "Google login",
                                  style: TextStyle(color: Color(0xfffed0a9)),
                                ),
                              ],
                            ),
                          ),
                        ),
                        // Container(
                        //   height: 50,
                        //   width: 50,
                        //   decoration: BoxDecoration(
                        //     borderRadius: BorderRadius.circular(20),
                        //     border: Border.all(color: Color(0xfffed0a9)),
                        //     color: Colors.black,
                        //     boxShadow: [
                        //       BoxShadow(
                        //         color: Color(0xfffed0a9),
                        //         blurRadius: 7,
                        //         offset: Offset.zero,
                        //         blurStyle: BlurStyle.solid,
                        //       ),
                        //     ],
                        //   ),
                        //   child: Padding(
                        //       padding: const EdgeInsets.all(12.0),
                        //       child: Icon(
                        //         Icons.phone,
                        //         color: Color(0xfffed0a9),
                        //       )),
                        // ),
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
