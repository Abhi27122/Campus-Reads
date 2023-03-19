import 'package:flutter/material.dart';

import 'dart:async';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {

  final TextEditingController _controller = TextEditingController();

  StreamSubscription? _subscription;
  bool _isTyping = false;


  @override
  void dispose(){
    _subscription?.cancel();
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
        title: const Text('User Name'),
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