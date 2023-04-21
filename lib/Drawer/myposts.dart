import 'package:campusreads/data/selling_data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../data/google_sign_in.dart';



class MyPosts extends StatelessWidget {
  MyPosts({Key? key}) : super(key: key);
  final CollectionReference _products = FirebaseFirestore.instance.collection('products'); 
  final desertRef = FirebaseStorage.instance;

  User? user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 227, 218, 167),
      appBar: AppBar(title: Text("Your Posts"), backgroundColor: Color.fromARGB(255, 146, 81, 16),
      ),
      body: StreamBuilder(
        stream: _products.where("userId", isEqualTo:  user!.uid).snapshots(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> streamSnapshot) { 
          if(streamSnapshot.hasData){
            return ListView.builder(
                      itemCount: streamSnapshot.data!.docs.length,
                      itemBuilder: (BuildContext context, int index) {
                         final DocumentSnapshot documentSnapshot = streamSnapshot.data!.docs[index];
                      return Padding(
                            padding: EdgeInsets.all(5),
                            child: GestureDetector(
                                child: Card(
                                shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                                //set border radius more than 50% of height and width to make circle
                                ),
                                color: const Color.fromARGB(255, 244, 176, 113),
                                child: Column(
                                  children: [
                                    ListTile(
                                      leading: IconButton(onPressed: () async{
                                        showDialog(context: context, builder: (ctx)=> AlertDialog(
                                          title: Text("Are you sure you want to delete this items"),
                                          content: ElevatedButton(onPressed: () async{
                                              await desertRef.refFromURL(documentSnapshot['image']).delete();
                                              await _products.doc(documentSnapshot.id).delete();
                                              Navigator.pop(context);
                                          }, 
                                          child: Text("Confirm!")),
                                        ));
                                      }, icon: Icon(Icons.delete)),
                                      title: Text(documentSnapshot['Name'],style: TextStyle(fontSize: 20),),
                                      subtitle: Text(timeago.format(documentSnapshot['Date'].toDate()),style:TextStyle(fontSize: 15)),
                                      trailing: Text( '₹${documentSnapshot['price']}',style:TextStyle(fontSize: 20)),
                                          ),
                                        ],
                                      ),  
                                    ),
                                  ),
                                );
                              },
                            );
          }
          else{
            return Center(child:CircularProgressIndicator());
          }
         },),
    );
  }
}