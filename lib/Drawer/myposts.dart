import 'package:campusreads/data/selling_data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MyPosts extends StatelessWidget {
  MyPosts({Key? key}) : super(key: key);

  List<Selling_data> ls = [
    Selling_data("EnTC Third Year Sem 2", 500, DateTime.now()),
    Selling_data("EnTC Third Year Sem 2", 500, DateTime.now()),
    Selling_data("EnTC Third Year Sem 2", 500, DateTime.now()),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 227, 218, 167),
      appBar: AppBar(title: Text("My Posts"), backgroundColor: Color.fromARGB(255, 146, 81, 16),),
      body:ListView.builder(
        itemCount: ls.length,
        itemBuilder: (BuildContext context, int index) {
          return Card(
              shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
              //set border radius more than 50% of height and width to make circle
              ),
              color: const Color.fromARGB(255, 244, 176, 113),
              child: Column(
                children: [
                  ListTile(
                    title: Text(ls[index].title),
                    subtitle: Text('${ls[index].dt.day}/${ls[index].dt.month}/${ls[index].dt.year}'),
                    trailing: Text( '₹${ls[index].price}'),
                    onTap: (){
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}