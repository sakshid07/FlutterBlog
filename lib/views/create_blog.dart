import 'dart:io';

import 'package:blogapp/services/crud.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:random_string/random_string.dart';
class CreateBlog extends StatefulWidget {
  @override
  _CreateBlogState createState() => _CreateBlogState();
}

class _CreateBlogState extends State<CreateBlog> {
  String authorName, title, desc;
  bool _isLoading= false;

  CrudMethods crudMethods = new CrudMethods();
  File _image;
  final picker = ImagePicker();

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }
  uploadBlog() async {
    if (_image != null) {
      setState(() {
        _isLoading = true;
      });

      StorageReference firebaseStorageRef = FirebaseStorage.instance.ref().child("blogImage").child("${randomAlphaNumeric(9)}.jpg");
      final StorageUploadTask task = firebaseStorageRef.putFile(_image);
      var downloadUrl = await (await task.onComplete).ref.getDownloadURL();
      print("this is $downloadUrl");
      Map<String, String> blogMap = {
        "imgUrl" : downloadUrl,
        "authorName" : authorName,
        "title" : title,
        "desc": desc,
      } ;
      crudMethods.addData(blogMap).then((result) {
        Navigator.pop(context);
      });
      

    }else {

    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
          Text(
            "My",
            style: TextStyle(
              fontSize: 22.0,
            ),
          ),
          Text(
            "Blog",
            style: TextStyle(
              fontSize: 22.0,
              color: Colors.blue,
            ),
          ),
        ],),
        backgroundColor: Colors.transparent,
        
        actions: [
          GestureDetector(
              onTap: () {
                uploadBlog();
              },
              child: Container(
              padding: EdgeInsets.symmetric(horizontal:16),
              child: Icon(Icons.file_upload)
              ),
          ),
        ],
      ),
      body: _isLoading ? Container(
            alignment: Alignment.center,
            child: CircularProgressIndicator(),
          ) 
        : Container(
        child: Column(
          children: [
            SizedBox(height:10),
            GestureDetector(
              onTap: () {
                getImage();
              },
              child: _image != null? Container(
                  
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  height: 170,
                  width: MediaQuery.of(context).size.width,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: Image.file(_image, fit: BoxFit.cover,),
                  ),
                )
                : Container(
                margin: EdgeInsets.symmetric(horizontal: 20),
                height: 170,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Icon(Icons.add_a_photo, color: Colors.black45),
              ),
            ),
            SizedBox(height: 8,),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  TextField(
                    decoration: InputDecoration(hintText: "AuthorName"),
                    onChanged: (val) {
                      authorName = val;
                    },
                  ),
                  TextField(
                    decoration: InputDecoration(hintText: "Title"),
                    onChanged: (val) {
                      title = val;
                    },
                  ),
                  TextField(
                    decoration: InputDecoration(hintText: "Description"),
                    onChanged: (val) {
                      desc = val;
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}