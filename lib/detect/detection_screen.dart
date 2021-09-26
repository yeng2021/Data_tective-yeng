import 'dart:ui';
import 'dart:ui' as ui show Image;
import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:new_gradient_app_bar/new_gradient_app_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:touchable/touchable.dart';

import '../home.dart';
import 'blur.dart';
import 'sticker_cover.dart';

class DetectionScreen extends StatefulWidget {
  final image;   // TODO: type 정의 필요
  final int _stickerId;
  DetectionScreen(this.image, this._stickerId);

  @override
  _DetectionScreenState createState() => _DetectionScreenState(image, _stickerId);
}

class _DetectionScreenState extends State<DetectionScreen> {
  // ui.Image imageSelected;
  // List<Face> faces;

  var image;  // TODO: type 정의 필요
  int _stickerId;
  _DetectionScreenState(this.image, this._stickerId);

  ui.Image imageSelected;
  List<Face> faces = [];
  List<TextBlock> textBlocks = [];

  double imageHeight;
  double imageWidth;

  @override
  void initState() {
    super.initState();
    getImage();
  }

  void getImage() async {
    var imageFile = await image.readAsBytes();
    ui.Image imageFile2 = await decodeImageFromList(imageFile);

    final InputImage inputImage = InputImage.fromFilePath(image.path);
    final FaceDetector faceDetector = GoogleMlKit.vision.faceDetector(const FaceDetectorOptions(
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

  void _sendBlurFace(context, var faces, var images, var imageSelected) {
    Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => Blur(faces, images, imageSelected)),
    );
  }

  void _sendCoverFace(context, var faces, var images, var imageSelected, var _stickerId) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ImageCover(faces, images, imageSelected, _stickerId)),
    );
  }

  // getIntValuesSF() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   //Return int
  //   int intValue = prefs.getInt('intValue');
  //   return intValue;
  // }

  // final PanelController _panelController = PanelController();
  // bool _visible = false;
  //
  // Future<void> hidePanel() {
  //   _panelController.hide();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: NewGradientAppBar(
        elevation: 0,
        gradient: const LinearGradient(
            colors: [Color(0xff647dee), Color(0xff7f53ac)]
        ),
        title: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Image.asset("assets/logo-white.png", width: 50,),
              const SizedBox(width: 10),
              Image.asset("assets/logo-text-white.png", width: 100)
            ],
          ),
        ),
        actions: [
          TextButton(
              onPressed: () {
                _stickerId == 1
                    ?_sendBlurFace(context, faces, image, imageSelected)
                    :_sendCoverFace(context,faces,image,imageSelected, _stickerId);
              },
              child: const Text('완료', style: TextStyle(color: Colors.white),)),
          TextButton(
              onPressed: () {
                for(TextBlock block in textBlocks) {
                  for (TextLine line in block.lines) {
                    print('text: ${line.text}');
                  }
                }
              },
              child: const Text('읽기', style: TextStyle(color: Colors.white),))
        ],
      ),
      body: Center(
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height * 0.8,
          child: FittedBox(
            fit: BoxFit.contain,
             child: SizedBox(
               height: imageSelected != null
                 ?imageSelected.height.toDouble()
               :300,
               width: imageSelected != null
                 ?imageSelected.width.toDouble()
               :300,
               // child: Image.file(image),
               child: CanvasTouchDetector(
                 builder: (context) => CustomPaint(
                   painter: FaceDraw(context, faces: faces, image: imageSelected, textBlocks: textBlocks),
                 ),
               ),
             ),
             // Image.asset('assets/splash.png')
             // Stack(
             //   children: [
             //     if (imageSelected != null)
             //       SizedBox(
             //           height: imageSelected.height.toDouble(),
             //           width: imageSelected.width.toDouble(),
             //           child: Icon(
             //             Icons.image,
             //             size: imageSelected.width.toDouble() >= imageSelected.height.toDouble()
             //                 ? imageSelected.width.toDouble() :imageSelected.height.toDouble(),
             //             color: Colors.transparent,
             //           )
             //       ),
             //     Align(
             //       alignment: Alignment.center,
             //       child:
             //       Container(
             //         height: imageSelected.height.toDouble(),
             //         width: imageSelected.width.toDouble(),
             //         // child: Image.file(image),
             //         child: CanvasTouchDetector(
             //           builder: (context) => CustomPaint(
             //             painter: FaceDraw(context, faces: faces, image: imageSelected, textBlocks: textBlocks),
             //           ),
             //         ),
             //       ),
             //     )
             //   ],
             // ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          faces.clear();
          },
        tooltip: 'Select',
        child: const Icon(Icons.image),
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

      touchyCanvas.drawRect(Rect.fromLTRB(textBlock.rect.left, textBlock.rect.top, textBlock.rect.right, textBlock.rect.bottom), Paint()
        ..color = Colors.transparent
          , onTapDown: (_) {
            showDialog(
                context: context,
                barrierDismissible: false,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('개인고유식별 번호 유출 위험'),
                    content: SingleChildScrollView(
                      child: ListBody(
                        children: [
                          const Text('이 검열을 해제하시겠습니까?'),
                          const Text('다시 검열하기 위해서는 이미지 편집을 새로 시작하셔야 합니다'),
                          TextButton(
                            child: Row(
                              children: const [
                                Text('자세히 보기',
                                    style: TextStyle(color: Colors.red)),
                                Icon(Icons.chevron_right),
                              ],
                            ),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },)
                        ],
                      ),
                    ),
                    actions: [
                      TextButton(
                        child: const Text('취소'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },),
                      TextButton(
                        child: const Text('해제',
                            style: TextStyle(color: Colors.red)),
                        onPressed: () {
                          textBlocks.remove(textBlock);
                          Navigator.of(context).pop();
                        },)
                    ],
                  );
                }
            );
          });

      touchyCanvas.drawRect(
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


      TextPainter paintSpanId = TextPainter(
        text: const TextSpan(
          style: TextStyle(
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
      paintSpanId.paint(canvas, Offset(textBlock.rect.left + 10, textBlock.rect.top - 20));

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
                title: const Text('초상권 침해'),
                content: SingleChildScrollView(
                  child: ListBody(
                    children: [
                      const Text('이 검열을 해제하시겠습니까?'),
                      const Text('다시 검열하기 위해서는 이미지 편집을 새로 시작하셔야 합니다'),
                      TextButton(
                        child: Row(
                          children: const [
                            Text('자세히 보기',
                                style: TextStyle(color: Colors.red)),
                            Icon(Icons.chevron_right),
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
                    child: const Text('취소'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },),
                  TextButton(
                    child: const Text('해제',
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


      TextPainter paintSpanId = TextPainter(
        text: const TextSpan(
          style: TextStyle(
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
      paintSpanId.paint(canvas, Offset(face.boundingBox.left + 10, face.boundingBox.top - 20));

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
