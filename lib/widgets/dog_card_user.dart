import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lite_rolling_switch/lite_rolling_switch.dart';
import 'package:intl/intl.dart' show DateFormat;

class DogCard extends StatefulWidget {
  final DocumentSnapshot document;
  final bool userView;

  const DogCard({
    Key key,
    this.document,
    this.userView,
  }) : super(key: key);

  @override
  _DogCardState createState() => _DogCardState();
}

class _DogCardState extends State<DogCard> {
  DocumentSnapshot document;
  String loginName;
  String loginTel;

  @override
  void initState() {
    super.initState();
    document = widget.document;
    findDisplayName();
  }

  void findDisplayName() {
    FirebaseFirestore.instance
        .collection('users')
        .doc(document['owner'])
        .get()
        .then((value) {
      final _data = value.data();
      setState(() {
        loginName = _data['name'] ?? '';
        loginTel = _data['tel'] ?? '';
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Colors.grey[300]),
      child: Card(
        child: Column(
          children: <Widget>[
            document['image_path'] != ''
                ? Image.network(document['image_path'])
                : Container(
                    width: 100,
                    height: 100,
                  ),
            Padding(
              padding: EdgeInsets.all(7.0),
              child: Row(
                children: <Widget>[
                  Flexible(
                    child: Text(
                      "PetName: ${document['title']}",
                      style: TextStyle(
                        fontSize: 18.0,
                        fontFamily: 'K2D',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(7.0),
              child: Row(
                children: <Widget>[
                  Flexible(
                    child: Text(
                      "Description: ${document['description']}",
                      style: TextStyle(
                        fontSize: 18.0,
                        fontFamily: 'K2D',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(7.0),
              child: Row(
                children: <Widget>[
                  Flexible(
                    child: Text(
                      "Time: ${DateFormat('dd/MM/yyyy').add_jm().format(DateTime.parse(document['created_at'].toDate().toString()))}",
                      style: TextStyle(
                        fontSize: 18.0,
                        fontFamily: 'K2D',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(7.0),
              child: Row(
                children: <Widget>[
                  Flexible(
                    child: Text(
                      "Name: $loginName",
                      style: TextStyle(
                        fontSize: 18.0,
                        fontFamily: 'K2D',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(7.0),
              child: Row(
                children: <Widget>[
                  Flexible(
                    child: Text(
                      "Tel: $loginTel",
                      style: TextStyle(
                        fontSize: 18.0,
                        fontFamily: 'K2D',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(7.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Status :",
                    style: TextStyle(
                      fontSize: 18.0,
                      fontFamily: 'K2D',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  widget.userView
                      ? Transform.scale(
                          scale: 0.6,
                          child: LiteRollingSwitch(
                            value: document['found'] ?? false,
                            textOn: "พบเจอ",
                            textOff: "สูญหาย",
                            colorOn: Colors.redAccent,
                            colorOff: Colors.lightGreenAccent,
                            iconOn: Icons.notifications,
                            iconOff: Icons.notifications,
                            textSize: 22.0,
                            onChanged: (bool position) async {
                              FirebaseFirestore.instance
                                  .collection('posts')
                                  .doc(document.id)
                                  .update({
                                "found": position,
                                "updated_at": DateTime.now(),
                              });
                            },
                          ),
                        )
                      : document['found'],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
