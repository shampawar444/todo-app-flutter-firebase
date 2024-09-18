import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class AuthForm extends StatefulWidget {
  const AuthForm({super.key});

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  var _email = '';
  var _password = '';
  var _username = '';
  bool _isLogin = true; // this is the login state

  startAuthentication() async {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();

    if (isValid) {
      _formKey.currentState!.save();
      submitForm(_email, _password, _username);
    }
  }

  submitForm(String email, String password, String username) async {
    final auth = FirebaseAuth.instance;
    UserCredential authResult;

    try {
      if (_isLogin) {
        authResult = await auth.signInWithEmailAndPassword(
            email: email, password: password);
      } else {
        authResult = await auth.createUserWithEmailAndPassword(
            email: email, password: password);
        String uid = authResult.user!.uid;
        await FirebaseFirestore.instance
            .collection('users')
            .doc(uid)
            .set({'username': username, 'email': email});
      }
    } catch (err) {
      print(err);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      const SizedBox(height: 100),
                      TextFormField(
                        validator: (value) {
                          if (value!.isEmpty || !value.contains('@')) {
                            return "Please enter a valid email address";
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _email = value!;
                        },
                        key: const ValueKey('email'),
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                            labelText: "Email",
                            hintText: "Enter your email",
                            labelStyle: GoogleFonts.roboto(),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10))),
                      ),
                      if (!_isLogin)
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: TextFormField(
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Please enter a valid username";
                              }
                              return null;
                            },
                            onSaved: (value) {
                              _username = value!;
                            },
                            key: const ValueKey('username'),
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                                labelText: "Username",
                                hintText: "Enter your username",
                                labelStyle: GoogleFonts.roboto(),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10))),
                          ),
                        ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        obscureText: true,
                        validator: (value) {
                          if (value!.isEmpty || value.length < 7) {
                            return "Please enter a valid password";
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _password = value!;
                        },
                        key: const ValueKey('password'),
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                            labelText: "Password",
                            hintText: "Enter your password",
                            labelStyle: GoogleFonts.roboto(),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10))),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                        height: 60,
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            startAuthentication();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey[600],
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Text(
                            _isLogin ? 'Login' : 'Sign Up',
                            style: GoogleFonts.roboto(
                                color: Colors.white, fontSize: 18),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextButton(
                          onPressed: () {
                            setState(() {
                              _isLogin = !_isLogin;
                            });
                          },
                          child: Text(
                            _isLogin
                                ? 'Create an account'
                                : 'Already have an account',
                            style: GoogleFonts.roboto(
                                color: Colors.blue, fontSize: 18),
                          ))
                    ],
                  )),
            )
          ],
        ),
      ),
    );
  }
}
