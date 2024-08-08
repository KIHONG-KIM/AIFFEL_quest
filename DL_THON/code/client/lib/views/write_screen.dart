import 'package:client/view_models/diary_view_model.dart';
import 'package:client/view_models/mood_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class WriteScreen extends ConsumerStatefulWidget {
  const WriteScreen({super.key});

  @override
  ConsumerState<WriteScreen> createState() => _WriteScreenState();
}

class _WriteScreenState extends ConsumerState<WriteScreen> {
  final TextEditingController _controller = TextEditingController();
  String _text = '';

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      setState(() {
        _text = _controller.text;
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void submit(String content) async {
    if (content != '') {
      final moodVM = ref.read(moodProvider.notifier);
      ref.read(diaryProvider.notifier).createDiary(content, moodVM);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('오늘의 일기'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              child: TextField(
                minLines: 6,
                maxLines: null,
                keyboardType: TextInputType.multiline,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: '일기 입력',
                ),
                controller: _controller,
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            FloatingActionButton(
              onPressed: () => submit(_text),
              child: const Text('완료'),
            ),
          ],
        ),
      ),
    );
  }
}
