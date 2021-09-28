import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:new_gradient_app_bar/new_gradient_app_bar.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'dart:ui';
import 'dart:ui' as ui show Image;

class DataMasking extends StatefulWidget { //테스트 해보려고 만든 페이지입니다!! 그냥 무시해주세요

  final List<Face> faces;
  final File imageFile;
  final ui.Image imageImage;
  const DataMasking(this.faces, this.imageFile, this.imageImage);

  @override
  _DataMaskingState createState() => _DataMaskingState(faces, imageFile, imageImage);
}

class _DataMaskingState extends State<DataMasking> {

  List<Face> faces;
  File imageFile;
  ui.Image imageImage;
  _DataMaskingState(this.faces, this.imageFile, this.imageImage);

  int selectedIndex;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: NewGradientAppBar(
        elevation: 0,
        gradient: const LinearGradient(
            colors: [Color(0xff647dee), Color(0xff7f53ac)]
        ),
        title: const Text(
          '사진 검열하기',
          style: TextStyle(
              fontFamily: 'SCDream4'
          ),),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: ToggleSwitch(
              minWidth: MediaQuery.of(context).size.width,
              cornerRadius: 20.0,
              activeBgColors: const [[Color(0xff647dee)], [Color(0xff647dee)]],
              activeFgColor: Colors.white,
              inactiveBgColor: Colors.transparent,
              inactiveFgColor: Colors.black,
              initialLabelIndex: 1,
              totalSwitches: 2,
              labels: const ['블러', '스티커'],
              radiusStyle: true,
              onToggle: (index) {
                selectedIndex = index;
                print(selectedIndex);
              },
            ),
          ),
        ],
      ),
    );
  }
}
