import 'package:campusreads/data/google_sign_in.dart';
import 'package:campusreads/data/selling_data.dart';
import 'package:flutter/material.dart';

class MyProfile extends StatelessWidget {
  MyProfile({Key? key}) : super(key: key);

  Profile_data pd = AuthService().getdata();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Profile Page")),
      backgroundColor: Color.fromARGB(255, 227, 218, 167),
      body: Container(
        height: MediaQuery.of(context).size.height,
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
          Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(border: Border.all(color:Color.fromARGB(255, 102, 44, 63),width: 5)),
            height: MediaQuery.of(context).size.height*0.55,
            child: Column(
              children: [
                SizedBox(
              height: MediaQuery.of(context).size.height*(0.03),
            ),
           Padding(
            padding:  EdgeInsets.all(10),
            child:   CircleAvatar(
                  radius: 80,
                  backgroundColor: Colors.white,
                  backgroundImage: NetworkImage(pd.photourl!), //Text
                ),
          ),

          Container(
            padding: EdgeInsets.symmetric(),
            child: TextButton(
              child:Text(pd.name!,style: TextStyle(fontSize: 30,color: Colors.brown)),
              onPressed: (){}
              )
            ),

          Container(
            padding: EdgeInsets.symmetric(),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.phone),
                TextButton(
                  child:Text("8390274064",style: TextStyle(fontSize: 25,color: Colors.brown)),
                  onPressed: (){}
                  ),
              ],
            )
          ),
          Container(
            padding: EdgeInsets.symmetric(),
            child:Text(pd.email!,style: TextStyle(fontSize: 20,color: Colors.brown)),
            ),
         ],
            ),
          ),
        ]),
      ),
      );
  }
}