import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pet/scoped_model/user_model.dart';
import 'package:scoped_model/scoped_model.dart';

// ignore: must_be_immutable
class Detail extends StatefulWidget {
  final DocumentSnapshot document;

  const Detail({
    Key key,
    this.document,
  }) : super(key: key);

  @override
  _DetailState createState() => _DetailState();
}

class _DetailState extends State<Detail> {
  //Field
  String name;
  String breed;
  String color;

  Widget showImage() {
    return Container(
      padding: EdgeInsets.all(20.0),
      width: MediaQuery.of(context).size.width * 1.0,
      height: MediaQuery.of(context).size.width * 0.8,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30.0),
          image: DecorationImage(
            image: widget.document['image_path'] != null ||
                    widget.document['image_path'] != ""
                ? NetworkImage(widget.document['image_path'])
                : NetworkImage("http://via.placeholder.com/350x150"),
            fit: BoxFit.fill,
          ),
        ),
      ),
    );
  }

  Widget showName() {
    return Row(
      // mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Name : ${widget.document['name']}",
          style: TextStyle(
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ],
    );
  }

  Widget showBreed() {
    return Row(
      // mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: Text(
            "Breed : ${widget.document['breed']}",
            style: TextStyle(
              fontSize: 24.0,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
      ],
    );
  }

  Widget showColor() {
    return Row(
      children: [
        Expanded(
          child: Text(
            "Color : ${widget.document['color']}",
            style: TextStyle(
              fontSize: 24.0,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
      ],
    );
  }

  Widget showText() {
    return Container(
      padding: EdgeInsets.all(20.0),
      child: Column(
        children: [
          showName(),
          SizedBox(height: 10.0),
          showBreed(),
          SizedBox(height: 10.0),
          showColor(),
        ],
      ),
    );
  }

  Widget showListView() {
    return SingleChildScrollView(
      child: Column(
        children: [
          showImage(),
          showText(),
        ],
      ),
    );
  }

  Widget nameForm() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.8,
      child: TextFormField(
        initialValue: widget.document['name'],
        onChanged: (String value) => name = value,
        decoration: InputDecoration(
          prefixIcon: Icon(
            Icons.face,
            color: Colors.green,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(10.0),
            ),
            borderSide: BorderSide(color: Colors.grey),
          ),
          focusedBorder: OutlineInputBorder(),
          labelText: "Name",
        ),
      ),
    );
  }

  Widget detailForm() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.8,
      child: TextFormField(
        initialValue: widget.document['breed'],
        onChanged: (String value) => breed = value,
        decoration: InputDecoration(
          prefixIcon: Icon(
            Icons.assignment_turned_in,
            color: Colors.green,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(10.0),
            ),
            borderSide: BorderSide(color: Colors.grey),
          ),
          focusedBorder: OutlineInputBorder(),
          labelText: "Breed",
        ),
      ),
    );
  }

  Widget colorForm() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.8,
      child: TextFormField(
        initialValue: widget.document['color'],
        onChanged: (String value) => color = value,
        decoration: InputDecoration(
          prefixIcon: Icon(
            Icons.color_lens,
            color: Colors.green,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(10.0),
            ),
            borderSide: BorderSide(color: Colors.grey),
          ),
          focusedBorder: OutlineInputBorder(),
          labelText: "Color",
        ),
      ),
    );
  }

  Future<void> updateFireStore() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    final user = ScopedModel.of<UserModel>(context, rebuildOnChange: false);
    Map<String, dynamic> map = Map();
    map['name'] = name ?? widget.document['name'];
    map['breed'] = breed ?? widget.document['breed'];
    map['color'] = color ?? widget.document['color'];
    map['updated_at'] = DateTime.now();

    await firestore
        .collection('users')
        .doc(user.userId)
        .collection('pets')
        .doc(widget.document.id)
        .update(map)
        .then(
      (value) {
        Navigator.pop(context);
        Navigator.pop(context);
      },
    );
  }

  Future<void> deleteFireStore() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    final user = ScopedModel.of<UserModel>(context, rebuildOnChange: false);

    await firestore
        .collection('users')
        .doc(user.userId)
        .collection('pets')
        .doc(widget.document.id)
        .delete()
        .then(
      (value) {
        Navigator.pop(context);
        Navigator.pop(context);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.yellowAccent[700],
        title: Text("UPDATE"),
        actions: [
          IconButton(
            icon: Icon(
              Icons.settings,
              color: Colors.black,
              size: 30.0,
            ),
            padding: EdgeInsets.only(right: 15.0),
            onPressed: () {
              BottomSheet(context);
            },
          )
        ],
      ),
      body: showListView(),
    );
  }

  // ignore: non_constant_identifier_names
  void BottomSheet(context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.6,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Row(
                  children: [
                    Text(
                      'Update Data',
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Spacer(),
                    IconButton(
                      icon: Icon(
                        Icons.cancel,
                        color: Colors.orange,
                        size: 25.0,
                      ),
                      onPressed: () => Navigator.pop(context),
                    )
                  ],
                ),
                SizedBox(height: 20.0),
                Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                        left: 30.0,
                      ),
                    ),
                    // showName(),
                    nameForm(),
                  ],
                ),
                SizedBox(height: 20.0),
                Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                        left: 30.0,
                      ),
                    ),
                    detailForm(),
                  ],
                ),
                SizedBox(height: 20.0),
                Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                        left: 30.0,
                      ),
                    ),
                    colorForm(),
                  ],
                ),
                SizedBox(height: 20.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.green,
                        textStyle: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      child: Text('Submit'),
                      onPressed: () async {
                        await updateFireStore();
                      },
                    ),
                    SizedBox(width: 20.0),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.red,
                        textStyle: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      child: Text('delete'),
                      onPressed: () async {
                        await deleteFireStore();
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
