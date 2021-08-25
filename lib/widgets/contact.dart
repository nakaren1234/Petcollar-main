import 'package:flutter/material.dart';
import 'package:pet/views/pages/home_page.dart';

class ConTact extends StatefulWidget {
  ConTact({Key key}) : super(key: key);

  @override
  _ConTactState createState() => _ConTactState();
}

class _ConTactState extends State<ConTact> {
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
                  children: <Widget>[],
                ),
              ),
              SizedBox(height: 20.0),
              Padding(
                padding: EdgeInsets.all(7.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(Icons.close, color: Colors.red, size: 50.0),
                    SizedBox(width: 20),
                    Text(
                      'แจ้งเตือน',
                      style: TextStyle(
                        fontSize: 30.0,
                        fontFamily: 'K2D',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: 20),
                    Icon(Icons.close, color: Colors.red, size: 50.0),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.all(7.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'กรุณาทำการแจ้งผู้ดูแลเพื่อทำการ',
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
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'ขออัพเดตสถานะ',
                      style: TextStyle(
                        fontSize: 18.0,
                        fontFamily: 'K2D',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20.0),
              Padding(
                padding: EdgeInsets.all(7.0),
                child: Row(
                  children: <Widget>[
                    SizedBox(width: 5.0),
                    Image.asset(
                      'images/line.png',
                      width: 40.0,
                      height: 40.0,
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Text(
                      'Sky131456',
                      style: TextStyle(
                        fontSize: 20.0,
                        fontFamily: 'K2D',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20.0),
              Padding(
                padding: EdgeInsets.all(7.0),
                child: Row(
                  children: <Widget>[
                    Image.asset(
                      'images/facebook.png',
                      width: 50.0,
                      height: 50.0,
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Text(
                      'Nakaren Sky',
                      style: TextStyle(
                        fontSize: 20.0,
                        fontFamily: 'K2D',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20.0),
              Padding(
                padding: EdgeInsets.all(7.0),
                child: Row(
                  children: <Widget>[
                    SizedBox(width: 10.0),
                    Icon(Icons.call, color: Colors.green, size: 35.0),
                    SizedBox(
                      width: 20,
                    ),
                    Text(
                      '0988081663',
                      style: TextStyle(
                        fontSize: 20.0,
                        fontFamily: 'K2D',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20.0),
              Padding(
                padding: EdgeInsets.all(7.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'พร้อมให้บริการและคำแนะนำ',
                      style: TextStyle(
                        fontSize: 20.0,
                        fontFamily: 'K2D',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20.0),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'PETS',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontFamily: 'K2D',
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        elevation: 1.0,
        backgroundColor: Colors.yellowAccent[700],
        automaticallyImplyLeading: false,
      ),
      body: Container(
        child: Column(
          children: [
            showContent(),
            SizedBox(height: 10.0),
            ElevatedButton(
              child: Text('Home'),
              onPressed: () => Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                    builder: (BuildContext context) => MyHomePage()),
                (route) => false,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
