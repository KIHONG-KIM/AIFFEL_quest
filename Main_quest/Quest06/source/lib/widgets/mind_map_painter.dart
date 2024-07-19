import 'package:flutter/material.dart';
import 'dart:math' as math;

// 파스텔톤 색상 정의
const Color pastelBlue = Color(0xFFAEDFF7);
const Color pastelGreen = Color(0xFFB6EDC8);
const Color pastelRed = Color(0xFFF7A8A8);
const Color pastelOrange = Color(0xFFFFE1A8);
const Color pastelPurple = Color(0xFFD1C4E9);
const Color pastelGray = Color(0xFFB0BEC5);

// MindMap을 그리기 위한 CustomPainter 클래스
class MindMapPainter extends CustomPainter {
  final List<String> concepts; // 메인 개념 리스트
  final List<String> descriptions; // 각 개념에 대한 설명 리스트
  final Offset offset; // 화면 이동을 위한 오프셋 (드래그 시 화면 이동에 사용)
  final String? selectedConcept; // 현재 선택된 개념
  final Map<String, List<dynamic>> subConcepts; // 서브 컨셉트를 저장할 맵
  final Map<String, List<String>> subSubConcepts; // 서브 노드의 서브 노드를 저장할 맵

  // 상수 정의
  static const double mainNodeRadius = 40.0; // 메인 노드의 반지름
  static const double subNodeRadius = 40.0; // 서브 노드의 반지름
  static const double centerNodeRadius = 50.0; // 중심 노드의 반지름

  MindMapPainter({
    required this.concepts,
    required this.descriptions,
    required this.offset,
    this.selectedConcept,
    required this.subConcepts,
    required this.subSubConcepts,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // 캔버스를 오프셋 위치로 이동 (드래그 효과)
    canvas.translate(offset.dx, offset.dy);

    final center = Offset(size.width / 2, size.height / 2); // 중심 위치 계산
    final radius = size.width < size.height
        ? size.width * 0.4
        : size.height * 0.4; // 중심에서 각 노드까지의 거리

    // 연결선 그리기 (먼저 그림)
    _drawLines(canvas, center, radius);

    // 노드 그리기 (나중에 그림)
    _drawNodes(canvas, center, radius);
  }

  // 연결선을 그리는 함수
  void _drawLines(Canvas canvas, Offset center, double radius) {
    for (int i = 0; i < concepts.length; i++) {
      final Offset nodeCenter =
          _calculateNodeCenter(center, radius, i, concepts.length);
      _drawLine(canvas, center, nodeCenter);

      // 선택된 개념의 서브 컨셉트에 대한 연결선 그리기
      if (concepts[i] == selectedConcept &&
          subConcepts[selectedConcept] != null) {
        for (int j = 0; j < subConcepts[selectedConcept]!.length; j++) {
          final Offset subCenter = _calculateSubNodeCenter(
              nodeCenter, j, subConcepts[selectedConcept]!.length);
          _drawLine(canvas, nodeCenter, subCenter);

          // 서브 노드의 서브 컨셉트에 대한 연결선 그리기
          if (subSubConcepts[
                  '${concepts[i]}_sub_${subConcepts[selectedConcept]![j]}'] !=
              null) {
            for (int k = 0;
                k <
                    subSubConcepts[
                            '${concepts[i]}_sub_${subConcepts[selectedConcept]![j]}']!
                        .length;
                k++) {
              final Offset subSubCenter = _calculateSubNodeCenter(
                  subCenter,
                  k,
                  subSubConcepts[
                          '${concepts[i]}_sub_${subConcepts[selectedConcept]![j]}']!
                      .length);
              _drawLine(canvas, subCenter, subSubCenter);
            }
          }
        }
      }
    }
  }

  // 노드를 그리는 함수
  void _drawNodes(Canvas canvas, Offset center, double radius) {
    // 중심 노드 그리기
    _drawCenterNode(canvas, center, 'Flutter');

    // 각 메인 개념 노드 그리기
    for (int i = 0; i < concepts.length; i++) {
      final Offset nodeCenter =
          _calculateNodeCenter(center, radius, i, concepts.length);
      _drawConceptNode(canvas, nodeCenter, concepts[i],
          isSelected: concepts[i] == selectedConcept);

      // 선택된 개념의 서브 컨셉트 노드 그리기
      if (concepts[i] == selectedConcept &&
          subConcepts[selectedConcept] != null) {
        for (int j = 0; j < subConcepts[selectedConcept]!.length; j++) {
          final Offset subCenter = _calculateSubNodeCenter(
              nodeCenter, j, subConcepts[selectedConcept]!.length);
          _drawConceptNode(canvas, subCenter, subConcepts[selectedConcept]![j],
              isSubConcept: true);

          // 서브 노드의 서브 컨셉트 노드 그리기
          if (subSubConcepts[
                  '${concepts[i]}_sub_${subConcepts[selectedConcept]![j]}'] !=
              null) {
            for (int k = 0;
                k <
                    subSubConcepts[
                            '${concepts[i]}_sub_${subConcepts[selectedConcept]![j]}']!
                        .length;
                k++) {
              final Offset subSubCenter = _calculateSubNodeCenter(
                  subCenter,
                  k,
                  subSubConcepts[
                          '${concepts[i]}_sub_${subConcepts[selectedConcept]![j]}']!
                      .length);
              _drawConceptNode(
                  canvas,
                  subSubCenter,
                  subSubConcepts[
                      '${concepts[i]}_sub_${subConcepts[selectedConcept]![j]}']![k],
                  isSubConcept: true);
            }
          }
        }
      }
    }
  }

  // 중심 노드를 그리는 함수
  void _drawCenterNode(Canvas canvas, Offset center, String text) {
    final paint = Paint()
      ..color = pastelBlue
      ..style = PaintingStyle.fill;

    canvas.drawCircle(center, centerNodeRadius, paint); // 중심 노드 그리기
    _drawText(canvas, center, text, 16); // 중심 노드에 텍스트 그리기
  }

  // 개념 노드를 그리는 함수
  void _drawConceptNode(Canvas canvas, Offset center, String text,
      {bool isSelected = false, bool isSubConcept = false}) {
    final paint = Paint()
      ..color = isSubConcept ? pastelOrange : pastelGreen
      ..style = PaintingStyle.fill;

    if (isSelected) paint.color = pastelRed; // 선택된 노드는 빨간색으로 표시

    canvas.drawCircle(center, isSubConcept ? subNodeRadius : mainNodeRadius,
        paint); // 개념 노드 그리기
    _drawText(canvas, center, text, isSubConcept ? 10 : 12); // 개념 노드에 텍스트 그리기
  }

  // 노드 간의 연결선을 그리는 함수
  void _drawLine(Canvas canvas, Offset start, Offset end) {
    final paint = Paint()
      ..color = pastelGray
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    canvas.drawLine(start, end, paint); // 연결선 그리기
  }

  // 노드의 텍스트를 그리는 함수
  void _drawText(Canvas canvas, Offset center, String text, double fontSize) {
    final textPainter = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
            color: Colors.black87,
            fontSize: fontSize,
            fontWeight: FontWeight.bold),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout(maxWidth: fontSize * 5);
    textPainter.paint(
        canvas,
        center -
            Offset(textPainter.width / 2, textPainter.height / 2)); // 텍스트 중앙 정렬
  }

