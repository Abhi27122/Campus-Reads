import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'dart:async';

class ChatScreen extends StatefulWidget {
  ChatScreen(this.user_id);

  String? user_id;
  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {

  final TextEditingController _controller = TextEditingController();

    Widget getWidget(BuildContext context) {
    CollectionReference userInfo = FirebaseFirestore.instance.collection('personal_info');

    return FutureBuilder<DocumentSnapshot>(
      //Fetching data from the user_id specified of the user
      future: userInfo.doc(widget.user_id).get(),
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
                title:  Text(data['Name'],style: TextStyle(fontSize: 20),),
              )
            ),
          ],
        ));
        }
        return  Center(child:CircularProgressIndicator());
      },
    );
  }



  @override
  void dispose(){
    super.dispose();
  }

  void _sendMessage(){

    setState(() {
    });
    _controller.clear();
  }

  Widget _buildTextComposer(){
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _controller,
            onSubmitted: (value) => _sendMessage(),
            decoration: const InputDecoration.collapsed(hintText: "Send a message")
          ),
        ),
        IconButton(
            onPressed: () => _sendMessage(),
            icon: const Icon(Icons.send),
        )
      ]
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: getWidget(context),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Flexible(
                child: ListView.builder(
                  reverse: true,
                  padding: EdgeInsets.all(0.8),
                  itemCount:4,
                  itemBuilder: (context, index){
                  return Card(color: Color.fromARGB(255, 218, 197, 190),child: Text("Hello I am interested in buying this books",style: TextStyle(fontSize: 20),));
                },)
            ),
           const Divider(
              height: 1.0,
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.brown,
              ),
              child: _buildTextComposer(),
            ),
          ]
        ),
      ),
    );
  }
}