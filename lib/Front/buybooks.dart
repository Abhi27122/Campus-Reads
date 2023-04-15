import 'package:campusreads/Front/chatscreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class BuyThis extends StatelessWidget{

  FirebaseFirestore db = FirebaseFirestore.instance;

  BuyThis(this.user_id,this.info,this.img);

  String? user_id;
  Image? img;
  String? info;


  Widget getWidget(BuildContext context) {
    CollectionReference userInfo = FirebaseFirestore.instance.collection('personal_info');

    return FutureBuilder<DocumentSnapshot>(
      //Fetching data from the user_id specified of the user
      future: userInfo.doc(user_id).get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        //Error Handling conditions
        if (snapshot.hasError) {
          return Text("Something went wrong");
        }

        if (snapshot.hasData && !snapshot.data!.exists) {
          return Center(child:Text("Something went wrong please reopen app",style: TextStyle(fontSize: 20),));
        }

        //Data is output to the user
        //Text("Full Name: ${data['full_name']} ${data['last_name']}");
        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;
          return Container(
        //elevation: 20,
        color: Color.fromARGB(255, 218, 197, 190),
        child: ListView(
          children: [
            Container(
              height: 50,
              child: ListTile(
                leading: Icon(Icons.person_add),
                title:  Text(data['Full Name'],style: TextStyle(fontSize: 20),),
              )
            ),
            Container(
              height: 50,
              child: ListTile(
                leading: Icon(Icons.info),
                title:  Text(info!,style: TextStyle(fontSize: 20),),
              )
            ),
            Container(
              height: 50,
              child: ListTile(
                leading: Icon(Icons.phone),
                title:  SelectableText(data['phone'],style: TextStyle(fontSize: 20),),
              )
            ),
            Container(
              padding: EdgeInsets.all(20),
              child: img,
            ),
            
          ],
        ));
        }
        return  Center(child:CircularProgressIndicator());
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title:Text("Buy this books")),
      body: getWidget(context),
      );  
  }
}

