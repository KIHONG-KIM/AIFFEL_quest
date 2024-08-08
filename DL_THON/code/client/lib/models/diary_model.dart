class DiaryModel {
  final String content;
  final String emotion;
  final String createdAt;
  DiaryModel({
    required this.content,
    required this.emotion,
    required this.createdAt,
  });

  DiaryModel.fromJson(Map<String, dynamic> json)
      : content = json["content"],
        emotion = json["emotion"],
        createdAt = json["createdAt"];

  Map<String, dynamic> toJson() {
    return {
      "content": content,
      "emotion": emotion,
      "createdAt": createdAt,
    };
  }

  DiaryModel copyWith({
    String? content,
    String? emotion,
    String? createdAt,
  }) {
    return DiaryModel(
      content: content ?? this.content,
      emotion: emotion ?? this.emotion,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
