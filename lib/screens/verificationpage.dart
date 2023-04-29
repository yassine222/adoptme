import 'dart:async';

import 'package:adoptme/screens/home2.dart';
import 'package:adoptme/services/authservice.dart';
import 'package:adoptme/theme/theme_helper.dart';
import 'package:adoptme/widgets/header_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class VerificationPage extends StatefulWidget {
  const VerificationPage({Key? key}) : super(key: key);

  @override
  State<VerificationPage> createState() => _VerificationPageState();
}

class _VerificationPageState extends State<VerificationPage> {
  final double _headerHeight = 300;
  final _formKey = GlobalKey<FormState>();
  bool isEmailVerified = false;
  Timer? timer;
  final user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;

    if (!isEmailVerified) {
      AuthService().sendVerificationEmail();

      timer = Timer.periodic(
          const Duration(seconds: 3), (_) => checkEmailVerified());
    }
  }

  Future checkEmailVerified() async {
    await FirebaseAuth.instance.currentUser!.reload();

    setState(() {
      isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    });
    if (isEmailVerified) timer?.cancel();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => isEmailVerified
      ? const Home2()
      : Scaffold(
          backgroundColor: Colors.white,
          body: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: _headerHeight,
                  child: HeaderWidget(_headerHeight, true,
                      const AssetImage("assets/images/logo.png")),
                ),
                SafeArea(
                  child: Container(
                    margin: const EdgeInsets.fromLTRB(25, 10, 25, 10),
                    padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: Column(
                      children: [
                        Container(
                          alignment: Alignment.topLeft,
                          margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text(
                                'Verification',
                                style: TextStyle(
                                    fontSize: 35,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black54),
                                // textAlign: TextAlign.center,
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                'Click the verification link we just sent you on your email address.',
                                style: TextStyle(
                                    // fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black54),
                                // textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 40.0),
                        Form(
                          key: _formKey,
                          child: Column(
                            children: <Widget>[
                              Text(
                                user!.email.toString(),
                                style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black54),
                                // textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 50.0),
                              Text.rich(
                                TextSpan(
                                  children: [
                                    const TextSpan(
                                      text: "If you didn't receive a link! ",
                                      style: TextStyle(
                                        color: Colors.black38,
                                      ),
                                    ),
                                    TextSpan(
                                      text: 'Resend',
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () {
                                          AuthService().sendVerificationEmail();
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return ThemeHelper().alartDialog(
                                                  "Successful",
                                                  "Verification code resend successful.",
                                                  context);
                                            },
                                          );
                                        },
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.deepPurple),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 40.0),
                              Container(
                                decoration:
                                    ThemeHelper().buttonBoxDecoration(context),
                                child: ElevatedButton(
                                    style: ThemeHelper().buttonStyle(),
                                    onPressed: (() {
                                      AuthService().sendVerificationEmail();
                                    }),
                                    child: Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          40, 10, 40, 10),
                                      child: Text(
                                        "Verify".toUpperCase(),
                                        style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                    )),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ));
}
