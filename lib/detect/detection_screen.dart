import 'dart:ui';
import 'dart:ui' as ui show Image;
import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:touchable/touchable.dart';

import 'blur.dart';
import 'sticker_cover.dart';

class DetectionScreen extends StatefulWidget {
  final image;
  DetectionScreen(this.image);

  @override
  DetectionScreenState createState() => DetectionScreenState(this.image);
}

class DetectionScreenState extends State<DetectionScreen> {
  // ui.Image imageSelected;
  // List<Face> faces;

  var image;
  DetectionScreenState(this.image);

  ui.Image imageSelected;
  List<Face> faces = [];
  List<TextBlock> textBlocks = [];

  @override
  void initState() {
    super.initState();
    getImage();
  }

  void getImage() async {
    var imageFile = await image.readAsBytes();
    ui.Image imageFile2 = await decodeImageFromList(imageFile);

    final InputImage inputImage = InputImage.fromFilePath(image.path);
    final FaceDetector faceDetector = GoogleMlKit.vision.faceDetector(FaceDetectorOptions(
      enableClassification: true,
      enableTracking: true,
    ));
    final TextDetector textDetector = GoogleMlKit.vision.textDetector();

    final List<Face> outputFaces = await faceDetector.processImage(inputImage);
    final recognisedText = await textDetector.processImage(inputImage);
    final List<TextBlock> outputBlocks = recognisedText.blocks;

    setState(() {
      imageSelected = imageFile2;
      faces = outputFaces;
      textBlocks = outputBlocks;
    });
  }

  // void getImage() async {
  //   // final PickedFile pickedFile = await ImagePicker().getImage(source: ImageSource.gallery);
  //   // if (pickedFile != null) {
  //     var imageFile = await image.readAsBytes();
  //     ui.Image imageFile2 = await decodeImageFromList(imageFile);
  //
  //     final InputImage inputImage = InputImage.fromFilePath(image.path);
  //     final FaceDetector faceDetector = GoogleMlKit.vision.faceDetector(FaceDetectorOptions(
  //       enableClassification: true,
  //       enableTracking: true,
  //     ));
  //
  //     final List<Face> outputFaces = await faceDetector.processImage(inputImage);
  //
  //     setState(() {
  //       imageSelected = imageFile2;
  //       faces = outputFaces;
  //     });
  //   // }
  // }

  // double x = 0.0;
  // double y = 0.0;
  //
  // void _updateLocation(TapDownDetails details) {
  //   setState(() {
  //     x = details.globalPosition.dx;
  //     y = details.globalPosition.dy;
  //   });
  // }

  void _sendblurface(context, var faces, var images, var imageSelected) {
    Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => Blur(faces, images, imageSelected)),
    );
  }

  void _sendcoverface(context, var faces, var images, var imageSelected) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ImageCover(faces, images, imageSelected)),
    );
  }

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
        backgroundColor: const Color(0xff0063ff),
        actions: [
          TextButton(
              onPressed: () {
                _sendblurface(context, faces, image, imageSelected);
              },
              child: Text('블러', style: TextStyle(color: Colors.white),)),
          TextButton(
              onPressed: () {
                _sendcoverface(context, faces, image, imageSelected);
              },
              child: Text('가리기', style: TextStyle(color: Colors.white),)),
          TextButton(
              onPressed: () {
                for(TextBlock block in textBlocks) {
                  for (TextLine line in block.lines) {
                    print('text: ${line.text}');
                  }
                }
              },
              child: Text('읽기', style: TextStyle(color: Colors.white),))
        ],
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height * 0.8,
        child: InteractiveViewer(
          // constrained: false,
          // panEnabled: true,
          // boundaryMargin: EdgeInsets.all(1000),
          minScale: 0.1,
          maxScale: 5,
          child: FittedBox(
            fit: BoxFit.contain,
            child:
            // Image.asset('assets/splash.png')
            Stack(
              children: [
                if (imageSelected != null)
                  SizedBox(
                      height: imageSelected.height.toDouble(),
                      width: imageSelected.width.toDouble(),
                      child: Icon(
                        Icons.image,
                        size: imageSelected.width.toDouble() >= imageSelected.height.toDouble()
                            ? imageSelected.width.toDouble() :imageSelected.height.toDouble(),
                        color: Colors.transparent,
                      )
                  ),
                  Align(
                    alignment: Alignment.center,
                    child:
                    Container(
                      height: imageSelected.height.toDouble(),
                      width: imageSelected.width.toDouble(),
                      // child: Image.file(image),
                      child: CanvasTouchDetector(
                        builder: (context) => CustomPaint(
                          painter: FaceDraw(context, faces: faces, image: imageSelected, textBlocks: textBlocks),
                        ),
                      ),
                    ),
                  )
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {faces.clear();},
        tooltip: 'Select',
        child: Icon(Icons.image),
      ),
    );
  }
}

class FaceDraw extends CustomPainter {
  List<Face> faces;
  List<TextBlock> textBlocks;
  ui.Image image;
  final BuildContext context;

  FaceDraw(this.context,{@required this.faces, @required this.image, @required this.textBlocks});

  @override

