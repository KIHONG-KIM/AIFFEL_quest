'''
회고

김기홍

거의 완료하고나서 받아온 값을 parsing할 때 시간이 오래 걸렸다.
이유는 비동기 호출을 다루는 것에 익숙하지 않았기 때문인 것 같다.
이번에도 async로 시간을 조금 오래 잡아먹었지만 의미있는 시간이었다.

fast api를 사용해서 api를 만드는 것이 굉장히 효율적이고 좋은 방법인 것 같아, 
머신러닝 앱에서 자주 쓰이게 될 것 같다.

이번 퀘스트를 통해 python api를 다루고, 플러터로 비동기 요청을 통해
플러터와 api에 대한 이해력이 조금은 상승한 것 같다.

'''

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Jelly fish classifer'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String prediction = "";
  double percent = 0.0;

  // 비동기 호출 함수 
  Future<Map<String, dynamic>> onPressGet() async {
    // header 객체
    Map<String, String> headers = {
      "content-type": "application/json", // 약속
      "accept": "application/json",
    };

    // response http 객체로 비동기 요청
    http.Response response = await http.get(
        // 여기서 응답을 보내고 기다릴 예정
        // 목적지 주소를 적는다.
        Uri.parse('http://127.0.0.1:8000/predict_api'),
        headers: headers); // 헤더 추가

    // 만약 정상적으로 통신이 되었다면? (상태코드 200은 요청 성공 응답)
    if (response.statusCode == 200) {
      return json.decode(response.body);
      // 에러처리 (try catch로 해도 됨)
    } else {
      print('error......');
      throw Exception('Failed to load prediction');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const Icon(
          Icons.favorite, // 아이콘 이름
          color: Colors.red, // 아이콘 색상
          size: 50.0, // 아이콘 크기
        ),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Center(child: Text(widget.title)),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
                width: 300, height: 300, child: Image.asset('jellyfish.jpg')),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // 예측 결과, 예측 확률 버튼
                ElevatedButton(
                    // async를 적지 않아서, 비동기 선언이되지 않음.. 이걸로 30분 고생...
                    onPressed: () async {
                      final result = await onPressGet(); // 비동기 함수를 호출
                      setState(() {
                        prediction =
                            result['prediction']; // JSON 결과 값의 label 출력
                      });
                      print(prediction);
                    },
                    child: const Text('예측결과')),
                ElevatedButton(
                    onPressed: () async {
                      final result = await onPressGet(); // 비동기 함수를 호출
                      setState(() {
                        percent = result['percent']; // JSON 결과 값의 label 출력
                      });
                      print(percent);
                    },
                    child: const Text('확률확률')),
              ],
            )
          ],
        ),
      ),
    );
  }
}
