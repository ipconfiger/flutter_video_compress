
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_video_compress/flutter_video_compress.dart';
import 'package:image_picker/image_picker.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  FlutterVideoCompress _flutterVideoCompress = FlutterVideoCompress();
  Uint8List _image;

  Future<void> _videoPicker() async {
    File file = await ImagePicker.pickVideo(source: ImageSource.camera);
    if (file != null && mounted) {
      _image = await _flutterVideoCompress
          .getThumbnail(path: file.path, quality: 50)
          .whenComplete(() {
        setState(() {});
      });
      final String newPath = await _flutterVideoCompress.compressVideo(
          path: file.path, deleteOrigin: true);
      print(newPath);
    }
  }

  @override
  Widget build(BuildContext context) {
    final _list = <Widget>[
      FlatButton(child: Text('take video'), onPressed: _videoPicker),
    ];
    if (_image != null) {
      _list.add(Flexible(child: Center(child: Image.memory(_image))));
    }
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Plugin example app')),
        body: Column(children: _list),
      ),
    );
  }
}