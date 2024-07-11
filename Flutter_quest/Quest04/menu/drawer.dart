import 'package:flutter/material.dart';

class DrawerWidget extends StatelessWidget {
  final GlobalKey<NavigatorState> navigatorKey;

  const DrawerWidget({super.key, required this.navigatorKey});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Text('Drawer Header'),
          ),
          ListTile(
            title: const Text('Container'),
            onTap: () {},
          ),
          ListTile(
            title: const Text('Columns'),
            onTap: () {},
          ),
          ListTile(
            title: const Text('Rows'),
            onTap: () {},
          ),
          ListTile(
            title: const Text('Text'),
            onTap: () {
              Navigator.pop(context);
              navigatorKey.currentState!.pushReplacementNamed('/text_result');
            },
          ),
          ListTile(
            title: const Text('Image'),
            onTap: () {},
          ),
          ListTile(
            title: const Text('Icon'),
            onTap: () {},
          ),
          ListTile(
            title: const Text('ElevatedButton'),
            onTap: () {},
          ),
          ListTile(
            title: const Text('ListView'),
            onTap: () {},
          ),
          ListTile(
            title: const Text('GridView'),
            onTap: () {},
          ),
          ListTile(
            title: const Text('Navigator'),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
