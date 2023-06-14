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

  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;

  File? _photo;
  final ImagePicker _picker = ImagePicker();

  Future imgFromGallery() async {
    final pickedFile =
        await _picker.pickImage(source: ImageSource.gallery, imageQuality: 30);

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
    try{
      final pickedFile = await _picker.pickImage(source: ImageSource.camera,imageQuality: 30);
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
    catch(e){
      return;
    }
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


   Future showAlertDialog(BuildContext context) async{

  // set up the buttons
  Widget GalleryButton = TextButton(
    child: Text("pick image from gallery"),
    onPressed:  () async {
      await imgFromGallery();
    },
  );
  Widget ImageButton = TextButton(
    child: Text("pick image from camera"),
    onPressed:  () async {
      await imgFromCamera();
    },
  );
  Widget Done = TextButton(
    child: Text("Done"),
    onPressed:  () async {
      Navigator.of(context).pop();
    },
  );
  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text("Select image"),
    actions: [
      GalleryButton,
      ImageButton,
      Done
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('personal_info')
            .doc(user!.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }
          var pd = snapshot.data as DocumentSnapshot;
          return Scaffold(
            appBar: AppBar(title: Text("Profile Page")),
            backgroundColor: Colors.brown[100],
            body: Column(
        children: [
         Expanded(
          flex: 2, 
          child: Stack(
      fit: StackFit.expand,
      children: [
        Container(
          margin: const EdgeInsets.only(bottom: 50),
          decoration: const BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [ Color.fromARGB(255, 252, 223, 202),Color.fromARGB(255, 250, 194, 139)]),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(50),
                bottomRight: Radius.circular(50),
              )),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: SizedBox(
            width: 150,
            height: 150,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.black,
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        fit: BoxFit.cover,
                        image: NetworkImage(
                            pd['photo'])),
                  ),
                ),
                Positioned(
              bottom: 0,
              right: -25,
              child: RawMaterialButton(
                onPressed: () async{
                  await showAlertDialog(context);
                },
                elevation: 2.0,
                fillColor: Color(0xFFF5F6F9),
                child: Icon(Icons.camera_alt_outlined, color: Colors.blue,),
                shape: CircleBorder(),
              )),
              ],
            ),
          ),
        )
      ],
    )
          
          ),
          Expanded(
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Text(
                    pd["Full Name"],
                    style: Theme.of(context)
                        .textTheme
                        .headline6
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  buildUserInfoDisplay(pd["Full Name"], "Name"),
                  buildUserInfoDisplay(pd["phone"], "Phone"),
                  buildUserInfoDisplay(pd["Email"], "Email")
                ],
              ),
            ),
          ),
          
        ],
      ),
          );
        });
  }
}



  Widget buildUserInfoDisplay(String getValue, String title) =>
      Padding(
          padding: EdgeInsets.only(bottom: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey,
                ),
              ),
              SizedBox(
                height: 1,
              ),
              Container(
                  width: 350,
                  height: 40,
                  decoration: BoxDecoration(
                      border: Border(
                          bottom: BorderSide(
                    color: Colors.grey,
                    width: 1,
                  ))),
                  child: Row(children: [
                    Expanded(
                        child:Text(
                              getValue,
                              style: TextStyle(fontSize: 16, height: 1.4),
                            )),
                    
                  ]))
            ],
          ));