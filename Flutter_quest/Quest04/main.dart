import 'package:flutter/material.dart';
import 'menu/drawer.dart';

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  int _selectedIndex = 1;

  // Navigator 키 생성
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();

  final List<Widget> _widgetOptions = <Widget>[
    const Text(
      'First Screen',
      style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
    ),
    const Text(
      'Second Screen',
      style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
    ),
    const Text(
      'Third Screen',
      style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
    ),
    const Text(
      'Fourth Screen',
      style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
    ),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
          appBar: AppBar(
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(0.0),
                child: Container(
                    height: 0.0,
                    alignment: Alignment.center,
                    child: const Text('AppBar Bottom Text')),
              ),
              title: const Text('AppBar Title'),
              actions: <Widget>[
                IconButton(
                  icon: const Icon(Icons.add_alert),
                  onPressed: () {},
                ),
                IconButton(
                  icon: const Icon(Icons.phone),
                  onPressed: () {},
                ),
              ]),
          body: Navigator(
            key: _navigatorKey,
            initialRoute: '/',
            onGenerateRoute: (RouteSettings settings) {
              WidgetBuilder builder;
              switch (settings.name) {
                case '/':
                  builder = (BuildContext _) => const HomeScreen();
                  break;
                case '/text_code':
                  builder = (BuildContext _) => const TextCode_Screen();
                  break;
                case '/text_result':
                  builder = (BuildContext _) => const TextResult_Screen();
                  break;
                default:
                  throw Exception('Invalid route: ${settings.name}');
              }
              return MaterialPageRoute(builder: builder, settings: settings);
            },
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {},
            child: const Icon(Icons.add),
          ),
          bottomNavigationBar: BottomNavigationBar(
            type: BottomNavigationBarType.shifting,
            //fixed, shifting
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  label: 'First',
                  backgroundColor: Colors.lightBlue),
              BottomNavigationBarItem(
                  icon: Icon(Icons.business),
                  label: 'Second',
                  backgroundColor: Colors.red),
              BottomNavigationBarItem(
                  icon: Icon(Icons.school),
                  label: 'Third',
                  backgroundColor: Colors.purple),
              BottomNavigationBarItem(
                  icon: Icon(Icons.school),
                  label: 'Fourth',
                  backgroundColor: Colors.pink)
            ],
            currentIndex: _selectedIndex,
            selectedItemColor: Colors.amber[800],
            onTap: _onItemTapped,
          ),
          drawer: DrawerWidget(navigatorKey: _navigatorKey)),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.white70,
        child: Image.asset(
          'images/door_image.png',
          width: 725,
          height: 900,
        ));
  }
}

// TextScreen
class TextCode_Screen extends StatelessWidget {
  const TextCode_Screen({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Expanded(
              flex: 1,
              child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const TextResult_Screen()),
                    );
                  },
                  child: const Text('결과 ')),
            ),
            Expanded(
                flex: 1,
                child:
                    ElevatedButton(onPressed: () {}, child: const Text('코드')))
          ]),
          Container(
              margin: const EdgeInsets.all(4.0),
              height: 30,
              child: const Text('Settings Screen Content')),
          Expanded(
            flex: 2,
            child: Container(
              color: Colors.grey[200],
              width: 730,
              height: 220,
              child: const SingleChildScrollView(
                child: Text('''
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
            '''),
              ),
            ),
          ),
          Container(
              margin: const EdgeInsets.fromLTRB(4, 24, 4, 4),
              height: 30,
              child: const Text('추가된 속성')),
          Expanded(
              child: Container(
                  color: Colors.grey[200],
                  width: 730,
                  height: 220,
                  child: const Text('''
textAlign: TextAlign.center,       // 텍스트 정렬
textDirection: TextDirection.ltr,  // 텍스트 방향
locale: Locale('en', 'US'),        // 텍스트의 로케일
softWrap: true,                    // 텍스트가 화면에 맞추어 줄바꿈되는지 여부
overflow: TextOverflow.ellipsis,   // 텍스트 오버플로우 처리 방식
textScaleFactor: 1.0,              // 텍스트의 크기 배율
maxLines: 1,                       // 최대 줄 수
'''))),
        ],
      ),
    );
  }
}

// 결과 스크린
class TextResult_Screen extends StatelessWidget {
  const TextResult_Screen({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Expanded(
              flex: 1,
              child: ElevatedButton(onPressed: () {}, child: const Text('결과 ')),
            ),
            Expanded(
                flex: 1,
                child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const TextCode_Screen()),
                      );
                    },
                    child: const Text('코드')))
          ]),
          Container(
              margin: const EdgeInsets.all(4.0),
              height: 30,
              child: const Text('Settings Screen Content')),
          Expanded(
            flex: 2,
            child: Container(
              color: Colors.grey[200],
              width: 730,
              height: 220,
              child: const SingleChildScrollView(
                child: Text(
                  'Hello Flutter!',
                  textAlign: TextAlign.right,
                ),
              ),
            ),
          ),
          Container(
              margin: const EdgeInsets.fromLTRB(4, 24, 4, 4),
              height: 30,
              child: const Text('Settings Screen Content')),
          Expanded(
              child: Container(
                  color: Colors.grey[200],
                  width: 730,
                  height: 220,
                  child: const Text('''
textAlign: TextAlign.right
=> 텍스트를 오른쪽으로 정렬합니다.
                  '''))),
        ],
      ),
    );
  }
}

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('About Screen Content'),
    );
  }
}
