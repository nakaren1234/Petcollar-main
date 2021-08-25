import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pet/scoped_model/user_model.dart';
import 'package:pet/widgets/dog_card_user.dart';
import 'package:scoped_model/scoped_model.dart';

class ShowListUserPost extends StatelessWidget {
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
            .collection('posts')
            // .orderBy('created_at', descending: true)
            .where('owner', isEqualTo: user.userId)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) return Text('Error: ${snapshot.error}');
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return Center(
                child: CircularProgressIndicator(),
              );
            default:
              final data = snapshot.data.docs;
              data.sort((a, b) {
                final _a = DateTime.parse(a['created_at'].toDate().toString());
                final _b = DateTime.parse(b['created_at'].toDate().toString());
                return _b.compareTo(_a);
              });
              return ListView(
                children: data.map(
                  (DocumentSnapshot document) {
                    return DogCard(
                      document: document,
                      userView: true,
                    );
                  },
                ).toList(),
              );
          }
        },
      ),
    );
  }
}