  // 메인 노드의 중심 위치를 계산하는 함수
  Offset _calculateNodeCenter(
      Offset center, double radius, int index, int total) {
    double angle = (2 * math.pi / total) * index - math.pi / 2; // 각도 계산
    return center +
        Offset(math.cos(angle) * radius,
            math.sin(angle) * radius); // 중심에서 각도만큼 떨어진 위치 계산
  }

  // 서브 노드의 중심 위치를 계산하는 함수
  Offset _calculateSubNodeCenter(Offset nodeCenter, int index, int total) {
    const subRadius = 90.0; // 서브 노드 반지름
    double angle = (2 * math.pi / total) * index - math.pi / 2; // 각도 계산

    // print(
    //     'angle $angle, nodeCenter $nodeCenter 3q ${math.cos(angle) * subRadius} 4q ${math.sin(angle) * subRadius} ');
    return nodeCenter +
        Offset(math.cos(angle) * subRadius,
            math.sin(angle) * subRadius); // 노드 중심에서 각도만큼 떨어진 위치 계산
  }

// 필요한 경우에만 리페인트
  @override
  bool shouldRepaint(covariant MindMapPainter oldDelegate) {
    return oldDelegate.concepts != concepts ||
        oldDelegate.descriptions != descriptions ||
        oldDelegate.offset != offset ||
        oldDelegate.selectedConcept != selectedConcept ||
        oldDelegate.subConcepts != subConcepts ||
        oldDelegate.subSubConcepts != subSubConcepts;
  }
}
