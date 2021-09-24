// import 'package:data_tective/settings.dart';
// import 'package:flutter/material.dart';
// import 'home copy.dart';
// import 'image_pick.dart';
// import 'package:convex_bottom_bar/convex_bottom_bar.dart';
// import 'package:data_tective/detect/detection_screen.dart';
// import 'package:flutter/material.dart';
// import 'package:google_ml_kit/google_ml_kit.dart';
// import 'package:image_picker/image_picker.dart';
// import 'dart:io';
// import 'dart:ui' as ui show Image;
//
// ImagePicker picker = ImagePicker();
//
// enum ImageSourceType { gallery, camera }
//
// class HomeCopy extends StatefulWidget {
//   @override
//   State<HomeCopy> createState() => _HomeState();
// }
//
// class _HomeState extends State<HomeCopy> {
//
//   int _selectedIndex = 1;
//
//   void _handleURLButtonPress(BuildContext context, var type) {
//     Navigator.push(context,
//         MaterialPageRoute(builder: (context) => ImageFromGalleryEx(type)));
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     List _widgetOptions = [
//       Text('Hi'),
//       // Center(
//       //   child: Container(
//       //     padding: EdgeInsets.symmetric(vertical: 30.0, horizontal: 50.0),
//       //     child: Column(
//       //       mainAxisAlignment: MainAxisAlignment.center,
//       //       crossAxisAlignment: CrossAxisAlignment.stretch,
//       //       children: [
//       //         Expanded(
//       //           child: Column(
//       //             mainAxisAlignment: MainAxisAlignment.center,
//       //             crossAxisAlignment: CrossAxisAlignment.stretch,
//       //             children: [
//       //               IconButton(
//       //                 icon: Icon(Icons.check_circle),
//       //                 iconSize: 150,
//       //                 onPressed: () {
//       //                   Navigator.push(
//       //                     context,
//       //                     MaterialPageRoute(builder: (context) => Imagepick()),
//       //                   );
//       //                 },
//       //               ),
//       //               Center(
//       //                 child: Container(
//       //                   child: Text(
//       //                     'Check',
//       //                     style: TextStyle(
//       //                       fontSize: 28.0,
//       //                     ),
//       //                   ),
//       //                 ),
//       //               ),
//       //             ],
//       //           ),
//       //         ),
//       //         SizedBox(height: 80.0),
//       //         Expanded(
//       //           child: Column(
//       //             mainAxisAlignment: MainAxisAlignment.center,
//       //             crossAxisAlignment: CrossAxisAlignment.stretch,
//       //             children: [
//       //               IconButton(
//       //                 icon: Icon(Icons.settings),
//       //                 iconSize: 150,
//       //                 onPressed: () {
//       //                   Navigator.push(
//       //                     context,
//       //                     MaterialPageRoute(builder: (context) => Settings()),
//       //                   );
//       //                 },
//       //               ),
//       //               Center(
//       //                 child: Container(
//       //                   child: Text(
//       //                     'Settings',
//       //                     style: TextStyle(
//       //                       fontSize: 28.0,
//       //                     ),
//       //                   ),
//       //                 ),
//       //               ),
//       //             ],
//       //           ),
//       //         ),
//       //       ],
//       //     ),
//       //   ),
//       // ),
//       Center(
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
//       Text('Bye'),
//     ];
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
//         child: _widgetOptions.elementAt(_selectedIndex),
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
//         onTap: (int index) {
//           setState(() {
//             _selectedIndex = index;
//           });
//         },
//       ),
//     );
//   }
// }
//
