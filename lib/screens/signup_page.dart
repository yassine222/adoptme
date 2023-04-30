import 'package:adoptme/services/authservice.dart';
import 'package:adoptme/theme/theme_helper.dart';
import 'package:adoptme/widgets/header_widget.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'login_page.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({Key? key}) : super(key: key);

  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final double _headerHeight = 250;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController userNameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController adresseController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);

        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: _headerHeight,
                child: HeaderWidget(
                    _headerHeight,
                    true,
                    const AssetImage(
                        "assets/images/logo.png")), //let's create a common header widget
              ),
              Container(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
                  margin: const EdgeInsets.fromLTRB(
                      20, 0, 20, 10), // This will be the login form
                  child: Column(
                    children: [
                      const Text(
                        'Hello',
                        style: TextStyle(
                            fontSize: 60, fontWeight: FontWeight.bold),
                      ),
                      // ignore: prefer_const_constructors
                      Text(
                        'Create a new account',
                        style: const TextStyle(color: Colors.grey),
                      ),
                      const SizedBox(height: 20.0),
                      Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              Container(
                                decoration:
                                    ThemeHelper().inputBoxDecorationShaddow(),
                                child: TextFormField(
                                  keyboardType: TextInputType.text,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'username field must not be empty';
                                    }
                                    return null;
                                  },
                                  controller: userNameController,
                                  decoration: ThemeHelper().textInputDecoration(
                                      'User Name', 'Enter your user name'),
                                ),
                              ),
                              const SizedBox(height: 20.0),
                              Container(
                                decoration:
                                    ThemeHelper().inputBoxDecorationShaddow(),
                                child: TextFormField(
                                  keyboardType: TextInputType.phone,
                                  maxLength: 8,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Phone field must not be empty';
                                    }
                                    return null;
                                  },
                                  controller: phoneController,
                                  decoration: ThemeHelper().textInputDecoration(
                                      'Phone Number',
                                      'Enter your phone number'),
                                ),
                              ),
                              const SizedBox(height: 20.0),
                              Container(
                                decoration:
                                    ThemeHelper().inputBoxDecorationShaddow(),
                                child: TextFormField(
                                  keyboardType: TextInputType.emailAddress,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'email field must not be empty';
                                    }
                                    return null;
                                  },
                                  controller: emailController,
                                  decoration: ThemeHelper().textInputDecoration(
                                      'Email', 'Enter your email'),
                                ),
                              ),
                              const SizedBox(height: 20.0),
                              Container(
                                decoration:
                                    ThemeHelper().inputBoxDecorationShaddow(),
                                child: TextFormField(
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'password field must not be empty';
                                    }
                                    return null;
                                  },
                                  controller: passwordController,
                                  obscureText: true,
                                  decoration: ThemeHelper().textInputDecoration(
                                      'Password', 'Enter your password'),
                                ),
                              ),
                              const SizedBox(height: 20.0),
                              Container(
                                decoration:
                                    ThemeHelper().inputBoxDecorationShaddow(),
                                child: TextFormField(
                                  controller: confirmPasswordController,
                                  obscureText: true,
                                  decoration: ThemeHelper().textInputDecoration(
                                      "Confirm Password*",
                                      "Enter your password"),
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Confirm your password';
                                    }
                                    if (value != passwordController.text) {
                                      return 'Password not Match';
                                    }

                                    return null;
                                  },
                                ),
                              ),
                              const SizedBox(height: 30.0),
                              Container(
                                decoration:
                                    ThemeHelper().buttonBoxDecoration(context),
                                child: ElevatedButton(
                                  style: ThemeHelper().buttonStyle(),
                                  child: Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        40, 10, 40, 10),
                                    child: Text(
                                      'Sign Up'.toUpperCase(),
                                      style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                    ),
                                  ),
                                  onPressed: () {
                                    if (_formKey.currentState!.validate()) {
                                      AuthService().SignUp(
                                        context,
                                        emailController.text.trim(),
                                        passwordController.text.trim(),
                                        userNameController.text.trim(),
                                        phoneController.text.trim(),
                                      );
                                    }
                                  },
                                ),
                              ),
                              Container(
                                margin:
                                    const EdgeInsets.fromLTRB(10, 20, 10, 20),
                                //child: Text('Don\'t have an account? Create'),
                                child: Text.rich(TextSpan(children: [
                                  const TextSpan(
                                      text: "Already have an account? "),
                                  TextSpan(
                                    text: 'Login',
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    const LoginPage()));
                                      },
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary),
                                  ),
                                ])),
                              ),
                            ],
                          )),
                    ],
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
