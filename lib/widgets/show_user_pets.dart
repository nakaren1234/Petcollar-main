import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pet/scoped_model/user_model.dart';
import 'package:pet/widgets/detail.dart';
import 'package:scoped_model/scoped_model.dart';

class ShowUserPets extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = ScopedModel.of<UserModel>(context, rebuildOnChange: true);
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
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(user.userId)
            .collection('pets')
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) return Text('Error: ${snapshot.error}');
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return Center(
                child: CircularProgressIndicator(),
              );
            default:
              return ListView.builder(
                shrinkWrap: true,
                itemCount: snapshot.data.docs.length,
                itemBuilder: (BuildContext context, int index) => Card(
                  child: InkWell(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) => Detail(
                          document: snapshot.data.docs.elementAt(index),
                        ),
                      ),
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          showListViewDetail(
                            context,
                            document: snapshot.data.docs.elementAt(index),
                          ),
                        ],
                      ),
                    ),
                  ),
                ), //your list view content here
              );
          }
        },
      ),
    );
  }

  Widget showListViewDetail(BuildContext context, {DocumentSnapshot document}) {
    return Row(
      children: [
        showImage(context, document['image_path']),
        showText(context, document),
      ],
    );
  }

  Widget showText(BuildContext context, DocumentSnapshot document) {
    return Container(
      padding: EdgeInsets.only(right: 10.0, top: 80.0),
      width: MediaQuery.of(context).size.width * 0.4,
      height: MediaQuery.of(context).size.height * 0.4,
      child: Column(
        children: [
          showName(document['name']),
          SizedBox(height: 10.0),
          showBreed(document['breed']),
          SizedBox(height: 10.0),
          showColor(document['color']),
        ],
      ),
    );
  }

  Widget showImage(BuildContext context, String imagePath) {
    return Container(
      padding: EdgeInsets.all(20.0),
      width: MediaQuery.of(context).size.width * 0.5,
      height: MediaQuery.of(context).size.width * 0.5,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30.0),
          image: DecorationImage(
            image: imagePath != null || imagePath != ""
                ? NetworkImage(imagePath)
                : NetworkImage("http://via.placeholder.com/350x150"),
            fit: BoxFit.fill,
          ),
        ),
      ),
    );
  }

  Widget showName(String name) {
    return Row(
      children: [
        Flexible(
          child: Text(
            "Name: ${name ?? '-'}",
            style: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
      ],
    );
  }

  Widget showBreed(String breed) {
    return Row(
      children: [
        Flexible(
          child: Text(
            "Breed: ${breed ?? '-'}",
            style: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
      ],
    );
  }

  Widget showColor(String color) {
    return Row(
      children: [
        Flexible(
          child: Text(
            "Color: ${color ?? '-'}",
            style: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
      ],
    );
  }
}
