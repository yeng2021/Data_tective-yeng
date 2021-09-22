import 'dart:io';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:ui' as ui show Image;
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:touchable/touchable.dart';
import 'package:image_picker/image_picker.dart';

ImagePicker imagePicker = ImagePicker();

class ImageCover extends StatefulWidget {
  final faces;
  final images;
  final imageSelected;
  ImageCover(this.faces, this.images, this.imageSelected);

  @override
  _ImageCoverState createState() => _ImageCoverState(this.faces, this.images, this.imageSelected);
}

class _ImageCoverState extends State<ImageCover> {
  List<Face> faces;
  final images;
  ui.Image imageSelected;
  var _image;
  ui.Image coverimage;

  _ImageCoverState(this.faces, this.images, this.imageSelected);



  @override
  void initState() {
    super.initState();
    openImagePicker();
  }

  void openImagePicker() async {
    XFile image = await imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 50);
    setState(() {
      _image = File(image.path);
    });
  }

  void getImage() async {
    var imageFile = await _image.readAsBytes();
    ui.Image imageFile2 = await decodeImageFromList(imageFile);

    setState(() {
      coverimage = imageFile2;
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xff0063ff),
        actions: [
          TextButton(onPressed: getImage,
              child: Text('검열', style: TextStyle(color: Colors.white),))
        ],
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height * 0.8,
        child: FittedBox(
          fit: BoxFit.contain,
          child: Container(
            height: imageSelected.height.toDouble(),
            width: imageSelected.width.toDouble(),
            child: CanvasTouchDetector(
              builder: (context) => CustomPaint(
                painter: FaceDraw(context, faces, imageSelected, coverimage),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class FaceDraw extends CustomPainter {
  List<Face> faces;
  ui.Image image;
  final BuildContext context;
  ui.Image coverimage;

  FaceDraw(this.context, this.faces, this.image, this.coverimage);

  @override

  void paint(Canvas canvas, Size size) {
    TouchyCanvas touchyCanvas = TouchyCanvas(context, canvas);

    touchyCanvas.drawImage(
        image,
        Offset.zero,
        Paint()
    );

    for (Face face in faces) {

      canvas.drawImageRect(
          coverimage,
          Offset.zero & Size(coverimage.width.toDouble(), coverimage.height.toDouble()),
          Offset(face.boundingBox.left, face.boundingBox.top) & Size(face.boundingBox.width, face.boundingBox.height),
          Paint());

    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