  void paint(Canvas canvas, Size size) {
    TouchyCanvas touchyCanvas = TouchyCanvas(context, canvas);

    touchyCanvas.drawImage(
        image,
        Offset.zero,
        Paint()
    );

    for (TextBlock textBlock in textBlocks) {

      canvas.drawRect(
        Rect.fromLTRB(textBlock.rect.left, textBlock.rect.top, textBlock.rect.right, textBlock.rect.bottom),
        // face.boundingBox,
        Paint()
          ..style = PaintingStyle.stroke
          ..color = Colors.greenAccent
          ..strokeWidth = 4,
      );

      touchyCanvas.drawLine(
        Offset(textBlock.rect.left + 5, textBlock.rect.top - 12),
        Offset(textBlock.rect.right - 5, textBlock.rect.top - 12),
        Paint()
          ..color = Colors.red.withOpacity(0.8)
          ..strokeWidth = 18
          ..style = PaintingStyle.fill,);


      TextPainter paintSpanId = new TextPainter(
        text: TextSpan(
          style: new TextStyle(
            color: Colors.white,
            fontSize: 15,
            fontWeight: FontWeight.w400,
          ),
          text: "!",
        ),
        textAlign: TextAlign.center,
        textDirection: TextDirection.ltr,
      );

      paintSpanId.layout();
      paintSpanId.paint(canvas, new Offset(textBlock.rect.left + 10, textBlock.rect.top - 20));

    }

    for (Face face in faces) {

      // var da = Offset(face.boundingBox.left, face.boundingBox.top);
      // var db = Offset(face.boundingBox.right, face.boundingBox.top);
      // var dc = Offset(face.boundingBox.left, face.boundingBox.bottom);
      // var dd = Offset(face.boundingBox.right, face.boundingBox.bottom);

      // print("ID: ${face.trackingId}");
      // print(da);print(db);print(dc);print(dd);

      var blueRect = Rect.fromLTWH(face.boundingBox.left, face.boundingBox.top, face.boundingBox.width, face.boundingBox.height);

      touchyCanvas.drawRect(blueRect, Paint()
        ..color = Colors.transparent
          , onTapDown: (_) {
        showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('검열삭제'),
                content: SingleChildScrollView(
                  child: ListBody(
                    children: [
                      Text('이 검열을 해제하시겠습니까?'),
                      Text('다시 검열하기 위해서는 이미지 편집을 새로 시작하셔야 합니다'),
                      TextButton(
                        child: Row(
                          children: [
                            Text('자세히 보기',
                                style: TextStyle(color: Colors.red)),
                            SizedBox(width: 10,),
                            Icon(Icons.change_history),
                          ],
                        ),
                        onPressed: () {
                          print('You clicked' "ID: ${face.trackingId}");
                          faces.remove(face);
                          Navigator.of(context).pop();
                        },)
                    ],
                  ),
                ),
                actions: [
                  TextButton(
                    child: Text('취소'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },),
                  TextButton(
                    child: Text('해제',
                    style: TextStyle(color: Colors.red)),
                    onPressed: () {
                      print('You clicked' "ID: ${face.trackingId}");
                      faces.remove(face);
                      Navigator.of(context).pop();
                    },)
                ],
              );
            }
        );
      });

      touchyCanvas.drawRect(
          Rect.fromLTWH(face.boundingBox.left, face.boundingBox.top, face.boundingBox.width, face.boundingBox.height),
        // face.boundingBox,
        Paint()
          ..style = PaintingStyle.stroke
          ..color = Colors.greenAccent
          // ..imageFilter = ImageFilter.blur(sigmaX: 10, sigmaY: 10)
          ..strokeWidth = 4,
      );

      touchyCanvas.drawLine(
                Offset(face.boundingBox.left + 5, face.boundingBox.top - 12),
                Offset(face.boundingBox.right - 5, face.boundingBox.top - 12),
                Paint()
                  ..color = Colors.red.withOpacity(0.8)
                  ..strokeWidth = 18
                  ..style = PaintingStyle.fill,);


      TextPainter paintSpanId = new TextPainter(
        text: TextSpan(
          style: new TextStyle(
            color: Colors.white,
            fontSize: 15,
            fontWeight: FontWeight.w400,
          ),
          text: "!",
        ),
        textAlign: TextAlign.center,
        textDirection: TextDirection.ltr,
      );

      paintSpanId.layout();
      paintSpanId.paint(canvas, new Offset(face.boundingBox.left + 10, face.boundingBox.top - 20));

      // touchyCanvas.drawLine(
      //     Offset(face.boundingBox.left, face.boundingBox.bottom + 14),
      //     Offset(face.boundingBox.right, face.boundingBox.bottom + 14),
      //     Paint()
      //       ..color = Colors.black.withOpacity(0.7)
      //       ..strokeWidth = 20
      //       ..style = PaintingStyle.fill);

      // TextPainter paintSmilingStatus = new TextPainter(
      //   text: TextSpan(
      //     style: TextStyle(
      //       color: Colors.white,
      //       fontSize: 15,
      //       fontWeight: FontWeight.w700,
      //       fontFamily: 'Roboto',
      //     ),
      //     text: "Smiling::${face.smilingProbability >= 0.5 ? "Yes" : "No"}",
      //   ),
      //   textAlign: TextAlign.center,
      //   textDirection: TextDirection.ltr,
      // );
      //
      // paintSmilingStatus.layout();
      // paintSmilingStatus.paint(canvas, new Offset(face.boundingBox.left + 3, face.boundingBox.bottom + 5));
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
