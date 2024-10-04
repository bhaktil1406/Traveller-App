import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pinput/pinput.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tourist_app/pages/phoneregi.dart';

class otp extends StatefulWidget {
  const otp({super.key});

  @override
  State<otp> createState() => _otpState();
}

class _otpState extends State<otp> {
  TextEditingController countryController = TextEditingController();
  final FirebaseAuth auth = FirebaseAuth.instance;

  @override
  void initState() {
    // TODO: implement initState
    countryController.text = "+91";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 56,
      height: 56,
      textStyle: TextStyle(
          fontSize: 20, color: Color(0xfffed0a9), fontWeight: FontWeight.w600),
      decoration: BoxDecoration(
        border: Border.all(color: Color(0xfffed0a9)),
        borderRadius: BorderRadius.circular(20),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border.all(color: Color(0xfffed0a9)),
      borderRadius: BorderRadius.circular(8),
    );

    final submittedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration?.copyWith(
        color: Colors.black,
      ),
    );
    var code = "";
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
                          "Enter OTP here",
                          style: GoogleFonts.aboreto(
                            textStyle: TextStyle(
                              fontSize: 40,
                              color: Color(0xfffed0a9),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 30),
                    Pinput(
                      length: 6,
                      defaultPinTheme: defaultPinTheme,
                      focusedPinTheme: focusedPinTheme,
                      submittedPinTheme: submittedPinTheme,
                      showCursor: true,
                      onChanged: (value) {
                        code = value;
                      },
                      onCompleted: (pin) => print(pin),
                    ),
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
                              try {
                                // Create a PhoneAuthCredential with the code
                                PhoneAuthCredential credential =
                                    PhoneAuthProvider.credential(
                                        verificationId: phoneregi.verify,
                                        smsCode: code);

                                // Sign the user in (or link) with the credential
                                await auth.signInWithCredential(credential);
                                Navigator.pushNamedAndRemoveUntil(
                                    context, "home", (route) => false);
                              } catch (e) {
                                print(e);
                                print("Wrong otp ${e}");
                              }
                            },
                            child: Text(
                              "Verify OTP",
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
                    SizedBox(
                      height: 30,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          height: 50,
                          width: 50,
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
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Image.asset(
                              'assets/google.png',
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
                                // recognizer: TapGestureRecognizer()
                                // ..onTap = () {
                                //   Navigator.push(
                                //       context,
                                //       MaterialPageRoute(
                                //           builder: ((context) => login())));
                                // },
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
