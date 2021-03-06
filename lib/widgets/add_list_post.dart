import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pet/scoped_model/user_model.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:uuid/uuid.dart';
import 'package:toast/toast.dart';

class AddListPost extends StatefulWidget {
  @override
  _AddListPostState createState() => _AddListPostState();
}

class _AddListPostState extends State<AddListPost> {
  PickedFile file;
  File uploadFile;
  String nameDog;
  String detailDog;
  String urlPicture;

  FirebaseFirestore firestore = FirebaseFirestore.instance;
  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;

  Uuid uuid = Uuid();

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
              } else if (detailDog == null || detailDog.isEmpty) {
                showAlert('No Detail', 'Please fill your dog detail');
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
            label: Text(
              'REGISTER DOG',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> uploadPictureToStorage() async {
    String name = 'posts/${uuid.v4()}.png';
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

    print(downloadURL);

    setState(() {
      urlPicture = downloadURL;
    });
  }

  Future<bool> inserValueToFirestore(BuildContext context) async {
    final user = ScopedModel.of<UserModel>(context, rebuildOnChange: false);
    Map<String, dynamic> map = Map();
    map['title'] = nameDog;
    map['description'] = detailDog;
    map['image_path'] = urlPicture;
    map['owner'] = user.userId;
    // map['phone'] = user.phone;
    map['found'] = false;
    map['created_at'] = DateTime.now();

    await firestore.collection('posts').doc().set(map);
    return true;
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

  Widget nameInputForm() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.8,
      child: TextField(
        decoration: InputDecoration(
          labelText: 'Pet Name',
          helperText: 'Your pet name',
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
        onChanged: (String text) => nameDog = text.trim(),
      ),
    );
  }

  Widget detailInputForm() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.8,
      child: TextField(
        decoration: InputDecoration(
          labelText: 'Description',
          helperText: 'Detail Your pet e.g. age, breed, habit',
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
        onChanged: (String text) => detailDog = text.trim(),
      ),
    );
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

  Widget showContent(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          showImage(),
          showButton(),
          SizedBox(
            height: 20,
          ),
          nameInputForm(),
          detailInputForm(),
          SizedBox(
            height: 50,
          ),
          uploadButton(context),
          SizedBox(
            height: 20,
          ),
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
              )
            ],
          ),
        ),
      ),
    );
  }
}
