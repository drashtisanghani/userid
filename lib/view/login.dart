import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:userid/view/profile.dart';
import 'package:userid/view/registration.dart';

import 'forgot.dart';

class Krishna extends StatefulWidget {
  const Krishna({Key? key}) : super(key: key);

  @override
  State<Krishna> createState() => _KrishnaState();
}

class _KrishnaState extends State<Krishna> {
  TextEditingController email = TextEditingController();
  TextEditingController pass = TextEditingController();
  FirebaseAuth _auth = FirebaseAuth.instance;

  String error = "";
  String emailValid = "";
  String errorpass = "";
  bool hidden = true;

  setdata() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setString("email", "sucess");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(children: [
          SizedBox(
            height: 30,
          ),
          Center(
            child: Text(
              "WELCOME",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 40),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          TextField(
            onChanged: (val) {
              setState(() {
                emailValid = (!RegExp(
                            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                        .hasMatch(val))
                    ? "Please Enter Valid Email"
                    : "";
              });
            },
            controller: email,
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
                hintText: "Email",
                errorText: emailValid,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                prefixIcon: Icon(
                  Icons.email_outlined,
                  color: Colors.black,
                )),
          ),
          SizedBox(
            height: 10,
          ),
          TextField(
            obscureText: hidden,
            onChanged: (val) {
              setState(() {
                errorpass = (val.isEmpty) ? "please Enter Password" : "";
              });
            },
            controller: pass,
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              errorText: errorpass,
              hintText: "Password",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              prefixIcon: Icon(
                Icons.lock,
                color: Colors.black,
              ),
              suffixIcon: IconButton(
                onPressed: () {
                  setState(() {
                    hidden = !hidden;
                  });
                },
                icon: (hidden)
                    ? Icon(Icons.visibility_off)
                    : Icon(Icons.visibility),
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          TextButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ForgotPassword(),
                    ));
              },
              child: Text("Forgot Password?")),
          ElevatedButton(
            onPressed: () async {
              try {
                await _auth.signInWithEmailAndPassword(
                    email: email.text, password: pass.text);
              } catch (e) {
                error = e.toString();
              }

              setState(() {
                if (email.text.trim().isNotEmpty &&
                    pass.text.isNotEmpty &&
                    error == "") {
                  setdata();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Profile(),
                    ),
                  );
                } else if (error ==
                    "[firebase_auth/wrong-password] The password is invalid or the user does not have a password.") {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("invalid password"),
                    ),
                  );
                }
              });
            },
            child: Text("Login"),
          ),
          SizedBox(height: 10),
          TextButton(
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Registration(),
                  ),
                  (route) => false);
            },
            child: Text("create Account"),
          ),
        ]),
      ),
    );
  }
}
