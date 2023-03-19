import 'package:campusreads/Front/frontpage.dart';
import 'package:campusreads/data/selling_data.dart';
import 'package:campusreads/main.dart';
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

  Profile_data getdata() {
    User? user = FirebaseAuth.instance.currentUser;
    final String? name = user?.displayName;
    final String? email = user?.email;
    final String? photo = user?.photoURL;

    Profile_data pd = Profile_data(name, email, photo);

    return pd;
  }

  signInWithGoogle() async {
    GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    GoogleSignInAuthentication? _auth = await googleUser?.authentication;

    AuthCredential credential = GoogleAuthProvider.credential(
      idToken: _auth?.idToken,
      accessToken: _auth?.accessToken
    );

    UserCredential user =await FirebaseAuth.instance.signInWithCredential(credential);
  }

   //Sign out
  signOut() async{
    await GoogleSignIn().signOut();
    FirebaseAuth.instance.signOut();
  }


}