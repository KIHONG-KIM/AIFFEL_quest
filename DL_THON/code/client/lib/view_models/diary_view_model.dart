import 'dart:async';
import 'dart:convert';

import 'package:client/models/diary_model.dart';
import 'package:client/repos/diary_repo.dart';
import 'package:client/view_models/mood_view_model.dart';
import 'package:riverpod/riverpod.dart';
import 'package:http/http.dart' as http;

class DiaryViewModel extends AsyncNotifier<List<DiaryModel>> {
  late final DiaryRepository _repository;

  Future<List<DiaryModel>> _fetchDiaries() async {
    state = const AsyncValue.loading();
    final result = await _repository.fetchDiaries();
    final diaries = result.docs
        .map(
          (doc) => DiaryModel.fromJson(doc.data()),
        )
        .toList();
    return diaries;
  }

  @override
  FutureOr<List<DiaryModel>> build() async {
    _repository = ref.read(diaryRepo);
    return await _fetchDiaries();
  }

  Future<void> createDiary(String content, MoodViewModel moodProvider) async {
    state = const AsyncValue.loading();
    Uri uri = Uri.https('bda9-124-56-101-127.ngrok-free.app', '/predict');
    final body = jsonEncode({"text": content});
    final response = await http
        .post(
          uri,
          headers: {
            "Content-Type": "application/json",
          },
          body: body,
        )
        .then((value) => jsonDecode(utf8.decode(value.bodyBytes)));
    moodProvider.setMood(response['emotion']);
    state = await AsyncValue.guard(() async {
      final diary = DiaryModel(
        content: content,
        emotion: response['emotion'],
        createdAt: DateTime.now().toString(),
      );
      await _repository.createDiary(diary);
      final result = await _repository.fetchDiaries();
      final diaries = result.docs
          .map(
            (doc) => DiaryModel.fromJson(doc.data()),
          )
          .toList();
      return diaries;
    });
  }
}

final diaryProvider = AsyncNotifierProvider<DiaryViewModel, List<DiaryModel>>(
  () => DiaryViewModel(),
);
