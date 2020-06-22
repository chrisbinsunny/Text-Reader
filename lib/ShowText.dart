import 'package:flutter/material.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'dart:io';
import 'package:share/share.dart';
import 'package:textreader/sendText.dart';


class ShowText extends StatefulWidget {
  final File pickedImage;
  ShowText(this.pickedImage);
  @override
  _ShowTextState createState() => _ShowTextState(pickedImage);
}

class _ShowTextState extends State<ShowText> {
  File pickedImage;
  String text="";
  TextEditingController _controller;
  bool textRead = false;

  _ShowTextState(this.pickedImage);

  Future readText() async {
    FirebaseVisionImage ourImage = FirebaseVisionImage.fromFile(pickedImage);
    TextRecognizer recognizeText = FirebaseVision.instance.textRecognizer();
    VisionText readText = await recognizeText.processImage(ourImage);

    for (TextBlock block in readText.blocks) {
      for (TextLine line in block.lines) {
        for (TextElement word in line.elements) {
          text = "$text ${word.text}";
        }
      }
    }

    setState(() {
      textRead = true;
      _controller = new TextEditingController(text: text);
    });

  }

  @override
  void initState() {
    super.initState();
    readText();
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
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
          children: [
        Center(
          child: Container(
            width: MediaQuery.of(context).size.width*0.9,
            child: TextFormField(
              maxLines: 5,
              controller: _controller,
              style: TextStyle(
                color: Colors.black
              ),
              decoration: new InputDecoration(
                labelText: "Detected Text",
                labelStyle: TextStyle(
                  color: Colors.black
                ),
                fillColor: Colors.white,
                enabledBorder: new OutlineInputBorder(
                  borderRadius: new BorderRadius.circular(25.0),
                  borderSide: new BorderSide(
                      color: Colors.blue, width: 4.0
                  ),
                ),
                border: new OutlineInputBorder(
                  borderRadius: new BorderRadius.circular(25.0),
                  borderSide: new BorderSide(
                      color: Colors.blue, width: 4.0
                  ),
                )
              ),
              keyboardType: TextInputType.text,
            ),
          ),
        ),
            IconButton(
              icon: Icon(
                Icons.share,
                color: Color(0xFF2d3447),
                size: 27,
              ),
              onPressed: () {
                Share.share(
                    '${_controller.text}' );
              },
            ),
            RaisedButton(
              child: Text(
                'Capture an Image',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                ),
              ),
              color: Colors.deepOrange,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30)),
              padding: EdgeInsets.all(15),
              onPressed: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SendText(_controller)),
                );
              },
            ),

      ]),
    );
  }
}
