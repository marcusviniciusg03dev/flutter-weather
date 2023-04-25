import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:weather/config/dotenv_config.dart';

class UseWeather {
  UseWeather(
      {required this.data,
      required this.isFetching,
      required this.error,
      required this.requestLocationAccepted});

  bool isFetching;
  String? error;
  Map<String, dynamic> data;
  bool requestLocationAccepted;
}

UseWeather useWeather(BuildContext context) {
  final ValueNotifier<Map<String, dynamic>> data = useState({});
  final ValueNotifier<bool> isFetching = useState(true);
  final ValueNotifier<String?> error = useState(null);
  final requestLocationAccepted = useState(false);

  final GeolocatorPlatform geolocatorPlatform = GeolocatorPlatform.instance;

  Future<bool> handlePermission() async {
    if (!await geolocatorPlatform.isLocationServiceEnabled()) {
      return false;
    }

    LocationPermission permission = await geolocatorPlatform.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await geolocatorPlatform.requestPermission();

      if (permission == LocationPermission.denied) {
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return false;
    }

    return true;
  }

  fetch() async {
    if (await handlePermission()) {
      final geolocation = await geolocatorPlatform.getCurrentPosition();

      if (!isFetching.value) isFetching.value = true;
      if (error.value != null) error.value = null;

      try {
        final res = await http.get(Uri.parse(
            "https://api.openweathermap.org/data/2.5/weather?lat=${geolocation.latitude}&lon=${geolocation.longitude}&appid=${DotenvConfig.openWeatherApiKey}"));

        if (res.statusCode != 200) throw HttpException('${res.statusCode}');

        data.value = json.decode(res.body);
      } catch (err) {
        error.value = err.toString();
      } finally {
        isFetching.value = false;
      }
    } else {
      requestLocationAccepted.value = false;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Permission to access location denied.')));
    }
  }

  useEffect(() {
    fetch();
  }, []);

  return UseWeather(
      data: data.value,
      isFetching: isFetching.value,
      error: error.value,
      requestLocationAccepted: requestLocationAccepted.value);
}
