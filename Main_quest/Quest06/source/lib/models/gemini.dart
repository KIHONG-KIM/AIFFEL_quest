// 데이터 모델 클래스 Gemini
class Gemini {
  final String keyword; // 키워드
  final String description; // 설명

  Gemini({required this.keyword, required this.description});

  // JSON 데이터를 Dart 객체로 변환하는 팩토리 메서드
  factory Gemini.fromJson(Map<String, dynamic> json) {
    return Gemini(
      keyword: json['keyword'] as String,
      description: json['description'] as String,
    );
  }
}
