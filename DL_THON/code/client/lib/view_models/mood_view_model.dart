import 'package:client/models/mood_model.dart';
import 'package:client/repos/mood_repo.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MoodViewModel extends Notifier<MoodModel> {
  final MoodRepository _repository;
  MoodViewModel(this._repository);

  void setMood(String value) {
    _repository.setMood(value);
    state = MoodModel(mood: value);
  }

  @override
  build() {
    return MoodModel(
      mood: _repository.getMood(),
    );
  }
}

final moodProvider = NotifierProvider<MoodViewModel, MoodModel>(
  () => throw UnimplementedError(),
);
