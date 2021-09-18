import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:fluttertoast/fluttertoast.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var myInitialItem = 'Soap';
  List<String> myItems = [
    'Soap',
    'Sugar',
    'Water',
    'Soft Drink',
    'Napkins',
    'Pen',
    'Milk',
    'Lentils',
    'Wheat',
    'Barely',
  ];
  File _file;
  TextEditingController nameController = TextEditingController();
  TextEditingController priceController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Camera"),
        actions: _file != null
            ? <Widget>[
                IconButton(
                  icon: Icon(Icons.file_download),
                  color: Colors.white,
                  onPressed: _onClickSave,
                )
              ]
            : null,
      ),
      body: Center(
          child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _file != null
                ? Column(
                    children: [
                      Padding(
                          padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                          child: DropdownButton(
                            onChanged: (value) {
                              setState(() {
                               myInitialItem = value;
                              });
                              log(myInitialItem);
                            },
                            value: myInitialItem,
                            items: myItems.map((item) {
                              return DropdownMenuItem(
                                  value: item, child: Text(item));
                            }).toList(),
                          ) //dropdownButton
                          ),
                      Padding(
                          padding: EdgeInsets.all(20),
                          child: TextField(
                            controller: priceController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: 'Enter price'),
                          )),
                      Padding(
                          padding: EdgeInsets.all(20),
                          child: Image.file(_file)),
                    ],
                  )
                : Image.asset(
                    "assets/images/camera.png",
                    width: 140,
                  ),
          ],
        ),
      )),
      floatingActionButton: FloatingActionButton(
        onPressed: _onClickCamera,
        tooltip: 'Camera',
        child: Icon(Icons.camera),
      ),
    );
  }

  void _onClickCamera() async {
    final image = await ImagePicker.pickImage(source: ImageSource.camera);
    print("image: $image");
    setState(() {
      this._file = image;
    });
  }

  void _onClickSave() async {
    if (_file != null) {
      final dir = await getExternalStorageDirectory();
      final myImagePath = '${dir.path}/Images';
      final myImgDir = await new Directory(myImagePath).create();
      var bytes = _file.readAsBytesSync();

      File data = new File("${dir.path}/data.txt");
      var savedImage;
      if (nameController.text?.isEmpty ?? true) {
        final timestamp = DateTime.now();
        savedImage = new File("$myImagePath/$timestamp.jpg")
          ..writeAsBytesSync(bytes);
        await data.writeAsString('${timestamp}, ${myInitialItem}, ${priceController.text}\n', mode: FileMode.append);
      } else {
        savedImage = new File("$myImagePath/${nameController.text}.jpg")
          ..writeAsBytesSync(bytes);
        await data.writeAsString(
            '${myInitialItem},${priceController.text}\n',
            mode: FileMode.append);
      }

      nameController.clear();
      priceController.clear();
      Fluttertoast.showToast(
          msg: "Data saved",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 2,
          backgroundColor: Colors.blue,
          textColor: Colors.white,
          fontSize: 16.0);
      log(savedImage.path);
      log("SUCCESS!!!");
    }
  }
}
