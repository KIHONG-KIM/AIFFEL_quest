import 'package:client/repos/mood_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ViewScreen extends ConsumerWidget {
  final String content;
  final String date;
  final String emotion;
  const ViewScreen({
    super.key,
    required this.content,
    required this.date,
    required this.emotion,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text(date),
        backgroundColor: moodColors[emotion],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('나의 감정은 "$emotion" 입니다.'),
            const SizedBox(
              height: 20,
            ),
            Container(
              padding: const EdgeInsets.all(10),
              height: size.height * 0.5,
              width: size.width * 0.8,
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.black,
                ),
              ),
              child: Text(content),
            ),
          ],
        ),
      ),
    );
  }
}
