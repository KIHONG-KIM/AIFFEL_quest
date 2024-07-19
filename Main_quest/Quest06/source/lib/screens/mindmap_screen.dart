import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:http/http.dart' as http;
import 'package:mainquest06_flutter_0718/screens/mindmap_detail_screen.dart';
import 'dart:convert';
import '../models/gemini.dart';
import '../widgets/mind_map_painter.dart';

// MindMap 화면을 위한 StatefulWidget
class MindMapScreen extends StatefulWidget {
  const MindMapScreen({super.key});

  @override
  MindMapScreenState createState() => MindMapScreenState();
}

class MindMapScreenState extends State<MindMapScreen> {
  // 메인 개념 리스트
  List<String> concepts = [];
  // 각 개념에 대한 설명 리스트
  List<String> descriptions = [];
  // 화면 이동을 위한 오프셋 (드래그 시 화면 이동에 사용)
  Offset offset = Offset.zero;
  // 현재 선택된 개념
  String? selectedConcept;
  // 길게 눌러진 개념 (설명을 표시하기 위해 사용)
  String? longPressedConcept;
  // 서브 컨셉트를 저장할 맵
  Map<String, List<dynamic>> subConcepts = {};
  // 서브 노드의 서브 노드를 저장할 맵
  Map<String, List<String>> subSubConcepts = {};
  // 캐시된 데이터
  List<Gemini>? _cachedData;
  List<Gemini>? _cachedSubData;
  bool isLoading = false; // 로딩 상태 변수 추가
  // String localhost = 'http://127.0.0.1:8000';
  String localhost = 'http://10.0.2.2:8000';

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // 화면을 드래그할 때 호출
      onPanUpdate: (details) {
        setState(() {
          offset += details.delta;
        });
      },
      // 화면을 탭할 때 호출
      onTapDown: _handleTapDown,
      // 화면을 길게 누르기 시작할 때 호출
      onLongPressStart: _handleLongPress,
      child: CustomPaint(
        painter: MindMapPainter(
          concepts: concepts,
          descriptions: descriptions,
          offset: offset,
          selectedConcept: selectedConcept,
          subConcepts: subConcepts,
          subSubConcepts: subSubConcepts,
        ),
        child: Stack(
          children: [
            const SizedBox(
              width: double.infinity,
              height: double.infinity,
            ),
            // 길게 누른 개념의 설명을 화면에 표시
            if (longPressedConcept != null)
              Positioned(
                left: 10,
                bottom: 10,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  color: Colors.white,
                  child:
                      Text(descriptions[concepts.indexOf(longPressedConcept!)]),
                ),
              ),
            if (isLoading) // 로딩 중일 때만 CircularProgressIndicator 표시
              const Center(
                child: CircularProgressIndicator(),
              ),
            if (isLoading) // 로딩 중일 때만 CircularProgressIndicator 표시
              Positioned(
                top: 10,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  color: Colors.white,
                  child: const Text('Gemini로부터 응답을 받고 있습니다.'),
                ),
              ),
          ],
        ),
      ),
    );
  }

  // 서버로부터 데이터를 가져오는 비동기 함수
  // Future<List<Gemini>> fetchData() async {
  //   // 캐시된 데이터가 있는 경우 캐시된 데이터를 반환
  //   if (_cachedData != null && _cachedData!.isNotEmpty) return _cachedData!;
  //   final url = Uri.parse('http://10.0.2.2:8000/data');
  //   final response = await http.get(url, headers: {
  //     "content-type": "application/json",
  //     "accept": "application/json",
  //     'charset': 'UTF-8'
  //   });

  //   if (response.statusCode == 200) {
  //     // 서버로부터 받은 JSON 데이터를 디코딩
  //     final List<dynamic> jsonData = json.decode(response.body);
  //     // JSON 데이터를 Dart 객체로 변환
  //     final List<Gemini> parsedJson =
  //         jsonData.map((item) => Gemini.fromJson(item)).toList();
  //     setState(() {
  //       _cachedData = parsedJson;
  //       concepts = parsedJson.map((gemini) => gemini.keyword).toList();
  //       descriptions = parsedJson.map((gemini) => gemini.description).toList();
  //     });
  //     return parsedJson;
  //   } else {
  //     throw Exception('Failed to load data');
  //   }
  // }

  Future<void> fetchData() async {
    if (mounted) {
      setState(() {
        isLoading = true; // 비동기 작업 시작 시 로딩 상태로 설정
      });
    }
    try {
      final url = Uri.parse('$localhost/data');
      final response = await http.get(url, headers: {
        "content-type": "application/json",
        "accept": "application/json",
        'charset': 'UTF-8'
      });

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        final List<Gemini> parsedJson =
            jsonData.map((item) => Gemini.fromJson(item)).toList();
        setState(() {
          _cachedData = parsedJson;
          concepts = parsedJson.map((gemini) => gemini.keyword).toList();
          descriptions =
              parsedJson.map((gemini) => gemini.description).toList();
        });
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print('Error fetching data: $e');
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false; // 비동기 작업 완료 시 로딩 상태 해제
        });
      }
    }
  }

  // 서버로부터 데이터를 가져오는 비동기 함수
  Future<List<Gemini>> fetchSubData(data) async {
    if (mounted) {
      setState(() {
        isLoading = true; // 비동기 작업 시작 시 로딩 상태로 설정
      });
    }

    if (_cachedSubData != null && _cachedSubData!.isNotEmpty) {
      return _cachedSubData!;
    }
    try {
      final url = Uri.parse('$localhost/subdata');
      final body = jsonEncode({'keyword': data});

      final response = await http.post(
        url,
        headers: {
          "content-type": "application/json",
          "accept": "application/json",
          'charset': 'UTF-8'
        },
        body: body,
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        print('http data $jsonData');
        final List<Gemini> parsedJson =
            jsonData.map((item) => Gemini.fromJson(item)).toList();
        return parsedJson;
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print('Error fetching data: $e');
      return [];
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false; // 비동기 작업 완료 시 로딩 상태 해제
        });
      }
    }
  }

  // 서버로부터 데이터를 가져오는 비동기 함수
  Future<String> fetchDetailContents(data) async {
    if (mounted) {
      setState(() {
        isLoading = true; // 비동기 작업 시작 시 로딩 상태로 설정
      });
    }

    try {
      final url = Uri.parse('$localhost/detail');
      final body = jsonEncode({'keyword': data});

      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          'Charset': 'UTF-8'
        },
        body: body,
      );

      if (response.statusCode == 200) {
        return response.body;
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print('Error fetching data: $e');
      return ''; // 예외 발생 시 빈 문자열 반환
    } finally {
      if (mounted) {
        // setState 호출 전에 위젯이 여전히 마운트된 상태인지 확인
        setState(() {
          isLoading = false; // 비동기 작업 완료 시 로딩 상태 해제
        });
      }
    }
  }

