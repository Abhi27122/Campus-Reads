import 'package:campusreads/Drawer/myposts.dart';
import 'package:campusreads/Drawer/myprofile.dart';
import 'package:campusreads/Front/addpost.dart';
import 'package:campusreads/Front/buybooks.dart';
import 'package:campusreads/data/google_sign_in.dart';
import 'package:campusreads/data/selling_data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:cached_network_image/cached_network_image.dart';


class FrontPage extends StatelessWidget {
  FrontPage();

  final CollectionReference _products = FirebaseFirestore.instance.collection('products'); 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 227, 218, 167),
      appBar: AppBar(title: Text("Welcome"), backgroundColor: Color.fromARGB(255, 146, 81, 16),
      actions: [
        IconButton(onPressed: (() => AuthService().signOut()) , icon: Icon(Icons.exit_to_app))
      ],
      ),
      drawer: DrawerWidget(),
      body: StreamBuilder(
        stream: _products.orderBy('Date',descending: true).snapshots(),
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
                                    Container(
                                      key: Key("1234"),
                                      padding: EdgeInsets.all(20),
                                      child: CachedNetworkImage(
                                              imageUrl: documentSnapshot['image'],
                                              placeholder: (context, url) => CircularProgressIndicator(),
                                              errorWidget: (context, url, error) => Icon(Icons.error),
                                          ),),
                                    ListTile(
                                      title: Text(documentSnapshot['Name'],style: TextStyle(fontSize: 20),),
                                      subtitle: Text(timeago.format(documentSnapshot['Date'].toDate()),style:TextStyle(fontSize: 15)),
                                      trailing: Text( '₹${documentSnapshot['price']}',style:TextStyle(fontSize: 20)),
                                    
                                          ),
                                        ],
                                      ),
                                      
                                    ),
                                    onTap: (){
                                        Navigator.of(context).push(MaterialPageRoute(builder: ((context) => BuyThis(documentSnapshot['userId'],documentSnapshot['Name'],documentSnapshot['image']))));
                                      },
                                  ),
                                );
                              },
                            );
          }
          return Center(child:CircularProgressIndicator());
         },),
         floatingActionButton: FloatingActionButton(
          onPressed: (){
            Navigator.of(context).push(MaterialPageRoute(builder: ((context) =>  AddPost())));
          },
          child: Icon(Icons.add),
        ),
    );
  }
}


class DrawerWidget extends StatefulWidget {
  DrawerWidget();

  @override
  State<DrawerWidget> createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  User? user = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
  return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('personal_info').doc(user!.uid).snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Text("Loading");
        }
        print(user!.uid);
        var userDocument = snapshot.data as DocumentSnapshot;
        return  Drawer(
        backgroundColor: Color.fromARGB(255, 227, 218, 167),
        child: ListView(
          padding:  EdgeInsets.all(0),
          children: [
             DrawerHeader(
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 146, 81, 16),
              ), //BoxDecoration
              child: UserAccountsDrawerHeader(
                decoration: BoxDecoration(color:Color.fromARGB(255, 146, 81, 16)),
                accountName: Text(
                  userDocument['Full Name'],
                  style: TextStyle(fontSize: 18),
                ),
                accountEmail: Text(userDocument['Email']),
                currentAccountPictureSize: Size.square(50),
                currentAccountPicture: CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.white,
                  backgroundImage: NetworkImage(userDocument["photo"]),//Text
                ), //circleAvatar
              ), //UserAccountDrawerHeader
            ), //DrawerHeader
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text(' My Profile '),
              onTap: () {
                 Navigator.of(context).push(MaterialPageRoute(builder: ((context) => MyProfile())));
              },
            ),
            ListTile(
              leading: const Icon(Icons.book),
              title: const Text('My Posts'),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(builder: ((context) => MyPosts())));
              },
            ),
            
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
              onTap: () {
                Navigator.popUntil(context, (route) => route.isFirst);
              },
            ),
          ],
        ),
      );
      }
  );
}
}



