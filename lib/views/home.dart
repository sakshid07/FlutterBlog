import 'package:blogapp/services/crud.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:blogapp/views/create_blog.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  CrudMethods crudMethods = new CrudMethods();
  Stream blogsStream;
  //bool _isLoading = false;

  Widget BlogsList() {
    return Container(
      child: blogsStream != null
          ? SingleChildScrollView(
                      child: Column(
              children: [
                StreamBuilder(
                  stream: blogsStream,
                  builder: (context, snapshot){
                    return ListView.builder(
                  primary: false,
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  itemCount: snapshot.data.docs.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return BlogsTile(
                      imgUrl: snapshot.data.docs[index].data()['imgUrl'],
                      title: snapshot.data.docs[index].data()['title'],
                      description: snapshot.data.docs[index].data()['desc'],
                      authorName:
                          snapshot.data.docs[index].data()['authorName'],
                    );
                  },
                );
                  },),
                
              ],
            ),
          )
          : Container(
              alignment: Alignment.center,
              child: CircularProgressIndicator(),
            ),
    );
  }



  

  @override
  void initState() {
    super.initState();

    crudMethods.getData().then((result) {
      setState(() {
        //_isLoading = true;
        blogsStream = result;
      });
    });
  }

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
                fontWeight: FontWeight.bold,
                color: Colors.pink,
              ),
            ),
          ],
        ),
        backgroundColor: Colors.black,
        

      ),
      body: SingleChildScrollView(child: BlogsList()),
      floatingActionButton: Container(
        padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            FloatingActionButton(
              backgroundColor: Colors.black,
              child: Icon(Icons.add, color: Colors.white,),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => CreateBlog()));
              },
            ),
          ],
        ),
      ),
    );
  }
}

class BlogsTile extends StatelessWidget {
  String imgUrl, title, description, authorName;
  BlogsTile(
      {@required this.imgUrl,
      @required this.title,
      @required this.description,
      @required this.authorName});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 8, top: 5,),
      height: 170,
      child: Stack(
        children: [
          ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: CachedNetworkImage(
                imageUrl: imgUrl,
                fit: BoxFit.cover,
                width: MediaQuery.of(context).size.width,
              )),
          Container(
            height: 170,
            decoration: BoxDecoration(
              color: Colors.black45.withOpacity(0.3),
              borderRadius: BorderRadius.circular(6),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style:
                        TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
                  ),
                  SizedBox(
                    height: 4,
                  ),
                  Text(description,
                      style: TextStyle(
                          fontSize: 18, fontWeight: FontWeight.w400)),
                  SizedBox(
                    height: 5,
                  ),
                  Text(authorName),
                ]),
          ),
        ],
      ),
    );
  }
}
