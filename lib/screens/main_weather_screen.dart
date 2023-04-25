import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:weather/hooks/use_weather.dart';

class MainWeatherScreen extends HookWidget {
  const MainWeatherScreen({super.key});

  String direction(degrees) {
    if (degrees < 90 || degrees == 360) {
      return 'North';
    } else if (degrees < 180) {
      return 'East';
    } else if (degrees < 270) {
      return 'South';
    } else {
      return 'West';
    }
  }

  String kelvinToCelsius(double kelvin) {
    return (kelvin - 273.15).toStringAsFixed(0);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final theme = Theme.of(context);

    final weather = useWeather(context);

    feedback(data) {
      return '${data ?? 'Unknown'}';
    }

    return SafeArea(
        child: SizedBox(
      width: size.width,
      height: size.height,
      child: Wrap(
          direction: Axis.vertical,
          alignment: WrapAlignment.center,
          runAlignment: WrapAlignment.center,
          spacing: 16,
          runSpacing: 16,
          children: [
            if (weather.isFetching)
              const Text('Loading...', style: TextStyle(letterSpacing: .4))
            else if (weather.error != null)
              const Text('Cannot load data...')
            else ...[
              Text(
                '${feedback(weather.data['name'])}, ${feedback(weather.data['sys']?['country'])}',
                style: theme.textTheme.headlineMedium
                    ?.copyWith(color: Color.fromARGB(255, 245, 245, 245)),
              ),
              ClipRRect(
                  child: Image.network(
                      'https://openweathermap.org/img/wn/${weather.data['weather'][0]['icon']}@2x.png')),
              Text(
                  '${feedback(kelvinToCelsius(weather.data['main']['temp']).replaceFirst('.', ',') + '°C')}',
                  style: theme.textTheme.headlineMedium),
              Text(
                'Feels like: ${feedback(kelvinToCelsius(weather.data['main']['temp']).replaceFirst('.', ',') + '°C')}',
              ),
              Wrap(
                alignment: WrapAlignment.center,
                direction: Axis.horizontal,
                runAlignment: WrapAlignment.spaceBetween,
                spacing: 32,
                children: [
                  Text(weather.data['weather'][0]['main'],
                      style: theme.textTheme.headlineSmall),
                  Text(weather.data['weather'][0]['description'],
                      style: theme.textTheme.headlineSmall),
                ],
              ),
              Wrap(
                alignment: WrapAlignment.center,
                direction: Axis.horizontal,
                runAlignment: WrapAlignment.spaceBetween,
                spacing: 16,
                children: [
                  Text(
                      'Min: ${feedback(kelvinToCelsius(weather.data['main']['temp_min']).replaceFirst('.', ',') + '°C')}'),
                  Text(
                      'Max: ${feedback(kelvinToCelsius(weather.data['main']['temp_max']).replaceFirst('.', ',') + '°C')}'),
                ],
              ),
              Wrap(
                alignment: WrapAlignment.center,
                direction: Axis.horizontal,
                runAlignment: WrapAlignment.spaceBetween,
                spacing: 16,
                children: [
                  Text(
                      'Humidity: ${feedback(weather.data['main']['humidity']).replaceFirst('.', ',')}%'),
                  Text(
                      'Pressure: ${feedback(weather.data['main']['pressure']).replaceFirst('.', ',')}hPa'),
                ],
              ),
              const Divider(),
              Text('Wind', style: theme.textTheme.headlineSmall),
              Text('Speed: ${weather.data['wind']['speed']} m/s'),
              Text('Direction: ${direction(weather.data['wind']['deg'])}'),
            ]
          ]),
    ));
  }
}
