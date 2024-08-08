import 'package:client/repos/mood_repo.dart';
import 'package:client/view_models/mood_view_model.dart';
import 'package:client/views/list_screen.dart';
import 'package:client/views/write_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    DateTime date = DateTime.now();
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '${date.year}.${date.month}.${date.day}',
                  style: const TextStyle(fontSize: 20),
                ),
                const Text(
                  '최근 나의 감정은',
                  style: TextStyle(fontSize: 24),
                ),
                Text(
                  ref.watch(moodProvider).mood,
                  style: TextStyle(
                    fontSize: 20,
                    color: moodColors[ref.read(moodProvider).mood],
                  ),
                )
              ],
            ),
            FloatingActionButton(
              heroTag: 'write',
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const WriteScreen(),
                ),
              ),
              child: const Text('글 쓰기'),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'list',
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const ListScreen(),
          ),
        ),
        child: const Text(
          '목록 보기',
          style: TextStyle(
            fontSize: 12,
          ),
        ),
      ),
    );
  }
}
