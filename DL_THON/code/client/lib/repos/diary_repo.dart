import 'package:client/models/diary_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod/riverpod.dart';

class DiaryRepository {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> createDiary(DiaryModel diary) async {
    _db.collection("diary").add(diary.toJson());
  }

  Future<QuerySnapshot<Map<String, dynamic>>> fetchDiaries() async {
    Query<Map<String, dynamic>> query = _db.collection("diary");
    return query.get();
  }
}

final diaryRepo = Provider(
  (ref) => DiaryRepository(),
);
