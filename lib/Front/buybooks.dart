import 'package:cached_network_image/cached_network_image.dart';
import 'package:campusreads/Front/chatscreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class BuyThis extends StatelessWidget{

  FirebaseFirestore db = FirebaseFirestore.instance;

  BuyThis(this.user_id,this.info,this.imgurl);

  String? user_id;
  String? imgurl;
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
        child: Center(
            child: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top:10),
                  child: Align(
                    alignment: Alignment.center,
                    //padding: EdgeInsets.only(top: 10),
                      child:  CircleAvatar(
                        radius: 70,
                        backgroundColor: Colors.white,
                        backgroundImage: 
                        NetworkImage(data['photo']),
                      ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(left: 30,right: 10),
                  child: ListTile(
                    leading: Icon(Icons.person_add),
                    title:  Text(data['Full Name'],style: TextStyle(fontSize: 20),),
                  )
                ),
                Container(
                  padding: EdgeInsets.only(left: 30,right: 10),
                  child: ListTile(
                    leading: Icon(Icons.info),
                    title:  Text(info!,style: TextStyle(fontSize: 20),),
                  )
                ),
                Container(
                  padding: EdgeInsets.only(left: 30,right: 10),
                  child: ListTile(
                    leading: Icon(Icons.phone),
                    title:  SelectableText(data['phone'],style: TextStyle(fontSize: 20),),
                  )
                ),
                Container(
                  padding: EdgeInsets.all(10),
                  child: CachedNetworkImage(
                        imageUrl: imgurl!,
                        placeholder: (context, url) => CircularProgressIndicator(),
                        errorWidget: (context, url, error) => Icon(Icons.error),
                      ),
                ),
                  
                Container(
                  alignment: Alignment.bottomRight,
                  padding: EdgeInsets.all(10),
                  child: FloatingActionButton(
                    child: Icon(Icons.chat),
                    onPressed: (){
                      var whatsappUrl ="whatsapp://send?phone=${"+91" + data['phone']}" +"&text=${Uri.encodeComponent("Hey saw your product on Campus Reads - ${info} and I am interested in buying")}";
                      try {
                            launch(whatsappUrl);
                          } catch (e) {
                            //To handle error and display error message
                          }
                  }),
                )
                
              ],
            ),
          ),
        );
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

