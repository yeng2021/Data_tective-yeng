import 'dart:ui';
import 'package:flutter/material.dart';
import 'dart:ui' as ui show Image;
import 'dart:io' show File;
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:new_gradient_app_bar/new_gradient_app_bar.dart';

class Blur extends StatefulWidget {
  final List<Face> faces;
  final File images;  // TODO: images 가 아니라 image 혹은 imageFile 로 해야하지 않을까?
  final ui.Image imageSelected;
  Blur(this.faces, this.images, this.imageSelected);

  @override
  _BlurState createState() => _BlurState(faces, images, imageSelected);
}

class _BlurState extends State<Blur> {
  List<Face> faces;
  File images;
  ui.Image imageSelected;
  double _sigma = 5;

  _BlurState(this.faces, this.images, this.imageSelected);

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
            '이미지 블러 처리',
            style: TextStyle(
                fontFamily: 'Staatliches-Regular'
            ),),
        ),
        actions: [
          TextButton(onPressed: () {},  // TODO: onPressed 구현 필요.
              child: const Text(
                '완료',
                style: TextStyle(color: Colors.white),
              ))
        ],
      ),
      body: Column(
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.8,
            child: FittedBox(
              fit: BoxFit.contain,
              child: Stack(
                children: <Widget>[
                  SizedBox(
                      height: imageSelected.height.toDouble(),
                      width: imageSelected.width.toDouble(),
                      child: Image.file(images)
                  ),
                  for(Face face in faces)
                  Positioned(
                    top: face.boundingBox.top,
                    left: face.boundingBox.left,
                    child: Center(
                      child: ClipRect(
                        child: BackdropFilter(
                          filter: ImageFilter.blur(
                            sigmaX: _sigma,
                            sigmaY: _sigma,
                          ),
                          child: Container(
                            // alignment: Alignment.center,
                            width: face.boundingBox.width,
                            height: face.boundingBox.height,
                            color: Colors.black.withOpacity(0),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width*0.6,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('블러강도:', style: TextStyle(fontSize: 20),),
                Expanded(
                  child: Slider.adaptive(
                      min: 0,
                      max: 100,
                      value: _sigma,
                      onChanged:(value) {
                        setState(() {
                          _sigma = value;
                        });
                      }),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}