// 클릭시 이벤트
  void _handleTapDown(TapDownDetails details) async {
    final position = getLocalPosition(details.globalPosition);
    String? tappedConcept = getTappedConcept(position);

    // 탭했을 때 subConcept를 클릭했을 경우
    if (tappedConcept != null) {
      if (tappedConcept.contains('_sub_')) {
        // '_sub_'로 뒤에 부분만 잘라서 비동기 통신으로 subConcept만 보내기
        List<String> parts = tappedConcept.split('_sub_');
        String subConcept = parts[1]; // 뒷부분 subConcept
        print(tappedConcept);
        String detail = await fetchDetailContents(subConcept);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                DetailScreen(concept: subConcept, contents: detail),
          ),
        );
      } else {
        final List<Gemini> data = await fetchSubData(tappedConcept);
        setState(() {
          selectedConcept = tappedConcept;
          subConcepts[tappedConcept] =
              data.map((gemini) => gemini.keyword).toList();
        });
      }
    }
  }

  // // 화면을 탭했을 때 호출되는 함수
  // void _handleTapDown(TapDownDetails details) async {
  //   final position = _getLocalPosition(details.globalPosition);
  //   String? tappedConcept = _getTappedConcept(position);

  //   if (tappedConcept != null) {
  //     selectedConcept = tappedConcept;
  //     // 서브컨셉트를 클릭했을 때 새로운 페이지로 이동

  //     if (tappedConcept.contains('_sub_')) {
  //       String detail = await fetchDetailContents(tappedConcept);

  //       Navigator.push(
  //         context,
  //         MaterialPageRoute(
  //           builder: (context) =>
  //               SubConceptPage(concept: tappedConcept, contents: detail),
  //         ),
  //       );
  //     } else {
  //       // 비동기 함수 호출하여 데이터 가져오기
  //       final List<Gemini> data = await fetchSubData(tappedConcept);

  //       // 가져온 데이터를 사용하여 상태 업데이트
  //       setState(() {
  //         subConcepts[tappedConcept] =
  //             data.map((gemini) => gemini.keyword).toList();
  //       });
  //     }

  //     // 비동기 함수 호출하여 데이터 가져오기
  //     final List<Gemini> data = await fetchSubData(tappedConcept);
  //     // 가져온 데이터를 사용하여 상태 업데이트
  //     setState(() {
  //       subConcepts[tappedConcept] =
  //           data.map((gemini) => gemini.keyword).toList();
  //     });
  //   }
  // }

  // 화면을 길게 누르기 시작할 때 호출되는 함수
  void _handleLongPress(LongPressStartDetails details) {
    final position = getLocalPosition(details.globalPosition);
    String? pressedConcept = getTappedConcept(position);
    if (pressedConcept != null) {
      setState(() {
        longPressedConcept = pressedConcept;
      });
    }
  }

  // 길게 누른 후 떼었을 때 호출되는 함수
  void handleLongPressEnd(LongPressEndDetails details) {
    setState(() {
      longPressedConcept = null;
    });
  }

  // 전역 좌표를 지역 좌표로 변환하는 함수
  Offset getLocalPosition(Offset globalPosition) {
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    return renderBox.globalToLocal(globalPosition) - offset;
  }

  // 탭된 위치에 해당하는 개념을 찾는 함수
  String? getTappedConcept(Offset position) {
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final Size size = renderBox.size;
    final Offset center = Offset(size.width / 2, size.height / 2);
    final double radius =
        size.width < size.height ? size.width * 0.4 : size.height * 0.4;

    // 중심 노드 확인
    if ((position - center).distance <= MindMapPainter.centerNodeRadius) {
      return 'Flutter';
    }

    for (int i = 0; i < concepts.length; i++) {
      final Offset nodeCenter =
          calculateNodeCenter(center, radius, i, concepts.length);
      // 메인 노드 확인
      if ((position - nodeCenter).distance <= MindMapPainter.mainNodeRadius) {
        return concepts[i];
      }
      // 서브 노드 확인 (선택된 개념에 대해서만)
      if (concepts[i] == selectedConcept &&
          subConcepts[selectedConcept] != null) {
        for (int j = 0; j < subConcepts[selectedConcept]!.length; j++) {
          final Offset subCenter = calculateSubNodeCenter(
              nodeCenter, j, subConcepts[selectedConcept]!.length);
          if ((position - subCenter).distance <= MindMapPainter.subNodeRadius) {
            return '${concepts[i]}_sub_${subConcepts[selectedConcept]![j]}';
          }
        }
      }
    }
    return null;
  }

  // 노드의 중심 위치를 계산하는 함수
  Offset calculateNodeCenter(
      Offset center, double radius, int index, int total) {
    double angle = (2 * math.pi / total) * index - math.pi / 2;
    return center + Offset(math.cos(angle) * radius, math.sin(angle) * radius);
  }

  // 서브 노드의 중심 위치를 계산하는 함수
  Offset calculateSubNodeCenter(Offset nodeCenter, int index, int total) {
    const subRadius = 90.0;
    double angle = (2 * math.pi / total) * index - math.pi / 2;
    return nodeCenter +
        Offset(math.cos(angle) * subRadius, math.sin(angle) * subRadius);
  }
}
