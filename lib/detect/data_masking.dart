import 'package:flutter/material.dart';
import 'package:new_gradient_app_bar/new_gradient_app_bar.dart';
import 'package:toggle_switch/toggle_switch.dart';

class DataMasking extends StatefulWidget { //테스트 해보려고 만든 페이지입니다!! 그냥 무시해주세요
  const DataMasking({Key key}) : super(key: key);

  @override
  _DataMaskingState createState() => _DataMaskingState();
}

class _DataMaskingState extends State<DataMasking> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: NewGradientAppBar(
        elevation: 0,
        gradient: const LinearGradient(
            colors: [Color(0xff647dee), Color(0xff7f53ac)]
        ),
        title: const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
            '사진 검열하기',
            style: TextStyle(
                fontFamily: 'SCDream4'
            ),),
        ),
      ),
      body: Column(
        children: [
          ToggleSwitch(
            minWidth: 90.0,
            cornerRadius: 20.0,
            inactiveFgColor: Colors.white,
            initialLabelIndex: 1,
            totalSwitches: 3
            ,
            labels: const ['Normal', 'Bold', 'Italic'],
            customTextStyles: const [
              null,
              TextStyle(
                  color: Colors.brown,
                  fontSize: 18.0,
                  fontWeight: FontWeight.w900),
              TextStyle(
                  color: Colors.black,
                  fontSize: 16.0,
                  fontStyle: FontStyle.italic)
            ],
            onToggle: (index) {
              print('switched to: $index');
            },
          ),
        ],
      ),
    );
  }
}
