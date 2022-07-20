import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:image_picker/image_picker.dart';

class ViewProfile extends StatefulWidget {
  const ViewProfile({Key? key}) : super(key: key);

  @override
  State<ViewProfile> createState() => _ViewProfileState();
}

class _ViewProfileState extends State<ViewProfile> {
  Reference ref = FirebaseStorage.instance.ref("img").child("123");
  String imgUrl = "";
  ImagePicker imagePicker = ImagePicker();
  XFile? img;
  File? image;
  final _key = GlobalKey<FormBuilderState>();
  final DatabaseReference registration =
      FirebaseDatabase.instance.ref('register');
  final FirebaseAuth auth = FirebaseAuth.instance;
  bool dr = false;
  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController mobileno = TextEditingController();
  String namedata = "";
  String emaildata = "";
  String monodata = "";
  getImage() async {
    imgUrl = await ref.getDownloadURL();
    print(imgUrl);
    setState(() {});
  }

  uploadImage(File? image) async {
    await ref.child("123").putFile(image!);
  }

  void open() {
    showModalBottomSheet(
        context: context,
        builder: (context) => Container(
              height: 150,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Profile Photo",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 20),
                    Row(children: [
                      CircleAvatar(
                        radius: 30,
                        child: GestureDetector(
                            child: Icon(Icons.camera_alt),
                            onTap: () async {
                              img = await imagePicker.pickImage(
                                  source: ImageSource.camera);
                              if (img != null) {
                                setState(() {
                                  image = File(img!.path);
                                  uploadImage(image);
                                });
                              }
                            }),
                      ),
                      SizedBox(
                        width: 40,
                      ),
                      GestureDetector(
                        onTap: () async {
                          img = await imagePicker.pickImage(
                              source: ImageSource.gallery);
                          if (img != null) {
                            setState(() {
                              image = File(img!.path);
                              uploadImage(image);
                            });
                          }
                        },
                        child: CircleAvatar(
                          radius: 30,
                          child: Icon(Icons.image),
                        ),
                      )
                    ]),
                  ],
                ),
              ),
            ));
  }

  void getData() {
    registration
        .orderByChild("email")
        .equalTo(auth.currentUser?.email)
        .once()
        .then((value) {
      var v = value.snapshot.value as Map<dynamic, dynamic>;
      for (var val in v.values) {
        namedata = val["name"];
        emaildata = val["email"];
        monodata = val["mobile no"];
      }
      setState(() {
        name.text = namedata;
        email.text = emaildata;
        mobileno.text = monodata;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    getData();
    getImage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FormBuilder(
          key: _key,
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Column(children: [
              SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    iconSize: 30,
                    onPressed: () {
                      setState(() {
                        dr = (dr) ? false : true;
                      });
                    },
                    icon: (dr) ? Icon(Icons.close) : Icon(Icons.edit),
                    color: Colors.blueGrey,
                  ),
                ],
              ),
              SizedBox(height: 50),
              Stack(children: [
                (image == null)
                    ? CircleAvatar(
                        radius: 80,
                      )
                    : CircleAvatar(
                        radius: 80,
                        backgroundImage: FileImage(image!),
                      ),
                Padding(
                  padding: const EdgeInsets.only(left: 100, top: 120),
                  child: CircleAvatar(
                    radius: 20,
                    child: GestureDetector(
                      onTap: () {
                        open();
                      },
                      child: Icon(Icons.camera_alt_outlined),
                    ),
                  ),
                )
              ]),
              SizedBox(height: 30),
              (dr)
                  ? FormBuilderTextField(
                      name: 'name',
                      controller: name,
                      style: TextStyle(
                          color: Colors.blueGrey, fontWeight: FontWeight.bold),
                      decoration: InputDecoration(hintText: "Name"),
                    )
                  : Text(
                      namedata,
                      style: TextStyle(
                          color: Colors.blueGrey, fontWeight: FontWeight.bold),
                    ),
              SizedBox(
                height: 20,
              ),
              (dr)
                  ? FormBuilderTextField(
                      name: 'mobile no',
                      controller: mobileno,
                      style: TextStyle(
                          color: Colors.blueGrey, fontWeight: FontWeight.bold),
                      decoration: InputDecoration(hintText: "mono"),
                    )
                  : Text(
                      monodata,
                      style: TextStyle(
                          color: Colors.blueGrey, fontWeight: FontWeight.bold),
                    ),
              SizedBox(
                height: 20,
              ),
              (dr)
                  ? Container()
                  : Text(
                      emaildata,
                      style: TextStyle(
                          color: Colors.blueGrey, fontWeight: FontWeight.bold),
                    ),
              SizedBox(
                height: 20,
              ),
            ]),
          )),
    );
  }
}
