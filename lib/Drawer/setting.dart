import 'package:flutter/material.dart';

class UserSetting extends StatelessWidget {
  const UserSetting({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 227, 218, 167),
      appBar: AppBar(title: Text("User Settings"),),
      body: Container(
        child:Column(
          children: [
              TextButton(onPressed: (){}, child: Text("change user details",style: TextStyle(fontSize: 25,fontWeight: FontWeight.normal),)),
        ])
      ),
    );
  }
}