import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Future<Album> createAlbum(String title) async {
  final http.Response response = await http.post(
    '',//API here
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'title': title,
    }),
  );

  if (response.statusCode == 201) {
    return Album.fromJson(json.decode(response.body));
  } else {
    throw Exception('Failed to create album.');
  }
}

class Album {
  final String text;

  Album({ this.text});

  factory Album.fromJson(Map<String, dynamic> json) {
    return Album(
      text: json['text'],
    );
  }
}


class SendText extends StatefulWidget {
  final TextEditingController _controller;
  SendText(this._controller);

  @override
  _SendTextState createState() {
    return _SendTextState(_controller);
  }
}

class _SendTextState extends State<SendText> {
  final TextEditingController _controller;
  Future<Album> _futureAlbum;
  _SendTextState(this._controller);

  @override
  void initState() {
    setState(() {
      setState(() {
        _futureAlbum = createAlbum(_controller.text);
      });
    },);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
      title: Text(
      "Send Text",
      style: TextStyle(
        color: Colors.white,
        fontSize: 22,
      ),
    ),
    backgroundColor: Colors.deepOrange,
    ),
        body: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(8.0),
          child: FutureBuilder<Album>(
            future: _futureAlbum,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Text(snapshot.data.text);
              } else if (snapshot.hasError) {
                return Text("${snapshot.error}");
              }

              return CircularProgressIndicator();
            },
          ),
        ),
      );
  }
}
