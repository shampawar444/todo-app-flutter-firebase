import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:todo_app/screens/auth_form.dart';

class Authscreen extends StatefulWidget {
  const Authscreen({super.key});

  @override
  State<Authscreen> createState() => _AuthscreenState();
}

class _AuthscreenState extends State<Authscreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Athentication",
          style: GoogleFonts.roboto(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.grey[600],
      ),
      body: const AuthForm(),
    );
  }
}
