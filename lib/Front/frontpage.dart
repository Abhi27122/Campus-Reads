import 'package:campusreads/Drawer/myposts.dart';
import 'package:campusreads/Drawer/myprofile.dart';
import 'package:campusreads/Front/buybooks.dart';
import 'package:campusreads/data/google_sign_in.dart';
import 'package:campusreads/data/selling_data.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


class FrontPage extends StatelessWidget {
  FrontPage();

  List<Selling_data> ls = [
    Selling_data("EnTC Third Year Sem 2", 500, DateTime.now()),
    Selling_data("EnTC Third Year Sem 2", 500, DateTime.now()),
    Selling_data("EnTC Third Year Sem 2", 500, DateTime.now()),
  ];

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
                  Image.asset('assets/images/books.jpg',),
                  ListTile(
                    title: Text(ls[index].title),
                    subtitle: Text('${ls[index].dt.day}/${ls[index].dt.month}/${ls[index].dt.year}'),
                    trailing: Text( '₹${ls[index].price}'),
                    onTap: (){
                      Navigator.of(context).push(MaterialPageRoute(builder: ((context) => BuyThis("Abhishek Kote","8390274064", Image.asset('assets/images/books.jpg',fit: BoxFit.contain,)))));
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


class DrawerWidget extends StatefulWidget {
  DrawerWidget();

  @override
  State<DrawerWidget> createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {

  Profile_data pd = AuthService().getdata();

  @override
  Widget build(BuildContext context) {
    return Drawer(
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
                  pd.name!,
                  style: TextStyle(fontSize: 18),
                ),
                accountEmail: Text(pd.email!),
                currentAccountPictureSize: Size.square(60),
                currentAccountPicture: CircleAvatar(
                  radius: 40,
                  backgroundColor: Colors.white,
                  backgroundImage: NetworkImage(pd.photourl!),//Text
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
}