## AIFFEL Campus Online Code Peer Review Templete
- 코더 : 김기홍
- 리뷰어 : 서은재


## PRT(Peer Review Template)

- [o]  **1. 주어진 문제를 해결하는 완성된 코드가 제출되었나요?**
    - 주어진 조건에 맞게 코드를 완성해서 잘 제출하였습니다~
```
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

```
    
- [o]  **2. 전체 코드에서 가장 핵심적이거나 가장 복잡하고 이해하기 어려운 부분에 작성된 
주석 또는 doc string을 보고 해당 코드가 잘 이해되었나요?**
    - 코드마다 주석이 달려 있어 잘 이해할 수 있었습니다.
```
            backgroundColor: Colors.blue, // 앱바 색상 파란색
            title: SizedBox(
              height: kToolbarHeight, // AppBar의 기본 높이로 (수직으로도 가운데로 오도록)
              child: Stack(
                // Stack으로 겹쳐지도록해서 text는 가운데로 올 수있게
                children: [
                  Align(
                    alignment: Alignment.centerLeft, // 아이콘 좌측 정렬
```
        
- [o]  **3. 에러가 난 부분을 디버깅하여 문제를 “해결한 기록을 남겼거나” 
”새로운 시도 또는 추가 실험을 수행”해봤나요?**
    - text를 가운데로 오게 하기 위해 새로운 시도를 했다는 것을 알 수 있었습니다.
```
처음에는 가장 깔끔한 코드로 적용하려고 했지만, text가 정가운데 오지 않아서 다른 방법을 강구하였다.

appBar: AppBar(
  leading: Icon(Icons.menu), // 앱바 좌측 상단 아이콘 추가
  title: Text('플러터 앱 만들기'), // 중앙 텍스트 추가
  backgroundColor: Colors.blue, // 앱바 색상 파란색
)
```
        
- [o]  **4. 회고를 잘 작성했나요?**
    - 회고가 상세히 잘 작성되어 있습니다~
```
위젯에도 조합이 있는 것 같다. Stack은 Positioned과 꿀조합이란 것! 
그리고 한나님과 같이 하면서 한나님의 질문을 통해, 디바이스의 크기에 따라 
보이는 것이 다르기에 비율로 크기를 조정해야 나중에 뒷 탈이 생기지 않을 것 같다는 깨달음이 있었다. 
생각하는대로 UI를 잘 움직이려면 기본적인 속성을 이해해야 여러가지 응용이 가능할 것 같다.
```

- [o]  **5. 코드가 간결하고 효율적인가요?**
    - 간결하게 코드가 구현되어 있습니다
      


## 참고 링크 및 코드 개선
```
# 코드 리뷰 시 참고한 링크가 있다면 링크와 간략한 설명을 첨부합니다.
# 코드 리뷰를 통해 개선한 코드가 있다면 코드와 간략한 설명을 첨부합니다.
```
