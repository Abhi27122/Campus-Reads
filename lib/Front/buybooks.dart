import 'package:campusreads/Front/chatscreen.dart';
import 'package:flutter/material.dart';


class BuyThis extends StatelessWidget{
  BuyThis(this.user_name,this.contact_info,this.ImageWidget);
  
  String user_name;
  String contact_info;
  Image ImageWidget;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title:Text("Buy this books")),
      body: Container(
        constraints: BoxConstraints.loose(Size(MediaQuery.of(context).size.width,MediaQuery.of(context).size.height*(0.6))),
        child: Card(
          elevation: 20,
          color: Color.fromARGB(255, 218, 197, 190),
          child: ListView(
            children: [
              Container(
                height: 50,
                child: ListTile(
                  leading: Icon(Icons.person_add),
                  title:  Text(user_name,style: TextStyle(fontSize: 20),),
                )
              ),
              Container(
                height: 50,
                child: ListTile(
                  leading: Icon(Icons.phone),
                  title:  SelectableText(contact_info,style: TextStyle(fontSize: 20),),
                )
              ),
              Container(
                height: MediaQuery.of(context).size.height*(0.43),
                child: ImageWidget,
              ),
              
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(onPressed: (){
        Navigator.of(context).push(MaterialPageRoute(builder: ((context) => ChatScreen())));
      },child: Icon(Icons.chat),),
    );  
  }
}

