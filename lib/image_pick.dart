import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:data_tective/detect/detection_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:ui' as ui show Image;

ImagePicker picker = ImagePicker();

enum ImageSourceType { gallery, camera }

// class Imagepick extends StatelessWidget {
//
//   void _handleURLButtonPress(BuildContext context, var type) {
//     Navigator.push(context,
//         MaterialPageRoute(builder: (context) => ImageFromGalleryEx(type)));
//   }
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         elevation: 0,
//         backgroundColor: const Color(0xff0063ff),
//         leadingWidth: 600,
//         leading: Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: Row(
//             children: [
//               Image.asset("assets/logo-white.png", width: 50,),
//               SizedBox(width: 10),
//               Image.asset("assets/logo-text-white.png", width: 100)
//             ],
//           ),
//         ),
//       ),
//       body: Center(
//         child: Container(
//           padding: EdgeInsets.symmetric(vertical: 30.0, horizontal: 50.0),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             crossAxisAlignment: CrossAxisAlignment.stretch,
//             children: [
//               Expanded(
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   crossAxisAlignment: CrossAxisAlignment.stretch,
//                   children: [
//                     IconButton(
//                       icon: Icon(Icons.image),
//                       iconSize: 150,
//                       onPressed: () {
//                         _handleURLButtonPress(context, ImageSourceType.gallery);
//                       },
//                     ),
//                     Center(
//                       child: Container(
//                         child: Text(
//                           'Gallery',
//                           style: TextStyle(
//                             fontSize: 28.0,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               SizedBox(height: 80.0),
//               Expanded(
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   crossAxisAlignment: CrossAxisAlignment.stretch,
//                   children: [
//                     IconButton(
//                       icon: Icon(Icons.photo_camera),
//                       iconSize: 150,
//                       onPressed: () {
//                         _handleURLButtonPress(context, ImageSourceType.camera);
//                       },
//                     ),
//                     Center(
//                       child: Container(
//                         child: Text(
//                           'Camera',
//                           style: TextStyle(
//                             fontSize: 28.0,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//       bottomNavigationBar: ConvexAppBar(
//         top: -25,
//         backgroundColor: const Color(0xff0063ff),
//         // activeColor: const Color(0xffff9d00),
//         style: TabStyle.fixedCircle,
//         elevation: 0,
//         items: [
//           TabItem(icon: Icons.star, title: 'Sticker'),
//           TabItem(icon: Icons.add, title: 'Add'),
//           TabItem(icon: Icons.people, title: 'Profile'),
//         ],
//         initialActiveIndex: 1,//optional, default as 0
//         onTap: (int i) => print('click index=$i'),
//       ),
//     );
//   }
// }

class ImageFromGalleryEx extends StatefulWidget {
  final type;
  final _sticker;
  ImageFromGalleryEx(this.type, this._sticker);

  @override
  ImageFromGalleryExState createState() => ImageFromGalleryExState(this.type, this._sticker);
}

class ImageFromGalleryExState extends State<ImageFromGalleryEx> {
  var _image;
  var imagePicker;
  var type;

  var _sticker;

  ui.Image imageSelected;
  List<Face> faces = [];

  ImageFromGalleryExState(this.type, this._sticker);

  @override
  void initState() {
    super.initState();
    imagePicker = new ImagePicker();
    openImagePicker();
  }

  void openImagePicker() async {
    var source = type == ImageSourceType.camera
        ? ImageSource.camera
        : ImageSource.gallery;
    XFile image = await imagePicker.pickImage(
        source: source,
        imageQuality: 50,
        preferredCameraDevice: CameraDevice.front);
    setState(() {
      _image = File(image.path);
    });
  }

  void send(BuildContext context, var file) {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => DetectionScreen(file, _sticker)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          actions: [
            IconButton(
                onPressed: () {print(type);},
                icon: Icon(Icons.print)
            )
          ],
      ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 50.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Center(
              child: GestureDetector(
                onTap: () {
                  openImagePicker();
                },
                child: Expanded(
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height * 0.7,
                    // decoration: BoxDecoration(
                    //     color: Colors.red[200]),
                    child: _image != null
                        ? Container(
                      child: Column(
                        children: [
                          Expanded(
                            child: FittedBox(
                              child: Image.file(
                                _image,
                                width: 200.0,
                                height: 200.0,
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                          SizedBox(height: 30.0),
                          OutlinedButton.icon(
                            onPressed: () {
                              send(context, _image);
                            },
                            icon: Icon(
                              Icons.check,
                              size: 30,
                              color: Colors.green,
                            ),
                            label: Text(
                              '선택',
                              style: TextStyle(fontSize: 20.0),),
                          ),
                        ],
                      ),
                    )
                        : Container(
                      // decoration: BoxDecoration(
                      //     color: Colors.cyan),
                      // width: 200,
                      // height: 200,
                      child: Icon(
                        Icons.camera_alt,
                        size: 150,
                        color: Colors.grey[800],
                      ),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}