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
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery,imageQuality:30);

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
    final destination = '${user!.uid}/$fileName';

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
         Container(
          padding:  EdgeInsets.only(top: 20),
          child:   Stack(
            children: [
              CircleAvatar(
                    radius: 70,
                    backgroundColor: Colors.white,
                    backgroundImage: 
                    NetworkImage(pd['photo']),
                  ),
                  Positioned(
              bottom: 0,
              right: -25,
              child: RawMaterialButton(
                onPressed: () async{
                  await imgFromGallery();
                },
                elevation: 2.0,
                fillColor: Color(0xFFF5F6F9),
                child: Icon(Icons.camera_alt_outlined, color: Colors.blue,),
                shape: CircleBorder(),
              )),
            ],
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



