import 'package:flutter/material.dart';

class TextResultScreen extends StatefulWidget {
  const TextResultScreen({super.key});

  @override
  TextResultScreenState createState() => TextResultScreenState();
}

class TextResultScreenState extends State<TextResultScreen> {
  bool isTextAlignOptions = false;
  bool istextColor = false;

  Object? _selectedTextAlign;
  Object? _selectedTextColor;

  final List<Map<String, dynamic>> textAlignOptions = [
    {'label': 'TextAlign.left', 'value': TextAlign.left},
    {'label': 'TextAlign.right', 'value': TextAlign.right},
    {'label': 'TextAlign.center', 'value': TextAlign.center},
    {'label': 'TextAlign.justify', 'value': TextAlign.justify},
    {'label': 'TextAlign.start', 'value': TextAlign.start},
    {'label': 'TextAlign.end', 'value': TextAlign.end},
  ];

  final List<Map<String, dynamic>> textColorOptions = [
    {'label': 'amber', 'value': Colors.amber},
    {'label': 'black', 'value': Colors.black},
    {'label': 'blue', 'value': Colors.blue},
    {'label': 'brown', 'value': Colors.brown},
    {'label': 'cyan', 'value': Colors.cyan},
    {'label': 'orange', 'value': Colors.orange},
    {'label': 'pink', 'value': Colors.pink},
    {'label': 'green', 'value': Colors.green},
    {'label': 'purple', 'value': Colors.purple},
    {'label': 'teal', 'value': Colors.teal},
    {'label': 'white', 'value': Colors.white},
  ];

  Color textColor = Colors.white;
  double fontSize = 16.0;
  FontWeight fontWeight = FontWeight.normal;
  FontStyle fontStyle = FontStyle.normal;
  TextAlign textAlign = TextAlign.right;

  void changeTextAlign(object) {
    print(object);
    setState(() {
      textAlign = object;
    });
  }

  void changeTextColor(object) {
    setState(() {
      textColor = object;
    });
  }

  void changeFontSize() {
    setState(() {
      fontSize = fontSize == 16.0 ? 24.0 : 16.0;
    });
  }

  void changeFontWeight() {
    setState(() {
      fontWeight =
          fontWeight == FontWeight.normal ? FontWeight.bold : FontWeight.normal;
    });
  }

  void changeFontStyle() {
    setState(() {
      fontStyle =
          fontStyle == FontStyle.normal ? FontStyle.italic : FontStyle.normal;
    });
  }

  String _getCurrentTextCode() {
    String styleCode = '';

    styleCode += 'color: $textColor,\n    ';

    if (fontSize != 16.0) {
      styleCode += 'fontSize: $fontSize,\n    ';
    }

    String textAlignCode = '$textAlign,\n';

    // fontSize: $fontSize,
    //   fontWeight: $fontWeight,
    //   fontStyle: $fontStyle,
    return '''
Text(
  'Hello Flutter!',
  style: TextStyle(
    $styleCode
  ),
  textAlign: $textAlignCode,
)
''';
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                flex: 1,
                child: ElevatedButton(
                  onPressed: () {},
                  child: const Text('결과 '),
                ),
              ),
              Expanded(
                flex: 1,
                child: ElevatedButton(
                  onPressed: () {
                    String data = _getCurrentTextCode();
                    Navigator.pushNamed(context, '/text_code', arguments: data);
                  },
                  child: const Text('코드'),
                ),
              ),
            ],
          ),
          Container(
            margin: const EdgeInsets.all(4.0),
            height: 30,
            child: const Text('코드'),
          ),
          Expanded(
            flex: 1,
            child: Container(
              color: Colors.black,
              width: double.infinity,
              child: SingleChildScrollView(
                child: Text(
                  'Hello Flutter! ABCDEFGHIJKLMNOPQRSTUVWXYZ abcdefghijklmonpqrstuvwxyz',
                  style: TextStyle(
                    color: textColor,
                    fontSize: fontSize,
                    fontWeight: fontWeight,
                    fontStyle: fontStyle,
                  ),
                  textAlign: textAlign,
                ),
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.fromLTRB(4, 24, 4, 4),
            height: 30,
            child: const Text('속성'),
          ),
          Expanded(
            child: Container(
              color: Colors.black,
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // const Text(
                    //   '''
                    //   textAlign: TextAlign.right
                    //   => 텍스트를 오른쪽으로 정렬합니다.
                    //   ''',
                    //   style: TextStyle(color: Colors.white),
                    // ),
                    // 텍스트 정렬
                    DropdownButton<Object>(
                      hint: const Text(
                        '텍스트 정렬을 선택하세요',
                        style: TextStyle(color: Colors.lightBlue),
                      ),
                      value: _selectedTextAlign,
                      items: textAlignOptions.map((text) {
                        return DropdownMenuItem<Object>(
                          value: text['value'],
                          child: Text(
                            text['label'] as String,
                            style: const TextStyle(color: Colors.lightBlue),
                          ),
                        );
                      }).toList(),
                      onChanged: (newValue) {
                        setState(() {
                          _selectedTextAlign = newValue;
                          changeTextAlign(newValue!);
                        });
                      },
                    ),
                    // 색상 정렬
                    DropdownButton<Object>(
                      hint: const Text(
                        '텍스트 색상을 선택하세요',
                        style: TextStyle(color: Colors.lightBlue),
                      ),
                      value: _selectedTextColor,
                      items: textColorOptions.map((text) {
                        return DropdownMenuItem<Object>(
                          value: text['value'],
                          child: Text(
                            text['label'] as String,
                            style: const TextStyle(color: Colors.lightBlue),
                          ),
                        );
                      }).toList(),
                      onChanged: (newValue) {
                        setState(() {
                          _selectedTextColor = newValue;
                          changeTextColor(newValue!);
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class TextCodeScreen extends StatelessWidget {
  const TextCodeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final String data = ModalRoute.of(context)!.settings.arguments as String;
    print(data);
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                flex: 1,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/widgets');
                  },
                  child: const Text('결과 '),
                ),
              ),
              Expanded(
                flex: 1,
                child: ElevatedButton(
                  onPressed: () {},
                  child: const Text('코드'),
                ),
              ),
            ],
          ),
          Container(
            margin: const EdgeInsets.all(4.0),
            height: 30,
            child: const Text(
              '코드',
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              color: Colors.black,
              width: double.infinity,
              child: SingleChildScrollView(
                child: Text(
                  '''
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Hello Flutter App'),
          $data
        ),
        body: Center(
          child: Text(
            'Hello Flutter!',
            textAlign: TextAlign.right, // 텍스트를 오른쪽으로 정렬
          ),
        ),
      ),
    );
  }
}
''',
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.fromLTRB(4, 24, 4, 4),
            height: 30,
            child: const Text('추가된 속성'),
          ),
          Expanded(
            child: Container(
              color: Colors.black,
              width: double.infinity,
              child: const SingleChildScrollView(
                child: Text(
                  '''
textAlign: TextAlign.center,       // 텍스트 정렬
textDirection: TextDirection.ltr,  // 텍스트 방향
locale: Locale('en', 'US'),        // 텍스트의 로케일
softWrap: true,                    // 텍스트가 화면에 맞추어 줄바꿈되는지 여부
overflow: TextOverflow.ellipsis,   // 텍스트 오버플로우 처리 방식
textScaleFactor: 1.0,              // 텍스트의 크기 배율
maxLines: 1,                       // 최대 줄 수
                  ''',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
