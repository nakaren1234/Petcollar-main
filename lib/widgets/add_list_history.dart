import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pet/scoped_model/user_model.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:toast/toast.dart';
import 'package:uuid/uuid.dart';

class AddListHistory extends StatefulWidget {
  AddListHistory({Key key}) : super(key: key);

  @override
  _AddListHistoryState createState() => _AddListHistoryState();
}

class _AddListHistoryState extends State<AddListHistory> {
  PickedFile file;
  File uploadFile;
  String nameDog;
  String breed;
  String color;
  String urlPicture;

  FirebaseFirestore firestore = FirebaseFirestore.instance;
  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;

  Uuid uuid = Uuid();

  Widget showImage() {
    return Container(
      padding: EdgeInsets.all(10.0),
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.width * 0.5,
      child: file == null
          ? Image.asset('images/pic.png')
          : Image.file(File(file.path)),
    );
  }

  Future<void> chooseImage(ImageSource imageSource) async {
    final ImagePicker _picker = ImagePicker();
    try {
      final _pickedFile = await _picker.getImage(
        source: imageSource,
        maxWidth: 800.0,
        maxHeight: 800.0,
      );
      setState(() {
        file = _pickedFile;
        uploadFile = File(file.path);
      });
    } catch (e) {}
  }

  Widget cameraButton() {
    return IconButton(
      icon: Icon(
        Icons.add_a_photo,
        size: 36.0,
        color: Colors.green[700],
      ),
      onPressed: () => chooseImage(ImageSource.camera),
    );
  }

  Widget galleryButton() {
    return IconButton(
      icon: Icon(
        Icons.add_photo_alternate,
        size: 38.0,
        color: Colors.green[700],
      ),
      onPressed: () => chooseImage(ImageSource.gallery),
    );
  }

  Widget showButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        cameraButton(),
        galleryButton(),
      ],
    );
  }

  Widget nameInputForm() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.6,
      child: TextField(
        decoration: InputDecoration(
          labelText: 'PET NAME',
          helperText: 'Your pet name',
          labelStyle: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.orange[900],
          ),
          icon: Icon(
            Icons.description,
            size: 30,
            color: Colors.orange[900],
          ),
        ),
        onChanged: (String text) => nameDog = text.trim(),
      ),
    );
  }

  Widget breedInputForm() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.6,
      child: TextField(
        decoration: InputDecoration(
          labelText: 'Breed',
          helperText: 'Your breed',
          labelStyle: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.orange[900],
          ),
          icon: Icon(
            Icons.pets,
            size: 30,
            color: Colors.orange[900],
          ),
        ),
        onChanged: (String text) => breed = text.trim(),
      ),
    );
  }

  Widget colorForm() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.6,
      child: TextField(
        decoration: InputDecoration(
          labelText: 'Color',
          helperText: 'Your pet color',
          labelStyle: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.orange[900],
          ),
          icon: Icon(
            Icons.color_lens,
            size: 30,
            color: Colors.orange[900],
          ),
        ),
        onChanged: (String text) => color = text.trim(),
      ),
    );
  }

  Future<void> showAlert(String title, String message) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('OK'),
            )
          ],
        );
      },
    );
  }

  Future<void> uploadPictureToStorage() async {
    String name = 'dogs/${uuid.v4()}.png';
    try {
      await firebase_storage.FirebaseStorage.instance
          .ref(name)
          .putFile(uploadFile);
    } on FirebaseException catch (e) {
      print(e);
      return;
    }

    String downloadURL = await firebase_storage.FirebaseStorage.instance
        .ref(name)
        .getDownloadURL();

    setState(() {
      urlPicture = downloadURL;
    });
  }

  Future<bool> inserValueToFirestore(BuildContext context) async {
    final user = ScopedModel.of<UserModel>(context, rebuildOnChange: false);
    Map<String, dynamic> map = Map();
    map['name'] = nameDog;
    map['breed'] = breed;
    map['color'] = color;
    map['image_path'] = urlPicture;
    map['missing'] = false;
    map['created_at'] = DateTime.now();

    await firestore
        .collection('users')
        .doc(user.userId)
        .collection('pets')
        .doc()
        .set(map);
    return true;
  }

  Widget uploadButton(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Container(
          width: MediaQuery.of(context).size.width * 0.5,
          height: 40,
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              primary: Colors.yellow[700],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
            ),
            onPressed: () async {
              if (file == null) {
                showAlert(
                    'No image selected', 'Please Click Camera or Gallery');
              } else if (nameDog == null || nameDog.isEmpty) {
                showAlert('No Name', 'Please fill your dog name');
              } else {
                await uploadPictureToStorage();
                await inserValueToFirestore(context);
                Toast.show(
                  "Done",
                  context,
                  duration: Toast.LENGTH_SHORT,
                  gravity: Toast.BOTTOM,
                );
              }
            },
            icon: Icon(
              Icons.cloud_upload,
              color: Colors.white,
            ),
            label: Flexible(
              child: Text(
                'REGISTER ',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget showContent(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          showImage(),
          showButton(),
          SizedBox(height: 20),
          nameInputForm(),
          breedInputForm(),
          colorForm(),
          SizedBox(height: 50),
          uploadButton(context),
          SizedBox(height: 20),
        ],
      ),
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
          ),
        ),
        centerTitle: true,
        elevation: 1.0,
        backgroundColor: Colors.yellowAccent[700],
      ),
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: Container(
          child: Stack(
            children: [
              Column(
                children: [
                  showContent(context),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
