import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:weather/screens/main_weather_screen.dart';
import 'package:weather/themes/main.dart';

void main() async {
  await dotenv.load();
  runApp(const MyApp());
}

class MyApp extends HookWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather',
      debugShowCheckedModeBanner: false,
      theme: mainTheme,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Weather'),
          centerTitle: true,
        ),
        body: const MainWeatherScreen(),
      ),
    );
  }
}
