import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:textreader/ShowText.dart';

class ImageScreen extends StatefulWidget {
  @override
  _ImageScreenState createState() => _ImageScreenState();
}

class _ImageScreenState extends State<ImageScreen> {
  File pickedImage;
  bool isImageLoaded = false;

  Future pickImage() async {
    var tempStore = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      pickedImage = tempStore;
      (pickedImage!=null)?isImageLoaded = true:isImageLoaded = false;
    });
  }


  @override
  void initState() {
    super.initState();
    pickImage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Text Reader",
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
          ),
        ),
        backgroundColor: Colors.deepOrange,
      ),
      body: Stack(children: [
        Container(
          color: Colors.black,
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: isImageLoaded
              ? Center(
                  child: Container(
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image: FileImage(pickedImage),
                              fit: BoxFit.contain))),
                )
              : Center(
                  child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.deepOrange),
                )),
        ),
      ]),
      floatingActionButton: Container(
        height: 70.0,
        width: 70.0,
        child: FittedBox(
          child: FloatingActionButton(
            backgroundColor: Colors.deepOrange,
            child: Icon(Icons.arrow_forward,size: 28,),
            onPressed: (){
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ShowText(pickedImage)),
              );
            },
          ),
        ),
      ),
    );
  }
}
