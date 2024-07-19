import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

// 자세히보기 페이지

class DetailScreen extends StatelessWidget {
  final String concept;
  final String contents;

  const DetailScreen(
      {super.key, required this.concept, required this.contents});

  @override
  Widget build(BuildContext context) {
    print('concept $concept');
    // List<String> parts = concept.split('_sub_');
    // String subConcept = parts[1];
    // print(subConcept);

    return Scaffold(
      appBar: AppBar(
        title: Text('$concept 이란?',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      ),
      body: Center(
        child: SingleChildScrollView(
            child: Container(
                color: Colors.lightBlueAccent,
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Container(
                    margin: const EdgeInsets.all(8),
                    child: MarkdownBody(
                      data: contents,
                      styleSheet:
                          MarkdownStyleSheet.fromTheme(Theme.of(context))
                              .copyWith(
                        codeblockDecoration: BoxDecoration(
                          // 코드 블록의 스타일을 설정합니다.
                          color: const Color(
                              0xFF1E1E1E), // 배경색을 짙은 회색(검은색에 가까운 색상)으로 설정합니다.
                          borderRadius:
                              BorderRadius.circular(6.0), // 모서리를 둥글게 만듭니다.
                          border: Border.all(
                              color: const Color(
                                  0xFF3C3C3C)), // 테두리 색상을 중간 밝기의 회색으로 설정합니다.
                        ),
                        code: const TextStyle(
                          // 코드 블록 내부의 텍스트 스타일을 설정합니다.
                          backgroundColor: Color(
                              0xFF1E1E1E), // 텍스트 배경색을 짙은 회색(검은색에 가까운 색상)으로 설정합니다.
                          fontSize: 12.0, // 텍스트 크기를 14 포인트로 설정합니다.
                          fontFamily: 'monospace', // 글꼴을 'monospace'로 설정합니다.
                          color: Colors
                              .white, // 텍스트 색상을 흰색으로 설정하여 검은 배경에서 잘 보이게 합니다.
                        ),
                        codeblockPadding: const EdgeInsets.all(
                            12.0), // 코드 블록의 안쪽 여백을 12 포인트로 설정합니다.
                        blockquotePadding: const EdgeInsets.all(
                            12.0), // 인용구 블록의 안쪽 여백을 12 포인트로 설정합니다.
                        blockquoteDecoration: BoxDecoration(
                          // 인용구 블록의 스타일을 설정합니다.
                          color: const Color(0xFF2A2A2A), // 배경색을 짙은 회색으로 설정합니다.
                          borderRadius:
                              BorderRadius.circular(6.0), // 모서리를 둥글게 만듭니다.
                          border: Border.all(
                              color: const Color(
                                  0xFF4B4B4B)), // 테두리 색상을 중간 밝기의 회색으로 설정합니다.
                        ),
                      ),
                    ),
                  ),
                ))),
      ),
    );
  }
}
