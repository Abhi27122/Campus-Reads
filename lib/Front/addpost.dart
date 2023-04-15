import 'dart:io';

import 'package:campusreads/data/selling_data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';

import '../data/google_sign_in.dart';

class AddPost extends StatefulWidget {
  AddPost({super.key});

  @override
  State<AddPost> createState() => _AddPostState();
}

class _AddPostState extends State<AddPost> {
  TextEditingController name = new TextEditingController();
  TextEditingController price = new TextEditingController();
   final GlobalKey<FormState> _formKey = GlobalKey();

  User? user = FirebaseAuth.instance.currentUser;

  firebase_storage.FirebaseStorage storage = firebase_storage.FirebaseStorage.instance;

  File? _photo;
  final ImagePicker _picker = ImagePicker();
  String url ="";

  Future imgFromGallery() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery,imageQuality: 50);

    setState(() async {
      if (pickedFile != null) {
        _photo = File(pickedFile.path);
        url = await uploadFile();
      } else {
        print('No image selected.');
      }
    });
  }

   Future<String> uploadFile() async {
    if (_photo == null) return "NULL";
    final fileName = basename(_photo!.path);
    final destination = 'posts/$fileName';

    try {
      final ref = await firebase_storage.FirebaseStorage.instance
          .ref(destination)
          .child('posts/');
      await ref.putFile(_photo!);
      String url = (await ref.getDownloadURL()).toString();
      return url;
      
    } catch (e) {
      return "Error";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 227, 218, 167),
      appBar: AppBar(title: Text("Add post"),),
      body: Column(
          children: <Widget>[
            Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: TextFormField(
                      controller: name,
                      decoration: const InputDecoration(
                          labelText: 'Name',
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(20.0)),
                            borderSide:
                                BorderSide(color: Colors.grey, width: 0.0),
                          ),
                          border: OutlineInputBorder()),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Name cannot be empty';
                        }
                      },
                    ),
                  ),
                  
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: TextFormField(
                      controller: price,
                      decoration: const InputDecoration(
                          labelText: 'Price',
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(20.0)),
                            borderSide:
                                BorderSide(color: Colors.grey, width: 0.0),
                          ),
                          border: OutlineInputBorder()),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Field can not be empty';
                        }
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20.0))),
                          minimumSize: Size(100, 40),
                          fixedSize: const Size.fromWidth(20)
                          ),
                      onPressed: () {
                        imgFromGallery();
                      },
                      child: const Text("Add Image"),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20.0))),
                          minimumSize: Size(100, 40),
                          fixedSize: const Size.fromWidth(20)
                          ),
                      onPressed: () async{
                        // Validate returns true if the form is valid, or false otherwise.
                        if (_formKey.currentState!.validate() && _photo != null && url != "") {
                          Selling_data us =  Selling_data(name.text, price.text, DateTime.now(), user!.uid,url);
                          Map<String, dynamic> posts = us.toJson();
                          CollectionReference collref = FirebaseFirestore.instance.collection("products");
                          await collref.doc().set(posts);
                          Navigator.of(context).pop();
                        }
                        else{
                          showDialog(context: context, builder: (ctx)=> AlertDialog(title: Text("Please try again"),));
                        }
                      },
                      child: const Text("Submit"),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
    );
  }
}