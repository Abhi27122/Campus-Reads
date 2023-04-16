import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';

class Upload_data{
   User? user = FirebaseAuth.instance.currentUser;

  firebase_storage.FirebaseStorage storage = firebase_storage.FirebaseStorage.instance;

  File? photo;
  final ImagePicker _picker = ImagePicker();
  String url ="";

  bool check(){
    if(photo == null || url == ""){
      return false;
    }
    return true;
  }

  Future imgFromGallery() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery,imageQuality: 50);
      if (pickedFile != null) {
        photo = File(pickedFile.path);
        url = await uploadFile();
      } else {
        print('No image selected.');
      }
  }


   Future<String> uploadFile() async {
    if (photo == null) return "NULL";
    final fileName = basename(photo!.path);
    final destination = 'posts/$fileName';

    try {
      final ref = await firebase_storage.FirebaseStorage.instance
          .ref(destination)
          .child('posts/');
      await ref.putFile(photo!);
      String url = (await ref.getDownloadURL()).toString();
      return url;
      
    } catch (e) {
      return "Error";
    }
  }
}