// Dart 기본 라이브러리
import 'dart:io';
import 'dart:convert';

// 서드 파티 패키지
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart' show rootBundle;
import 'package:path_provider/path_provider.dart';
import 'package:csv/csv.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:tflite_flutter_helper_plus/tflite_flutter_helper_plus.dart';
import 'package:image/image.dart' as img;

// 프로젝트 내 로컬 파일
import 'image_provider.dart';

class MyScreen extends StatefulWidget {
  @override
  _MyScreenState createState() => _MyScreenState();
}

class _MyScreenState extends State<MyScreen> {
  late Interpreter _interpreter;

  @override
  void initState() {
    super.initState();
    _loadModel();
  }

  Future<void> _loadModel() async {
    try {
      _interpreter = await Interpreter.fromAsset('assets/best_model.tflite');
      print('Model loaded successfully');
    } catch (e) {
      print('Failed to load model: $e');
    }
  }

  List<Map<String, String>> files = [
    {'name': '2024-07-17 11:11:11.111111', 'path': 'images/my_number_test_01.png'},
    {'name': '2024-07-17 12:12:12.121212', 'path': 'images/my_number_test_02.png'},
  ];

  String ocrResult = '';
  Set<String> selectedImages = {};

  Future<void> _saveOcrResultToCSV(List<dynamic> results) async {
    List<List<String>> csvData = [
      <String>['filename', 'text'],
      ...results.map((result) => [result['filename'], result['text'] ?? '인식된 text가 없습니다.']),
    ];

    String csv = const ListToCsvConverter().convert(csvData);
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/ocr_results.csv');
    await file.writeAsString(csv);
  }

  Future<List<Map<String, String>>> _loadCsvFile() async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/ocr_results.csv');
    if (!file.existsSync()) {
      return [];
    }
    final csvString = await file.readAsString();
    List<List<dynamic>> csvTable = const CsvToListConverter().convert(csvString);
    List<Map<String, String>> csvData = [];

    for (var row in csvTable.skip(1)) {
      csvData.add({
        'name': row[0].toString(),
        'path': '',
        'text': row[1].toString(),
      });
    }

