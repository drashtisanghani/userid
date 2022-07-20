import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:userid/view/viewprofile.dart';

import 'alluserprofile.dart';
import 'login.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  remove() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.remove("email");
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Center(
          child: Container(
            height: 60,
            width: 150,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ViewProfile(),
                  ),
                );
              },
              child: Text("View Profile"),
            ),
          ),
        ),
        SizedBox(height: 20),
        Center(
          child: Container(
            height: 60,
            width: 150,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AllUserProfile(),
                  ),
                );
              },
              child: Text("View All User"),
            ),
          ),
        ),
        SizedBox(height: 20),
        Center(
          child: Container(
            height: 60,
            width: 150,
            child: ElevatedButton(
              onPressed: () {
                remove();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Krishna(),
                  ),
                );
              },
              child: Text("logout"),
            ),
          ),
        ),
      ]),
    ));
  }
}
