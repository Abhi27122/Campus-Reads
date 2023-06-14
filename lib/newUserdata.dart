import 'package:campusreads/data/google_sign_in.dart';
import 'package:campusreads/data/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';


class AddUser extends StatelessWidget {
  final User? user = FirebaseAuth.instance.currentUser;
  AddUser();

  TextEditingController name = new TextEditingController();
  TextEditingController contact_info = new TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    //  //height: 756.0 width: 360.0

    return Scaffold(
      backgroundColor: Color.fromARGB(255, 227, 218, 167),
      body: SingleChildScrollView(
        physics: ClampingScrollPhysics(parent: NeverScrollableScrollPhysics()),
        child: Center(
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.fromLTRB(width*0.055, height*0.1322, width*0.055, height*0.09259),
                            child: Text("Looks Like you are New User!",style: TextStyle(fontSize: 40,color: Colors.grey),)
                          ),
                          Container(
                            padding: EdgeInsets.fromLTRB(width*0.05, height*0.0264, width*0.05, 0),
                            child: TextFormField(
                              controller: name,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.yellow, width: 0.0),
                                  borderRadius: BorderRadius.circular(90.0),
                                ),
                                labelText: 'Full Name',
                              ),
                              validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Name cannot be empty';
                                  }
                                },
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.fromLTRB(width*0.05, height*0.0264, width*0.05, 0),
                            child: TextFormField(
                              controller: contact_info,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(90.0),
                                ),
                                labelText: 'WhatsApp Number',
                              ),
                              validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Number cannot be empty';
                                  }
                                },
                            ),
                          ),
                          Container(
                              height: 80,
                              padding: EdgeInsets.fromLTRB(width*0.05, height*0.0264, width*0.05, height*0.0264),
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(90.0)
                                  ),
                                  minimumSize: const Size.fromHeight(50),
                                ),
                                child: const Text('Sign Up with google'),
                                onPressed: () async{
                                  if(_formKey.currentState!.validate()){
                                      
                                      UserModel us =  UserModel(user?.uid, name.text , user?.email, contact_info.text,user?.photoURL);
                                      Map<String, dynamic> userdata = us.toJson();
                                  
                                      CollectionReference collref = FirebaseFirestore.instance.collection("personal_info");
                    
                                      await collref.doc(user!.uid).set(userdata);
                                  }
                                },
                              )),
                          
                            ],
                          ),
                    ),
              ),
      ),
    );
  }
}