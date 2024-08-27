import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:typed_data';
import 'dart:convert';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: SliderDemo(),
    );
  }
}

class SliderDemo extends StatefulWidget {
  const SliderDemo({super.key});

  @override
  _SliderDemoState createState() => _SliderDemoState();
}

class _SliderDemoState extends State<SliderDemo> {
  //  프롬프트의 영향력을 조절하는 파라미터
  // 이를 추가하여 이미지 생성의 창의성과 프롬프트 충실도 사이의 균형을 조절
  double guidance_scale = 7.5;
  // image_strength: 0 - 1 사이
  // 원본 Canny 이미지의 영향력을 조절하는 파라미터
  // 원본 이미지의 특징을 얼마나 유지할지 조절
  double image_strength = 0.8;

  Future<Uint8List>? _imageFuture;

  bool isLoading = false;
  String localhost = 'http://192.168.45.45:8000';
  // String localhost = 'http://10.0.2.2:8000';

  Future<Uint8List> generateCannyImage(
      {required String prompt,
      required int count,
      required double guidance_scale,
      required double image_strength,
      int numInferenceSteps = 20}) async {
    final response = await http.post(
      Uri.parse('$localhost/generate_canny_image/'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'prompt': prompt,
        'count': count,
        'num_inference_steps': numInferenceSteps,
        'guidance_scale': guidance_scale,
        'image_strength': image_strength,
      }),
    );

    if (response.statusCode == 200) {
      // 컨텐츠 타입 확인
      String? contentType = response.headers['content-type'];
      if (contentType?.startsWith('image/') == true) {
        return response.bodyBytes;
      } else {
        print('Unexpected content type: $contentType');
      }
      return response.bodyBytes;
    } else {
      throw Exception('Failed to generate image: ${response.statusCode}');
    }
  }

  void _onGeneratePressed() {
    setState(() {
      _imageFuture = generateCannyImage(
          prompt: 'your prompt',
          count: 1,
          guidance_scale: guidance_scale,
          image_strength: image_strength);
      print(_imageFuture);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter + Stable Diffusion'),
      ),
      body: SingleChildScrollView(
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Text(
            //   // ', 파라미터2: $_currentSliderValue2',
            //   style: const TextStyle(fontSize: 20),
            // ),
            const SizedBox(height: 20),
            Row(
              children: [
                const Text(
                    'Canny 파이프라인에서 프롬프트의 영향력을 조절하는 파라미터. 이미지 생성의 창의성과 프롬프트 충실도 사이의 균형을 조절'),
                Text('guidance_scale: $guidance_scale'),
                Slider(
                  value: guidance_scale,
                  min: 0,
                  max: 20,
                  divisions: 40,
                  label: guidance_scale.toString(),
                  onChanged: (double value) {
                    setState(() {
                      guidance_scale = value;
                    });
                  },
                ),
              ],
            ),
            Row(
              children: [
                const Text(
                    '원본 Canny 이미지의 영향력을 조절하는 파라미터. 원본 이미지의 특징을 얼마나 유지할지 조절'),
                Text('image_strength: $image_strength'),
                Slider(
                  value: image_strength,
                  min: 0,
                  max: 1,
                  divisions: 10,
                  label: image_strength.toString(),
                  onChanged: (double value) {
                    setState(() {
                      image_strength = value;
                    });
                  },
                ),
              ],
            ),
            // Container(
            //   width: 400,
            //   height: 400,
            //   color: Colors.amber,
            // ),
            if (_imageFuture != null)
              FutureBuilder<Uint8List>(
                future: _imageFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done &&
                      snapshot.hasData) {
                    return Image.memory(snapshot.data!);
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  }
                  return const Center(child: CircularProgressIndicator());
                },
              ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _onGeneratePressed,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
