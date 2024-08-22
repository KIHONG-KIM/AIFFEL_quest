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
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
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
  int _counter = 0;
  Image? _processedImage;
  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  Future<void> _processImage(data) async {
    // if (_image == null) return;

    try {
      // List<int> imageBytes = await _image!.readAsBytes();
      // String base64Image = base64Encode(imageBytes);

      print('하이');
      var response = await http.post(
        Uri.parse('http://192.168.45.45:8000/gan/'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'label': data}),
      );

      if (response.statusCode == 200) {
        var responseData = json.decode(response.body);
        String imageBase64 = responseData['image'];

        setState(() {
          _processedImage =
              Image.memory(base64Decode(imageBase64), width: 150, height: 150);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Image processed successfully')),
        );
      } else {
        throw Exception('Failed to process image');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error processing image: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              children: [
                ElevatedButton(
                  onPressed: () {
                    _processImage(0);
                  },
                  child: const Text('airplane'),
                ),
                ElevatedButton(
                  onPressed: () {
                    _processImage(1);
                  },
                  child: const Text('automobile'),
                ),
                ElevatedButton(
                  onPressed: () {
                    _processImage(2);
                  },
                  child: const Text('bird'),
                ),
                ElevatedButton(
                  onPressed: () {
                    _processImage(3);
                  },
                  child: const Text('cat'),
                ),
              ],
            ),
            Row(children: [
              ElevatedButton(
                onPressed: () {
                  _processImage(4);
                },
                child: const Text('deer'),
              ),
              ElevatedButton(
                onPressed: () {
                  _processImage(5);
                },
                child: const Text('dog'),
              ),
              ElevatedButton(
                onPressed: () {
                  _processImage(6);
                },
                child: const Text('frog'),
              ),
              ElevatedButton(
                onPressed: () {
                  _processImage(7);
                },
                child: const Text('horse'),
              ),
            ]),
            Row(children: [
              ElevatedButton(
                onPressed: () {
                  _processImage(8);
                },
                child: const Text('ship'),
              ),
              ElevatedButton(
                onPressed: () {
                  _processImage(9);
                },
                child: const Text('truck'),
              ),
            ]),
            _processedImage != null ? _processedImage! : Container(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
