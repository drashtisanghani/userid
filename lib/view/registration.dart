import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'login.dart';

class Registration extends StatefulWidget {
  const Registration({Key? key}) : super(key: key);

  @override
  State<Registration> createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration> {
  DatabaseReference _register = FirebaseDatabase.instance.ref("register");
  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController pass = TextEditingController();
  TextEditingController number = TextEditingController();
  FirebaseAuth _auth = FirebaseAuth.instance;
  String error = "";
  String gender = "gender";
  String male = "male";
  String female = "female";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("User Registration"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(children: [
          TextField(
            controller: name,
            decoration: InputDecoration(labelText: "Name"),
          ),
          SizedBox(height: 10),
          TextField(
            controller: email,
            decoration: InputDecoration(labelText: "Email"),
          ),
          SizedBox(height: 10),
          TextField(
            controller: pass,
            decoration: InputDecoration(labelText: "Password"),
          ),
          SizedBox(height: 10),
          TextField(
            controller: number,
            decoration: InputDecoration(labelText: "Mobile no."),
          ),
          SizedBox(height: 10),
          Row(
            children: [
              Radio(
                  value: female,
                  groupValue: gender,
                  onChanged: (val) {
                    setState(() {
                      gender = female;
                    });
                  }),
              Text("female"),
              Radio(
                  value: male,
                  groupValue: gender,
                  onChanged: (val) {
                    setState(() {
                      gender = male;
                    });
                  }),
              Text("male"),
            ],
          ),
          ElevatedButton(
            onPressed: () async {
              try {
                await _auth.createUserWithEmailAndPassword(
                    email: email.text, password: pass.text);
              } catch (e) {
                error = e.toString();
              }
              if (error == "") {
                _register.push().set({
                  "name": name.text,
                  "email": email.text,
                  "mobile no": number.text,
                  "gender": gender,
                  "uid": _auth.currentUser?.uid,
                  "img": ""
                });
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Krishna(),
                    ),
                    (route) => false);
              } else if (error ==
                  "[firebase_auth/email-already-in-use] The email address is already in use by another account.") {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(error),
                  ),
                );
              }
            },
            child: Text("Registration"),
          ),
          TextButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Krishna(),
                  ));
            },
            child: Text("Login?"),
          ),
        ]),
      ),
    );
  }
}
