import 'package:flutter_dotenv/flutter_dotenv.dart';

class DotenvConfig {
  static get openWeatherApiKey => _get('OPEN_WEATHER_API_KEY');
  static String _get(String name) => dotenv.env[name] ?? '';
}
