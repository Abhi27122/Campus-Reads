import 'dart:io';
import 'package:campusreads/data/google_sign_in.dart';
import 'package:campusreads/data/selling_data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';

class MyProfile extends StatefulWidget {
  MyProfile({Key? key}) : super(key: key);

  @override
  State<MyProfile> createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  User? user = FirebaseAuth.instance.currentUser;

  firebase_storage.FirebaseStorage storage = firebase_storage.FirebaseStorage.instance;

  File? _photo;
  final ImagePicker _picker = ImagePicker();

  Future imgFromGallery() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery,imageQuality: 50);

    setState(() async {
      if (pickedFile != null) {
        _photo = File(pickedFile.path);
        String url = await uploadFile();
        await AuthService().updateurl(url);
      } else {
        print('No image selected.');
      }
    });
  }

  Future imgFromCamera() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        _photo = File(pickedFile.path);
        uploadFile();
      } else {
        print('No image selected.');
      }
    });
  }

  Future<String> uploadFile() async {
    if (_photo == null) return "NULL";
    final fileName = basename(_photo!.path);
    final destination = 'files/$fileName';

    try {
      final ref = firebase_storage.FirebaseStorage.instance
          .ref(destination)
          .child('file/');
      await ref.putFile(_photo!);
      String url = (await ref.getDownloadURL()).toString();
      return url;
      
    } catch (e) {
      return "Error";
    }
  }

  @override
  Widget build(BuildContext context) {
  return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('personal_info').doc(user!.uid).snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(child:CircularProgressIndicator());
        }
        var pd = snapshot.data as DocumentSnapshot;
        return Scaffold(
      appBar: AppBar(title: Text("Profile Page")),
      backgroundColor: Colors.brown[100],
      body: Column(
        children: [
        Container(
          decoration: BoxDecoration(color: Colors.brown[100]),
          child: Column(
            children: [
              SizedBox(
            height: MediaQuery.of(context).size.height*(0.03),
          ),
         Padding(
          padding:  EdgeInsets.all(10),
          child:   CircleAvatar(
                radius: 80,
                backgroundColor: Colors.white,
                backgroundImage: NetworkImage(pd['photo']), //Text
                child: GestureDetector(onTap: () {
                   imgFromGallery();
                } ),
              ),
        ),

        Container(
          padding: EdgeInsets.symmetric(),
          child: TextButton(
            child:Text(pd['Full Name'],style: TextStyle(fontSize: 30,color: Colors.brown)),
            onPressed: (){}
            )
          ),

        Container(
          padding: EdgeInsets.symmetric(),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.phone),
              TextButton(
                child:Text(pd['phone'],style: TextStyle(fontSize: 25,color: Colors.brown)),
                onPressed: (){}
                ),
            ],
          )
        ),
        Container(
          padding: EdgeInsets.symmetric(),
          child:Text(pd['Email'],style: TextStyle(fontSize: 20,color: Colors.brown)),
          ),
       ],
          ),
        ),
      ]),
      );
      }
  );
}
}



