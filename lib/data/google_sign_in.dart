import 'package:campusreads/Front/frontpage.dart';
import 'package:campusreads/data/selling_data.dart';
import 'package:campusreads/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';



class AuthService{
  User? user = FirebaseAuth.instance.currentUser;

  handleAuthState(){
    return StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (BuildContext context, snapshot) {
          if (snapshot.hasData ) {
            return FrontPage();
          } else {
            return Login();
          }
        });
  }

  static String? userName;

 Future<String?> getoldurl() async {
    var collection = FirebaseFirestore.instance.collection('personal_info');
    var docSnapshot = await collection.doc(user!.uid).get();

    Map<String, dynamic> data = docSnapshot.data()!;

    userName = data['photo'];

    return userName;
  }


  updateurl(String url) async{
    
    var collection = FirebaseFirestore.instance.collection('personal_info');
    final desertRef = FirebaseStorage.instance;
    
    final mp = collection.doc(user!.uid).get();

    String? oldurl = await getoldurl();
  
    await collection.doc(user!.uid).update({'photo' : url}).then((_) async{
      print('Success');
      await desertRef.refFromURL(oldurl!).delete();
      }).catchError((error) => print('Failed: $error'));
  }

  Future<bool> checkIfDocExists() async {
  try {
    var collectionRef = FirebaseFirestore.instance.collection('personal_info');
    var doc = await collectionRef.doc(user!.uid).get();
    
    return doc.exists;
    
  } catch (e) {
    throw e;
    
  }
}
 
  signInWithGoogle() async {
    GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    GoogleSignInAuthentication? _auth = await googleUser?.authentication;

    AuthCredential credential = GoogleAuthProvider.credential(
      idToken: _auth?.idToken,
      accessToken: _auth?.accessToken
    );

    UserCredential user =await FirebaseAuth.instance.signInWithCredential(credential);
    print(googleUser!.id);
  }



   //Sign out
  signOut() async{
    await GoogleSignIn().signOut();
    FirebaseAuth.instance.signOut();
  }


}