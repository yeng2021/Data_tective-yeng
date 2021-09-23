import 'package:data_tective/settings.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'home copy.dart';
import 'image_pick.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';

ImagePicker picker = ImagePicker();

enum ImageSourceType { gallery, camera }

class Home extends StatefulWidget {
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  int _selectedIndex = 1;

  void _handleURLButtonPress(BuildContext context, var type) {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => ImageFromGalleryEx(type)));
  }

  @override
  Widget build(BuildContext context) {
    List _widgetOptions = [
      Padding(
        padding: const EdgeInsets.fromLTRB(15, 8, 15, 8),
        child: GridView.count(
            crossAxisCount: 2,
          crossAxisSpacing: 80,
        mainAxisSpacing: 50,
        children: [
          Column(
            children: [
              Image.asset('assets/blur.png',),
              SizedBox(height: 20,),
              Text(
                  'Blur',
              style: TextStyle(
                fontSize: 30,
                fontFamily: 'Staatliches-Regular'
              ),),
            ],
          ),
          Column(
            children: [
              Image.asset('assets/heart.png', fit: BoxFit.scaleDown,),
              SizedBox(height: 20,),
              Text(
                'Heart',
                style: TextStyle(
                    fontSize: 30,
                    fontFamily: 'Staatliches-Regular'
                ),),
            ],
          ),
          Image.asset('assets/giyu.png'),
          Image.asset('assets/shinobu.png'),
          Image.asset('assets/logo-text.png'),
          Image.asset('assets/splash.png'),
        ],),
      ),
      Center(
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 30.0, horizontal: 50.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    IconButton(
                      icon: Icon(Icons.image),
                      iconSize: 150,
                      onPressed: () {
                        _handleURLButtonPress(context, ImageSourceType.gallery);
                      },
                    ),
                    Center(
                      child: Container(
                        child: Text(
                          '갤러리에서 이미지 가져오기',
                          style: TextStyle(
                            fontSize: 28.0,
                            fontFamily: 'SCDream4',
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 80.0),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    IconButton(
                      icon: Icon(Icons.photo_camera),
                      iconSize: 150,
                      onPressed: () {
                        _handleURLButtonPress(context, ImageSourceType.camera);
                      },
                    ),
                    Center(
                      child: Container(
                        child: Text(
                          '카메라에서 이미지 가져오기',
                          style: TextStyle(
                            fontSize: 28.0,
                            fontFamily: 'SCDream4',
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      Text('Working on it!!'),
    ];
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xff0063ff),
        leadingWidth: 600,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Image.asset("assets/logo-white.png", width: 50,),
              SizedBox(width: 10),
              Image.asset("assets/logo-text-white.png", width: 100)
            ],
          ),
        ),
        actions: [
          IconButton(onPressed: () {
            showDialog(
                context: context,
                barrierDismissible: true,
                builder: (BuildContext context) {
                  if (_selectedIndex==0) {
                  return AlertDialog(
                    title: Text('스티커 설정'),
                    content: SingleChildScrollView(
                      child: ListBody(
                        children: [
                          Text('사진을 검열할 방법을 설정할 수 있습니다.'),
                          Text('블러, 스티커를 활용하여 여러가지 방법으로 사진을 검열해보세요'),
                        ],
                      ),
                    ),
                  );}
                  if (_selectedIndex==1) {
                    return AlertDialog(
                      title: Text('사진 업로드'),
                      content: SingleChildScrollView(
                        child: ListBody(
                          children: [
                            Text('갤러리에서 이미지를 불러오거나 카메라를 사용해 직접 사진을 찍을 수 있습니다'),
                          ],
                        ),
                      ),
                    );}
                  if (_selectedIndex==2) {
                    return AlertDialog(
                      title: Text('자세한 설명'),
                      content: SingleChildScrollView(
                        child: ListBody(
                          children: [
                            Text('이 앱은 어쩌구 저쩌구'),
                          ],
                        ),
                      ),
                    );}
                }
            );
          },
              icon: Icon(Icons.help_outline))
        ],
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: ConvexAppBar(
        top: -25,
        backgroundColor: const Color(0xff0063ff),
        // activeColor: const Color(0xffff9d00),
        style: TabStyle.fixedCircle,
        elevation: 0,
        items: [
          TabItem(icon: Icons.star, title: 'Sticker'),
          TabItem(icon: Icons.add, title: 'Add'),
          TabItem(icon: Icons.live_help, title: 'Info'),
        ],
        initialActiveIndex: 1,//optional, default as 0
        onTap: (int index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}

