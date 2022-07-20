import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'login.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({Key? key}) : super(key: key);

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  TextEditingController email = TextEditingController();
  FirebaseAuth _auth = FirebaseAuth.instance;
  String error = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(children: [
        SizedBox(
          height: 100,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 10),
          child: CircleAvatar(
            radius: 80,
            backgroundImage: AssetImage("img/key 2.jpg"),
          ),
        ),
        SizedBox(height: 40),
        Padding(
          padding: const EdgeInsets.only(left: 40),
          child: Text(
            "Yo! Forgot Your Password?",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 10),
          child: Text(
              "No worries! Enter your email and we will send you a reset."),
        ),
        SizedBox(height: 30),
        Padding(
          padding: const EdgeInsets.all(15.0),
          child: TextField(
            controller: email,
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.mail),
            ),
          ),
        ),
        SizedBox(height: 20),
        ElevatedButton(
          onPressed: () async {
            if (email.text.isNotEmpty) {
              try {
                await _auth.sendPasswordResetEmail(email: email.text);
              } catch (e) {
                error = e.toString();
              }
              if (error ==
                  "[firebase_auth/user-not-found] There is no user record corresponding to this identifier. The user may have been deleted.") {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("User not found"),
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("Chek your email"),
                  ),
                );
                Future.delayed(
                  Duration(seconds: 5),
                ).then(
                  (value) => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Krishna(),
                    ),
                  ),
                );
              }
            }
          },
          child: Text("Send Request"),
        ),
      ]),
    );
  }
}
