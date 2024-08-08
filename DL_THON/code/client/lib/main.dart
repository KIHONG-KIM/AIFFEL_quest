import 'package:client/firebase_options.dart';
import 'package:client/repos/mood_repo.dart';
import 'package:client/view_models/mood_view_model.dart';
import 'package:client/views/home_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  final preferences = await SharedPreferences.getInstance();
  final repository = MoodRepository(preferences);
  runApp(
    ProviderScope(
      overrides: [
        moodProvider.overrideWith(
          () => MoodViewModel(repository),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentMood = ref.watch(moodProvider);
    final themeColor = moodColors[currentMood.mood] ?? Colors.grey;
    MaterialColor createMaterialColor(Color color) {
      List strengths = <double>[.05];
      final swatch = <int, Color>{};
      final int r = color.red, g = color.green, b = color.blue;

      for (int i = 1; i < 10; i++) {
        strengths.add(0.1 * i);
      }
      for (var strength in strengths) {
        final double ds = 0.5 - strength;
        swatch[(strength * 1000).round()] = Color.fromRGBO(
          r + ((ds < 0 ? r : (255 - r)) * ds).round(),
          g + ((ds < 0 ? g : (255 - g)) * ds).round(),
          b + ((ds < 0 ? b : (255 - b)) * ds).round(),
          1,
        );
      }
      return MaterialColor(color.value, swatch);
    }

    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: createMaterialColor(themeColor),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const HomeScreen(),
    );
  }
}
