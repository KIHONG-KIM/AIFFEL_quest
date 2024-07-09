import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/first', // 시작 페이지 설정
      routes: {
        // 각 페이지 설정
        '/first': (context) => FirstPage(),
        '/second': (context) => SecondPage(),
      },
    );
  }
}

class FirstPage extends StatelessWidget {
  FirstPage({super.key});

  bool is_cat = true; // is_cat 변수 bool 타입으로 정의하고 true로 초기화

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            appBar: AppBar(
              leading: const Icon(  // Icon 추가
                Icons.favorite, // 아이콘 이름
                color: Colors.red, // 아이콘 색상
                size: 50.0, // 아이콘 크기
              ),
              title: const Text('FirstPage'), // 'FristPage' title 작
            ),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                      margin: const EdgeInsets.all(20),
                      // Next 버튼 추가
                      child: ElevatedButton(
                          onPressed: () async {
                            // ps. pop()으로 데이터를 보내는데, 데이터가 출력되지 않아서 한참 헤매다가
                            // async 와 await으로 데이터 받은 부분 비동기 호출을 통해서 출력할 수 있는 것으로 해결!
                            //
                            is_cat = false; // is_cat false로 변경
                            // pushNamed로 두번째 페이지로 전환
                            final result = await Navigator.pushNamed(
                                context, '/second',
                                arguments:
                                    is_cat); // argument에 is_cat 변수 담아서 보내기
                            print('$result'); // 콘솔에 is_cat 출력
                          },
                          child: const Text("Next"))),
                  const SizedBox( // 300 * 300 박스 생성
                      width: 300,
                      height: 300,
                      child: Image(
                        image: NetworkImage(// 이미지 네트워크 위젯으로 path로 불러오기,  300 * 300 크기 지정 
                            "https://flexible.img.hani.co.kr/flexible/normal/970/777/imgdb/resize/2019/0926/00501881_20190926.JPG"),
                        width: 300,
                        height: 300,
                        fit: BoxFit.cover,
                      ))
                ],
              ),
            )));
  }
}

class SecondPage extends StatelessWidget {
  const SecondPage({super.key});

  @override
  Widget build(BuildContext context) {
    bool is_cat = ModalRoute.of(context)?.settings.arguments as bool; // bool type 정의해서 ModalRoute 객체로 받아오기
    print(is_cat);

    return MaterialApp(
        home: Scaffold(
            appBar: AppBar(
              leading: const Icon(
                Icons.favorite, // 아이콘 이름
                color: Colors.red, // 아이콘 색상
                size: 50.0, // 아이콘 크기
              ),
              title: const Text('SecondPage'),
            ),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                      margin: const EdgeInsets.all(20),
                      child: ElevatedButton(
                          onPressed: () {
                            is_cat = true; // is_cat true로 변경하여 first page로 보내기
                            Navigator.pop(context, is_cat); // pop() 함수로 마지막 stack 제거 
                          },
                          child: const Text("Back"))), // Back 버튼 추가
                  const SizedBox(
                      width: 300,
                      height: 300,
                      child: Image(
                        image: NetworkImage(
                            "https://img.freepik.com/premium-photo/cute-puppy_976589-177.jpg"), // 강아지 사진 네트워크 위젯으로 path로 불러오기,  300 * 300 크기 지정
                        width: 300,
                        height: 300,
                        fit: BoxFit.cover,
                      ))
                ],
              ),
            )));
  }
}

// 회고

// 김기홍
// quest를 하면서 flutter 실력이 조금씩 상승함을 느낍니다.
// async await을 써야 pop()에서 불러올 수 있다는 사실을 깨달았고,
// Icon, ImageNetwork 위젯, 이미지 속성의 Boxfit 옵션 설정들을 직접해보면서
// 부족한 부분들을 서로 보완하며 만들어가니, 재미있기도하고 도움이 많이 됩니다.

// 임상운
// 퀘스트를 진행하면서 서로 도와가며 완성시키니 도움도 많이 되고 재미도 있습니다.
// 비동기는 아직 적응이 안되서 적용이 잘 안되는 것 같습니다.
// 기홍님이 부족한 부분을 많이 도와 주셨고 부족한 실력이 조금이나마 늘어가는 걸
// 느낍니다. 이상입니다.
