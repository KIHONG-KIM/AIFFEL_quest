import 'package:flutter/material.dart';
import 'package:mainquest06_flutter_0718/widgets/drawer.dart'; // code_drower
import 'screens/etc_pages.dart'; // sub_pages 아직 미구현
import 'screens/code_pages.dart'; // code_pages
import 'screens/mindmap_screen.dart'; // mindmap_pages

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      // Navigator 위젯을 사용하고, onGenerateRoute 속성을 사용하면 사용할 수 없다.
      // routes: {
      //   '/home': (context) => const HomePage(),
      //   '/widgets': (context) => const TextResult_Screen(),
      //   '/mindmap': (context) => const MindMapScreen(),
      //   '/settings': (context) => const SettingsPage(),
      // },
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  MyHomePageState createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();
  int _selectedIndex = 0;

// BottomNavigationBar 함수
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    switch (index) {
      case 0:
        _navigatorKey.currentState?.pushReplacementNamed('/home');
        break;
      case 1:
        _navigatorKey.currentState?.pushReplacementNamed('/widgets');
        break;
      case 2:
        _navigatorKey.currentState?.pushReplacementNamed('/mindmap');
        break;
      case 3:
        _navigatorKey.currentState?.pushReplacementNamed('/settings');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(0.0),
          child: Container(
            height: 0.0,
            alignment: Alignment.center,
            child: const Text('AppBar Bottom Text'),
          ),
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
        ],
      ),
      body: Navigator(
        key: _navigatorKey,
        initialRoute: '/home',
        onGenerateRoute: (RouteSettings settings) {
          WidgetBuilder builder;
          switch (settings.name) {
            case '/':
            case '/home':
              builder = (BuildContext _) => const HomePage();
              break;
            case '/widgets':
              builder = (BuildContext _) => const TextResultScreen();
              break;
            case '/mindmap':
              builder = (BuildContext _) => const MindMapScreen();
              break;
            case '/settings':
              builder = (BuildContext _) => const SettingsPage();
              break;
            case '/text_code':
              builder = (BuildContext _) => const TextCodeScreen();
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
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home, color: Colors.lightBlueAccent),
            label: 'Home',
            backgroundColor: Colors.blue,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.business, color: Colors.lightBlueAccent),
            label: 'Widgets',
            backgroundColor: Colors.blue,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.school, color: Colors.lightBlueAccent),
            label: 'Mindmap.AI',
            backgroundColor: Colors.blue,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings, color: Colors.lightBlueAccent),
            label: 'Settings',
            backgroundColor: Colors.blue,
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.lightBlueAccent,
        onTap: _onItemTapped,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
        unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500),
        showUnselectedLabels: true,
        backgroundColor: Colors.blueGrey[900],
      ),
      drawer: DrawerWidget(navigatorKey: _navigatorKey),
    );
  }
}