    return csvData;
  }

  Future<void> uploadImages() async {
    if (selectedImages.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('선택된 이미지가 없습니다.')),
      );
      return;
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('인공지능이 분석중입니다.'),
              SizedBox(height: 20),
              CircularProgressIndicator(),
            ],
          ),
        );
      },
    );

    // // var url = Uri.parse('http://221.154.233.6:5000/upload');
    // // Windows IP의 IP로 업로드해야함. WSL 주소로 하면 안됨.
    // // USB 연결해서 실행할 때, 다음 명령어를 powershell에서 실행해야 함 netsh interface portproxy add v4tov4 listenport=5000 listenaddress=0.0.0.0 connectport=5000 connectaddress=172.23.237.104
    // // 위 주소중에 vEthernet(WSL) IP 주소를 확인해야 함
    // // var url = Uri.parse('http://localhost:5000/upload');
    // var url = Uri.parse('http://10.0.2.2:5000/upload'); // 가상 에뮬레이터 용
    // var request = http.MultipartRequest('POST', url);

    // for (String path in selectedImages) {
    //   File fileToUpload;
    //   if (path.startsWith('images/')) {
    //     // Asset image
    //     final byteData = await rootBundle.load(path);
    //     final tempDir = await getTemporaryDirectory();
    //     fileToUpload = File('${tempDir.path}/${path.split('/').last}');
    //     await fileToUpload.writeAsBytes(byteData.buffer
    //         .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));
    //   } else {
    //     // New image
    //     fileToUpload = File(path);
    //   }
    //   request.files
    //       .add(await http.MultipartFile.fromPath('files', fileToUpload.path));
    // }

    // try {
    //   var streamedResponse = await request.send();
    //   var response = await http.Response.fromStream(streamedResponse);

    //   Navigator.of(context).pop();

    //   if (response.statusCode == 200) {
    //     var jsonResponse = json.decode(response.body);
    //     var results = jsonResponse['results'];
    //     setState(() {
    //       ocrResult = results
    //           .map((result) =>
    //               "${result['filename']}: ${result['text'] ?? '인식된 text가 없습니다.'}")
    //           .join('\n\n');
    //     });

    //     await _saveOcrResultToCSV(results);
    //     var csvFiles = await _loadCsvFile();
    //     setState(() {
    //       files = [
    //         ...files,
    //         ...csvFiles,
    //       ];
    //     });

    //     // // text 파일로 저장
    //     // for (var result in results) {
    //     //   String fileName = result['filename'].split('.').first; // 파일 확장자 제거
    //     //   String resultText =
    //     //       "${result['filename']}: ${result['text'] ?? '인식된 text가 없습니다.'}";
    //     //   await _saveOcrResultToFile(resultText, fileName);
    //     // }
    //   } else {
    //     throw Exception('서버 에러: ${response.statusCode}');
    //   }
    // } catch (e) {
    //   Navigator.of(context).pop();
    //   setState(() {
    //     ocrResult = '이미지 업로드 실패: $e';
    //   });
    // }
    try {
      String localResult = '';
      for (String path in selectedImages) {
        File imageFile;

        // Check if the path is an asset or local file
        if (path.startsWith('images/')) {
          // Asset image
          final byteData = await rootBundle.load(path);
          final tempDir = await getTemporaryDirectory();
          imageFile = File('${tempDir.path}/${path.split('/').last}');
          await imageFile.writeAsBytes(byteData.buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));
        } else {
          // Local file
          imageFile = File(path);
        }

        // Check if the file exists
        if (await imageFile.exists()) {
          String predictionResult = await _predictImage(imageFile);
          localResult += predictionResult + '\n\n';
        } else {
          localResult += 'File not found: $path\n\n';
        }
      }

      Navigator.of(context).pop();

      setState(() {
        ocrResult = localResult;
      });

      // 기존의 CSV 저장 및 파일 로딩 로직은 생략...
    } catch (e) {
      Navigator.of(context).pop();
      setState(() {
        ocrResult = '이미지 예측 실패: $e';
      });
    }

    Future<File> _getImageFile() async {
      final directory = await getApplicationDocumentsDirectory();
      final imagePath = '${directory.path}/images/my_number_test_01.png';
      return File(imagePath);
    }

    void loadImage() async {
      File imageFile = await _getImageFile();
      if (await imageFile.exists()) {
        // Image is found, you can now use it
        setState(() {
          // Update your widget with the new image
        });
      } else {
        print('File does not exist: ${imageFile.path}');
      }
    }

    setState(() {
      selectedImages.clear();
    });
  }

  void _showPreparingMessage(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('알림'),
          content: Text('인공지능이 인식한 문장으로 출제 시작!\n(준비중)'),
          actions: <Widget>[
            TextButton(
              child: Text('확인'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<String> _predictImage(File imageFile) async {
    final rawImage = img.decodeImage(imageFile.readAsBytesSync());
    final grayscaleImage = img.grayscale(rawImage!);
    final resizedImage = img.copyResize(grayscaleImage, width: 28, height: 28);

    List input = List.generate(28 * 28, (i) => 0.0);
    for (int i = 0; i < 28 * 28; i++) {
      input[i] = resizedImage.getPixel(i % 28, i ~/ 28) / 255.0;
    }
    input = input.reshape([1, 28, 28, 1]);

    var output = List.filled(10, 0.0).reshape([1, 10]);

    _interpreter.run(input, output);

    List<double> probabilities = output[0].cast<double>();
    int maxIndex = probabilities.indexOf(probabilities.reduce((a, b) => a > b ? a : b));

    return 'Predicted class: $maxIndex';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    color: Color.fromRGBO(255, 255, 102, 1),
                    height: MediaQuery.of(context).size.height * 0.7,
                    child: Consumer<ImageProviderModel>(
                      builder: (context, imageProvider, child) {
                        List<Map<String, dynamic>> allImages = [
                          ...imageProvider.images.map((img) => {...img, 'isNew': true}),
                          ...files.map((file) => {...file, 'isNew': false}),
                        ];

                        allImages.sort((a, b) => b['name']!.compareTo(a['name']!));

                        return GridView.builder(
                          itemCount: allImages.length,
                          itemBuilder: (context, index) {
                            final imageInfo = allImages[index];
                            return buildImageCard(
                              imageInfo['name']!,
                              imageInfo['path']!,
                              imageInfo['isNew'],
                              imageInfo.containsKey('text') ? imageInfo['text']! : '',
                            );
                          },
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 0.75,
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          ElevatedButton(
            onPressed: uploadImages,
            child: Text('선택한 이미지 인공지능 출제 시작'),
          ),
          if (ocrResult.isNotEmpty)
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'OCR 결과:',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      SizedBox(height: 8),
                      Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(ocrResult),
                      ),
                      SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () => _showPreparingMessage(context),
                        child: Text('인공지능 인식 결과 확인'),
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

  Widget buildImageCard(String name, String path, bool isNewImage, String text) {
    bool isSelected = selectedImages.contains(path);

    return Stack(
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              if (isSelected) {
                selectedImages.remove(path);
              } else {
                selectedImages.add(path);
              }
            });
          },
          child: Card(
            child: Container(
              color: Color.fromRGBO(255, 255, 102, 1),
              padding: EdgeInsets.all(10),
              child: Column(
                children: [
                  Text(
                    name,
                    style: TextStyle(fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.only(top: 10),
                      child: path.isNotEmpty
                          ? isNewImage
                              ? Image.file(
                                  File(path),
                                  fit: BoxFit.cover,
                                )
                              : Image.asset(
                                  path,
                                  fit: BoxFit.cover,
                                )
                          : SingleChildScrollView(
                              child: Text(
                                text,
                                style: TextStyle(fontSize: 14),
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Positioned(
          top: 0,
          left: 0,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.8),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15),
                bottomRight: Radius.circular(15),
              ),
            ),
            child: Transform.scale(
              scale: 0.9,
              child: Checkbox(
                value: isSelected,
                onChanged: (bool? value) {
                  setState(() {
                    if (value == true) {
                      selectedImages.add(path);
                    } else {
                      selectedImages.remove(path);
                    }
                  });
                },
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap, // 탭 영역 축소
              ),
            ),
          ),
        ),
      ],
    );
  }
}
