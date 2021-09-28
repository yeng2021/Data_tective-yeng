import 'dart:io';
import 'dart:ui';
import 'dart:ui' as ui show Image;
import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:new_gradient_app_bar/new_gradient_app_bar.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:touchable/touchable.dart';
import 'blur.dart';
import 'sticker_cover.dart';

class DetectionScreen extends StatefulWidget {
  final File imageFile;
  final int _stickerId;
  const DetectionScreen(this.imageFile, this._stickerId);

  @override
  _DetectionScreenState createState() => _DetectionScreenState(imageFile, _stickerId);
}

class _DetectionScreenState extends State<DetectionScreen> {
  // ui.Image imageSelected;
  // List<Face> faces;

  File imageFile;
  final int _stickerId;
  _DetectionScreenState(this.imageFile, this._stickerId);

  ui.Image imageImage;
  List<Face> faces = [];
  List<TextBlock> textBlocks = [];

  double _sigma = 5;

  bool blurVisibility = true;
  bool stickerVisibility = false;

  int selectedIndex = 0;

  int _stickerId2 = 0;

  @override
  void initState() {
    super.initState();
    getImage();
  }

  void _blurShow() {
    setState(() {
      blurVisibility = true;
    });
  }
  void _blurHide() {
    setState(() {
      blurVisibility = false;
    });
  }

  void _stickerShow() {
    setState(() {
      stickerVisibility = true;
    });
  }
  void _stickerHide() {
    setState(() {
      stickerVisibility = false;
    });
  }

  void getImage() async {
    var imageFile3 = await imageFile.readAsBytes();
    ui.Image imageFile2 = await decodeImageFromList(imageFile3);

    final InputImage inputImage = InputImage.fromFilePath(imageFile.path);
    final FaceDetector faceDetector = GoogleMlKit.vision.faceDetector(const FaceDetectorOptions(
      enableClassification: true,
      enableTracking: true,
    ));
    final TextDetector textDetector = GoogleMlKit.vision.textDetector();

    final List<Face> outputFaces = await faceDetector.processImage(inputImage);
    final recognisedText = await textDetector.processImage(inputImage);
    final List<TextBlock> outputBlocks = recognisedText.blocks;

    setState(() {
      imageImage = imageFile2;
      faces = outputFaces;
      textBlocks = outputBlocks;
    });
  }

