import 'package:client/repos/mood_repo.dart';
import 'package:client/views/view_screen.dart';
import 'package:client/view_models/diary_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ListScreen extends ConsumerWidget {
  const ListScreen({super.key});
  String parseDate(String date) {
    final newDate = date.split(' ')[0].split('-');
    return '${newDate[0]}년 ${newDate[1]}월 ${newDate[2]}일 일기';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('List Screen'),
      ),
      body: Center(
          child: ref.watch(diaryProvider).when(
                data: (data) => ListView.separated(
                  separatorBuilder: (context, index) => const Divider(
                    height: 2,
                    color: Colors.black,
                  ),
                  itemCount: data.length,
                  itemBuilder: (context, index) => GestureDetector(
                    onTap: () => {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ViewScreen(
                            content: data[index].content,
                            date: parseDate(data[index].createdAt),
                            emotion: data[index].emotion,
                          ),
                        ),
                      ),
                    },
                    child: ListTile(
                      tileColor: moodColors[data[index].emotion],
                      title: Text(parseDate(data[index].createdAt)),
                      trailing: Text(data[index].emotion),
                    ),
                  ),
                ),
                error: (error, stackTrace) => const Text('에러'),
                loading: () => const CircularProgressIndicator(),
              )),
    );
  }
}
