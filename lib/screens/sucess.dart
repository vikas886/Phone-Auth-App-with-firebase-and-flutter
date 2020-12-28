import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_auth/model/person.dart';
import 'package:flutter_phone_auth/screens/item_upload.dart';
import 'package:flutter_phone_auth/screens/list_of_items.dart';
import 'package:flutter_phone_auth/screens/login.dart';

class Success extends StatefulWidget {
  // Success({Key key}) : super(key: key);
  Person user;
  Success({this.user});

  @override
  _SuccessState createState() => _SuccessState();
}

class _SuccessState extends State<Success> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        elevation: 0,
        child: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              UserAccountsDrawerHeader(
                accountEmail: Text(
                  widget.user.email,
                  style: TextStyle(
                    letterSpacing: 1.5,
                  ),
                ),
                accountName: Text(
                  widget.user.name,
                  style: TextStyle(letterSpacing: 1.6),
                ),
                currentAccountPicture: Container(
                  child: Image.network(
                    widget.user.picUrl,
                    fit: BoxFit.cover,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white60,
                  ),
                ),
                decoration: BoxDecoration(
                  color: Colors.orange[800],
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20)),
                ),
                otherAccountsPictures: [
                  Expanded(
                      child: Text(
                    widget.user.location,
                    style: TextStyle(color: Colors.white),
                  ))
                ],
              ),
              ListTile(
                leading: Icon(
                  Icons.add,
                  size: 30,
                  color: Colors.black,
                ),
                title: Text(
                  'Add Items',
                  style: TextStyle(
                    letterSpacing: 2,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => UploadItem(widget.user)));
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.shop_outlined,
                  size: 30,
                  color: Colors.black,
                ),
                title: Text(
                  'All The Items',
                  style: TextStyle(
                    letterSpacing: 2,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => ListOfProducts()));
                },
              ),
              Divider(),
              ListTile(
                leading: Icon(
                  Icons.logout,
                  color: Colors.black,
                  size: 30,
                ),
                title: Text(
                  'Logout',
                  style: TextStyle(
                    letterSpacing: 2,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onTap: () async {
                  await FirebaseAuth.instance.signOut();
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => LoginScreen()),
                      (route) => false);
                },
              )
            ],
          ),
        ),
      ),
      appBar: AppBar(
        backgroundColor: Colors.orange[800],
        title: Text(
          'Landing Page',
          style: TextStyle(
            letterSpacing: 2,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                  (route) => false);
            },
          )
        ],
      ),
      body: Center(
        child: Text(
          widget.user.name,
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
