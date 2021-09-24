import 'package:data_tective/settings.dart';
import 'package:data_tective/shared.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:new_gradient_app_bar/new_gradient_app_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';
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

  String _sticker = '0';
  SharedPreferences _prefs;

  void _handleURLButtonPress(BuildContext context, var type) {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => ImageFromGalleryEx(type, _sticker)));
  }

  void initState() {
    super.initState();  // initState()를 사용할 때 반드시 사용해야 한다.
    _loadId();  // 이 함수를 실행한다.
  }

  _loadId() async {
    _prefs = await SharedPreferences.getInstance(); // 캐시에 저장되어있는 값을 불러온다.
    setState(() { // 캐시에 저장된 값을 반영하여 현재 상태를 설정한다.
      // SharedPreferences에 id, pw로 저장된 값을 읽어 필드에 저장. 없을 경우 0으로 대입
      _sticker = (_prefs.getString('sticker') ?? '0');
      print(_sticker); // Run 기록으로 id와 pw의 값을 확인할 수 있음.
    });
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
          TextButton(
            onPressed: () {
              _sticker = '0';
              _prefs.setString('sticker', _sticker);
            },
            child: Column(
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
          ),
          TextButton(
            onPressed: () {
              _sticker = '1';
              _prefs.setString('sticker', _sticker);
            },
            child: Column(
              children: [
                Expanded(child: Image.asset('assets/heart.png', fit: BoxFit.contain,)),
                SizedBox(height: 20,),
                Text(
                  'Heart',
                  style: TextStyle(
                      fontSize: 30,
                      fontFamily: 'Staatliches-Regular'
                  ),),
              ],
            ),
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
      TextButton(
        onPressed: () {},
        child: Text('Working on it!!'),
      ),
    ];
    return Scaffold(
      appBar: NewGradientAppBar(
        elevation: 0,
        gradient: LinearGradient(
          colors: [const Color(0xff647dee), const Color(0xff7f53ac)]
        ),
        title: Padding(
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
        gradient: LinearGradient(
            colors: [const Color(0xff7f53ac), const Color(0xff647dee)]
        ),
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

