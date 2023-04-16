import 'package:campusreads/Front/frontpage.dart';
import 'package:campusreads/data/selling_data.dart';
import 'package:campusreads/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';



class AuthService{
  handleAuthState() {
    return StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (BuildContext context, snapshot) {
          if (snapshot.hasData) {
            return FrontPage();
          } else {
            return Login();
          }
        });
  }


  updateurl(String url) async{
    User? user = FirebaseAuth.instance.currentUser;
    var collection = FirebaseFirestore.instance.collection('personal_info');
    await collection.doc(user!.uid).update({'photo' : url}).then((_) => print('Success')).catchError((error) => print('Failed: $error'));
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