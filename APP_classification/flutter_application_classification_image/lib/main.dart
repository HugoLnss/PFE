import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Image Classification App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late File _image = File('assets/default_image.jpg');
  String _prediction = "";
  

  Future _getImage() async {
    final imagePicker = ImagePicker();
    final pickedFile = await imagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      _image = pickedFile != null ? File(pickedFile.path) : _image;
      _prediction = "";
    });
    
  }

  Future<void> _classifyImage() async {
    if (_image == null) {
      return;
    }

    final url = Uri.parse('http://127.0.0.1:5000');
    var request = http.MultipartRequest('POST', url);
    request.files.add(await http.MultipartFile.fromPath('image', _image.path));

    try {
      var response = await request.send();
      if (response.statusCode == 200) {
        var jsonResponse = await response.stream.bytesToString();
        var decodedResponse = json.decode(jsonResponse);
        setState(() {
          _prediction = decodedResponse['predicted_class'];
        });
      } else {
        print('Request failed with status: ${response.statusCode}');
      }
    } catch (error) {
      print('Error sending request: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Image Classification App'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _image != null
                ? Image.file(
                    _image,
                    height: 150,
                  )
                : Text('Sélectionnez une image'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _getImage,
              child: Text('Uploader une image'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _classifyImage,
              child: Text('Classer l\'image'),
            ),
            SizedBox(height: 20),
            _prediction.isNotEmpty
                ? Text('La classe prédite pour l\'image est : $_prediction')
                : Container(),
          ],
        ),
      ),
    );
  }
}
