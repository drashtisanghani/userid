import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import 'UserDetails.dart';

class AllUserProfile extends StatefulWidget {
  const AllUserProfile({Key? key}) : super(key: key);

  @override
  State<AllUserProfile> createState() => _AllUserProfileState();
}

class _AllUserProfileState extends State<AllUserProfile> {
  List<Map<String, dynamic>> data = [];
  final DatabaseReference registration =
      FirebaseDatabase.instance.ref('register');
  final FirebaseAuth auth = FirebaseAuth.instance;

  void getData() {
    registration.once().then((value) {
      var v = value.snapshot.value as Map<dynamic, dynamic>;
      for (var k in v.values) {
        data.add({
          "email": k["email"],
          "mobile no": k["mobile no"],
          "name": k["name"]
        });
        print(data);
        setState(() {});
      }
    });
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(children: [
        ListView.builder(
          shrinkWrap: true,
          itemCount: data.length,
          itemBuilder: (context, index) => GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => UserDetails(),
                ),
              );
            },
            child: ListTile(
              leading: CircleAvatar(),
              title: Text(data[index]["name"]),
              subtitle: Text(data[index]["email"]),
            ),
          ),
        ),
      ]),
    );
  }
}