  void _sendBlurFace(context, var faces, var images, var imageSelected) {
    Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => Blur(faces, images, imageSelected)),
    );
  }

  void _sendCoverFace(context, var faces, var imageSelected, var _stickerId) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ImageCover(faces, imageSelected, _stickerId)),
    );
  }

  static const List<Map<String, dynamic>> stickers = <Map<String, dynamic>>[
    <String, dynamic>{
      'name': 'heart',
      'img': 'assets/sticker2.png',
    },
    <String, dynamic>{
      'name': 'heart',
      'img': 'assets/sticker2.png',
    },
    <String, dynamic>{
      'name': 'heart',
      'img': 'assets/sticker2.png',
    },
    <String, dynamic>{
      'name': 'heart',
      'img': 'assets/sticker2.png',
    },
  ];

  void checkOption(int index) {
    setState(() {
      _stickerId2 = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: NewGradientAppBar(
        elevation: 0,
        gradient: const LinearGradient(
            colors: [Color(0xff647dee), Color(0xff7f53ac)]
        ),
        title: const Text(
          '사진 검열',
          style: TextStyle(
              fontFamily: 'Staatliches-Regular'
          ),),
        // actions: [
        //   TextButton(
        //       onPressed: () {
        //         _stickerId == 1
        //             ?_sendBlurFace(context, faces, imageFile, imageImage)
        //             :_sendCoverFace(context,faces,imageImage, _stickerId);
        //       },
        //       child: const Text('완료', style: TextStyle(color: Colors.white),)),
        //   TextButton(
        //       onPressed: () {
        //         for(TextBlock block in textBlocks) {
        //           for (TextLine line in block.lines) {
        //             print('text: ${line.text}');
        //           }
        //         }
        //       },
        //       child: const Text('읽기', style: TextStyle(color: Colors.white),))
        // ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Flexible(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                child: Center(
                  child: ToggleSwitch(
                    minWidth: MediaQuery.of(context).size.width,
                    cornerRadius: 20.0,
                    activeBgColors: const [[Color(0xff647dee)], [Color(0xff647dee)]],
                    activeFgColor: Colors.white,
                    inactiveBgColor: Colors.transparent,
                    inactiveFgColor: Colors.black,
                    initialLabelIndex: selectedIndex,
                    totalSwitches: 2,
                    labels: const ['블러', '스티커'],
                    radiusStyle: true,
                    onToggle: (index) {
                      setState(() {
                        selectedIndex = index;
                      });
                      if (selectedIndex == 0) {
                        _blurShow();
                        _stickerHide();
                      }
                      else {
                        _blurHide();
                        _stickerShow();
                      }
                      selectedIndex = index;
                      print(selectedIndex);
                    },
                  ),
                ),
              ),
            ),
            Flexible(
              flex: 10,
              child: FittedBox(
                fit: BoxFit.contain,
                 child: Stack(
                   children: [SizedBox(
                     height: imageImage != null
                       ?imageImage.height.toDouble()
                     :300,
                     width: imageImage != null
                       ?imageImage.width.toDouble()
                     :300,
                     // child: Image.file(image),
                     child: CanvasTouchDetector(
                       builder: (context) => CustomPaint(
                         painter: FaceDraw(context, faces: faces, imageImage: imageImage, textBlocks: textBlocks),
                       ),
                     ),
                   ),
                     for(Face face in faces)
                       Visibility(
                         visible: blurVisibility,
                         child: Positioned(
                           top: face.boundingBox.top,
                           left: face.boundingBox.left,
                           child: Center(
                             child: ClipRect(
                               child: BackdropFilter(
                                 filter: ImageFilter.blur(
                                   sigmaX: imageImage.width*_sigma*0.001,
                                   sigmaY: imageImage.height*_sigma*0.001,
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
                       ),
              ]
                 ),
              ),
            ), //TODO: 스티커로 가리는 거 추가
            Flexible(
              flex: 3,
              child: Visibility(
                visible: blurVisibility,
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Slider.adaptive(
                        min: 0,
                        max: 10,
                        divisions: 10,
                        value: _sigma,
                        onChanged:(value) {
                          setState(() {
                            _sigma = value;
                          });
                        }),
                  ),
                ),
              ),
            ),
            Flexible(
              flex: 3,
              child: Visibility(
                visible: stickerVisibility,
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: GridView.count(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      crossAxisCount: 1,
                      mainAxisSpacing: 2,
                      children: [
                        for (int i = 0; i < stickers.length; i++)
                          StickerOption(
                            stickers[i]['name'] as String,
                            img: stickers[i]['img'] as String,
                            onTap: () => checkOption(i + 1),
                            selected: i + 1 == _stickerId2,
                          )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
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
  ui.Image imageImage;
  final BuildContext context;

  FaceDraw(this.context,{@required this.faces, @required this.imageImage, @required this.textBlocks});

  @override

  void paint(Canvas canvas, Size size) {
    TouchyCanvas touchyCanvas = TouchyCanvas(context, canvas);

    touchyCanvas.drawImage(
        imageImage,
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
                    title: const Text('개인고유식별 번호 노출 위험'),
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
        Offset(textBlock.rect.left + 160, textBlock.rect.top - 12),
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
          text: "자동차 번호판 노출 위험!",
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
                Offset(face.boundingBox.left + 120, face.boundingBox.top - 12),
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
          text: "초상권 침해 위험!",
        ),
        textAlign: TextAlign.center,
        textDirection: TextDirection.ltr,
      );

      paintSpanId.layout();
      paintSpanId.paint(canvas, Offset(face.boundingBox.left + 10, face.boundingBox.top - 20));
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

class StickerOption extends StatelessWidget {

  const StickerOption(
      this.title, {
        Key key,
        this.img,
        this.onTap,
        this.selected,
      }) : super(key: key);

  final String title;
  final String img;
  final VoidCallback onTap;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Ink.image(
      fit: BoxFit.contain,
      image: AssetImage(img),
      child: InkWell(
        onTap: onTap,
        child: Align(
          alignment: Alignment.bottomCenter,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            decoration: BoxDecoration(
                border: Border(
                    bottom: BorderSide(
                      color: selected ?? false ? const Color(0xff647dee) : Colors.transparent,
                      width: selected ?? false ? 10 : 0,
                    )
                )
            ),
            padding: const EdgeInsets.all(8.0),
            child: Row(children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: selected ?? false
                      ? const Color(0xff7f53ac)
                      : Colors.black54,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  title ?? '',
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 16,
                      fontFamily: 'Staatliches-Regular'
                  ),
                ),
              )
            ],),
          ),
        ),
      ),
    );
  }
}