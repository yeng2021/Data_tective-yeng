import 'dart:ui';
import 'package:flutter/material.dart';
import 'dart:ui' as ui show Image;
import 'package:google_ml_kit/google_ml_kit.dart';

class Blur extends StatefulWidget {
  final faces;
  final images;
  final imageSelected;
  Blur(this.faces, this.images, this.imageSelected);
  @override
  _BlurState createState() => _BlurState(this.faces, this.images, this.imageSelected);
}

class _BlurState extends State<Blur> {
  List<Face> faces;
  final images;
  ui.Image imageSelected;
  double _sigma = 3;

  _BlurState(this.faces, this.images, this.imageSelected);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xff0063ff),
        actions: [
          TextButton(onPressed: () {},
              child: Text(
                  '완료',
                style: TextStyle(color: Colors.white),
              ))
        ],
      ),
      body: Column(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.8,
            child: FittedBox(
              fit: BoxFit.contain,
              child: Stack(
                children: <Widget>[
                  Container(
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
          Container(
            width: MediaQuery.of(context).size.width*0.6,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('블러강도:', style: TextStyle(fontSize: 20),),
                Expanded(
                  child: Slider.adaptive(
                    min: 0,
                      max: 25,
                      value: _sigma,
                      onChanged:(value) {
                        setState(() {
                          _sigma = value;});}),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}