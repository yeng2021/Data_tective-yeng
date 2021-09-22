import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

ImagePicker imagePicker = ImagePicker();

enum Mask {BLUR, IMAGE}

class Settings extends StatefulWidget {

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  var _image;
  var _mask = Mask.BLUR;
  final int cover = 0;

  void openImagePicker() async {
    XFile image = await imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 50);
    setState(() {
      _image = File(image.path);
    });
  }

  // blurInt() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   prefs.setInt('intValue', 1);
  // }
  //
  // coverInt() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   prefs.setInt('intValue', 0);
  // }
  //
  // getIntValuesSF() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   //Return int
  //   int intValue = prefs.getInt('intValue');
  //   return intValue;
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
      ),
      body: Center(
        child: Column(
          children: [
            RadioListTile(
                title: Text('블러'),
                value: Mask.BLUR,
                groupValue: _mask,
                onChanged: (value) {
                  setState(() {
                    _mask = value;
                  });
                }),
            RadioListTile(
                title: Text('스티커'),
                value: Mask.IMAGE,
                groupValue: _mask,
                onChanged: (value) {
                  openImagePicker();
                  setState(() {
                    _mask = value;
                  });
                })
          ],
        ),
      ),
    );
  }
}
