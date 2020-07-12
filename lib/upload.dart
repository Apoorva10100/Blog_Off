import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class UploadPic extends StatefulWidget {
  @override
  _UploadPicState createState() => _UploadPicState();
}

class _UploadPicState extends State<UploadPic> {
  File sampleImage;
  String url;
  final _formKey = new GlobalKey<FormState>();

  Future getImage() async {
    // ignore: deprecated_member_use
    var temp = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      sampleImage = temp;
    });
  }

  bool validateAndSave() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    } else {
      return false;
    }
  }

  void uploadStatus() async {
    if (validateAndSave()) {
      final StorageReference postImage =
          FirebaseStorage.instance.ref().child("Post Images");
      final StorageUploadTask uploadTask = postImage.putFile(sampleImage);
      var imageUrl = await (await uploadTask.onComplete).ref.getDownloadURL();
      url = imageUrl.toString();
      goToHomePage();
      saveToDatabase(url);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Upload Image'),
        backgroundColor: Colors.pink,
        centerTitle: true,
      ),
      body: Center(
        child: sampleImage == null ? Text('Select an image') : uploadImage(),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.pink,
        onPressed: getImage,
        tooltip: 'Add Image',
        child: Icon(Icons.add_a_photo),
      ),
    );
  }

  Widget uploadImage() {
    return Container(
      child: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Image.file(sampleImage),
            ),
            RaisedButton(
              onPressed: uploadStatus,
              child: Text('Post'),
              textColor: Colors.white,
              color: Colors.pink,
            )
          ],
        ),
      ),
    );
  }

  void saveToDatabase(String url) {
    DatabaseReference ref = FirebaseDatabase.instance.reference();
    var data = {
      "image": url,
    };
    ref.child("Posts").push().set(data);
  }

  void goToHomePage() {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return UploadPic();
    }));
  }
}
