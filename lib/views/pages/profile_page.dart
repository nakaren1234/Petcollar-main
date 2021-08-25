import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pet/views/pages/login_page.dart';
import 'dart:io' show Platform;

import 'package:pet/widgets/show_user_pets.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String loginName;
  String loginTel;
  String loginEmail;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    findDisplayName();
  }

  void findDisplayName() {
    final User firebaseUser = _auth.currentUser;
    FirebaseFirestore.instance
        .collection('users')
        .doc(firebaseUser.uid)
        .get()
        .then((value) {
      final _data = value.data();
      setState(() {
        loginName = _data['name'] ?? '';
        loginTel = _data['tel'] ?? '';
        loginEmail = _data['email'] ?? '';
      });
    });
  }

  Widget showlogin() {
    return Text('login = $loginName');
  }

  Widget showtel() {
    return Text('tel = $loginTel');
  }

  Widget showloginemail() {
    return Text('login = $loginEmail');
  }

  @override
  Widget build(BuildContext context) {
    Future<void> processSignOut() async {
      await _auth.signOut().then(
        (response) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => LoginPage(),
            ),
            (Route<dynamic> route) => false,
          );
        },
      );
    }

    Widget okButton() {
      return TextButton(
        child: Text(
          'OK',
          style: TextStyle(color: Colors.blue),
        ),
        onPressed: () => processSignOut(),
      );
    }

    Widget cancelButton() {
      return TextButton(
        child: Text(
          'Cancel',
          style: TextStyle(color: Colors.blue),
        ),
        onPressed: () => Navigator.pop(context),
      );
    }

    void myAlert() {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) {
          return Platform.isIOS
              ? CupertinoAlertDialog(
                  title: Text('Are you sure?'),
                  content: Text('Do you want to SIGN OUT?'),
                  actions: <Widget>[
                    cancelButton(),
                    okButton(),
                  ],
                )
              : AlertDialog(
                  title: Text('Are you sure?'),
                  content: Text('Do you want to SIGN OUT?'),
                  actions: <Widget>[
                    cancelButton(),
                    okButton(),
                  ],
                );
        },
      );
    }

    Widget signOutButton() {
      return IconButton(
        icon: Icon(Icons.exit_to_app),
        onPressed: myAlert,
      );
    }

    showUserPet() {
      return IconButton(
        icon: Icon(Icons.list),
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) => ShowUserPets(),
          ),
        ),
      );
    }

    Widget showLogoProfile() {
      return Padding(
        padding: EdgeInsets.all(7.0),
        child: Image.asset(
          'images/aboutuser.png',
          width: 90.0,
          height: 90.0,
        ),
      );
    }

    Widget showContent() {
      return Column(
        children: <Widget>[
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            color: Colors.blueGrey[50],
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(7.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      showLogoProfile(),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(7.0),
                  child: Row(
                    children: <Widget>[
                      Icon(Icons.email),
                      SizedBox(
                        width: 20,
                      ),
                      Text(
                        '$loginEmail',
                        style: TextStyle(
                          fontSize: 18.0,
                          fontFamily: 'K2D',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(7.0),
                  child: Row(
                    children: <Widget>[
                      Icon(Icons.note),
                      SizedBox(
                        width: 20,
                      ),
                      Text(
                        '$loginName',
                        style: TextStyle(
                          fontSize: 18.0,
                          fontFamily: 'K2D',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(7.0),
                  child: Row(
                    children: <Widget>[
                      Icon(Icons.call),
                      SizedBox(
                        width: 20,
                      ),
                      Text(
                        '$loginTel',
                        style: TextStyle(
                          fontSize: 16.0,
                          fontFamily: 'K2D',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'PETS',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontFamily: 'K2D',
          ),
        ),
        centerTitle: true,
        elevation: 1.0,
        backgroundColor: Colors.yellowAccent[700],
        actions: [
          signOutButton(),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            // showlogin(),
            // showtel(),
            showContent(),
            SizedBox(height: 10.0),
            showUserPet(),
          ],
        ),
      ),
    );
  }
}
