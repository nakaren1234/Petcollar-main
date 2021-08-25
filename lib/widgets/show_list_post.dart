// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:pet/widgets/dog_card_user.dart';

// class ShowListPost extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           'PETS',
//           style: TextStyle(
//             fontWeight: FontWeight.bold,
//             fontFamily: 'K2D',
//           ),
//         ),
//         centerTitle: true,
//         elevation: 1.0,
//         backgroundColor: Colors.yellowAccent[700],
//       ),
//       body: StreamBuilder<QuerySnapshot>(
//         stream: FirebaseFirestore.instance
//             .collection('posts')
//             .orderBy('created_at')
//             .snapshots(),
//         builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
//           if (snapshot.hasError) return Text('Error: ${snapshot.error}');
//           switch (snapshot.connectionState) {
//             case ConnectionState.waiting:
//               return Center(
//                 child: CircularProgressIndicator(),
//               );
//             default:
//               return ListView(
//                 children: snapshot.data.docs.map(
//                   (DocumentSnapshot document) {
//                     return DogCard(
//                       document: document,
//                       userView: false,
//                     );
//                   },
//                 ).toList(),
//               );
//           }
//         },
//       ),
//     );
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pet/widgets/dog_card.dart';
// import 'package:pet/widgets/dog_card.dart';

class ShowListPost extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
            .orderBy('created_at', descending: true)
            // .where('found', isEqualTo: false)
            // .where('owner', isEqualTo: User)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) return Text('Error: ${snapshot.error}');
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return Center(
                child: CircularProgressIndicator(),
              );
            default:
              return ListView(
                children: snapshot.data.docs.map(
                  (DocumentSnapshot document) {
                    return DogCard(document: document);
                  },
                ).toList(),
              );
          }
        },
      ),
    );
  }
}
