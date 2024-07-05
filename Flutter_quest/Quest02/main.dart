import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(), // 메인 페이지 설정
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.blue, // 앱바 색상 파란색
            title: SizedBox(
              height: kToolbarHeight, // AppBar의 기본 높이로 (수직으로도 가운데로 오도록)
              child: Stack(
                // Stack으로 겹쳐지도록해서 text는 가운데로 올 수있게
                children: [
                  Align(
                    alignment: Alignment.centerLeft, // 아이콘 좌측 정렬
                    child: Icon(
                      Icons.home,
                      size: 50.0,
                      color: Colors.white,
                    ),
                  ),
                  Center(
                    child: Text(
                      '플러터 앱 만들기',
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            )
            // 앱바 좌측 상단 아이콘 추가
            ),
        body: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start, // 열을 상단 정렬
              children: [
                SizedBox(height: 70), // 상단 여백
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      print('버튼이 눌렸습니다'); // 버튼 클릭 시 메시지 출력
                    },
                    child: Text('Text'),
                  ),
                ),
              ],
            ),
            Align(
              alignment: Alignment.center, // 정사각형을 화면 중앙에 배치
              child: SizedBox(
                width: 300,
                height: 300,
                child: Stack(
                  children: [
                    Positioned(
                      left: 0,
                      top: 0,
                      child: Container(
                        width: 300,
                        height: 300,
                        color: Colors.red, // 바깥쪽 컨테이너 색상 빨강
                      ),
                    ),
                    Positioned(
                      left: 0,
                      top: 0,
                      child: Container(
                        width: 240, // 차례대로 60씩 감소
                        height: 240,
                        color: Colors.orange,
                      ),
                    ),
                    Positioned(
                      left: 0,
                      top: 0,
                      child: Container(
                        width: 180,
                        height: 180,
                        color: Colors.yellow,
                      ),
                    ),
                    Positioned(
                      left: 0,
                      top: 0,
                      child: Container(
                        width: 120,
                        height: 120,
                        color: Colors.green,
                      ),
                    ),
                    Positioned(
                      left: 0,
                      top: 0,
                      child: Container(
                        width: 60,
                        height: 60,
                        color: Colors.blue,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/* 회고

기홍:

위젯에도 조합이 있는 것 같다. Stack은 Positioned과 꿀조합이란 것! 
그리고 한나님과 같이 하면서 한나님의 질문을 통해, 디바이스의 크기에 따라 
보이는 것이 다르기에 비율로 크기를 조정해야 나중에 뒷 탈이 생기지 않을 것 같다는 깨달음이 있었다. 
생각하는대로 UI를 잘 움직이려면 기본적인 속성을 이해해야 여러가지 응용이 가능할 것 같다.

한나:

다양한 위젯과 레이아웃 구성 방법을 학습하면서 Flutter와 Dart에 대한 이해도가 크게 향상되었습니다.  
요구사항에 맞게 UI를 구성하는 과정에서 정사각형 컨테이너와 버튼의 위치 조정이 필요했습니다.   
기홍님이 `Align`, `Positioned` 위젯을 활용하여  조정하면서 정확한 위치에 배치했습니다.  추후 기종에 따라 화면 비율로 해야 된다는 것을 깨닫게 되었습니다.

*/