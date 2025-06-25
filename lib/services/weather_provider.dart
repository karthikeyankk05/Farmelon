import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

class WeatherProvider with ChangeNotifier {
  String location = 'Fetching...';
  String temperature = '0.0 °C';
  String humidity = '0%';
  String windSpeed = '0.0';
  String city = 'Fetching...';
  Map<String, dynamic>? currentWeather;
  List<dynamic>? hourlyForecast;
  List<dynamic>? dailyForecast;
  bool isLoading = true;
  String? errorMessage;

  WeatherProvider() {
    // Ensure the fetchWeatherData runs after the initial build completes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchWeatherData();
    });
  }

  Future<void> fetchWeatherData() async {
    isLoading = true;
    errorMessage = null;

    try {
      Position position = await _determinePosition();
      String apiKey = 'c4fc59b55f8b8620ed146312d8978783';
      String weatherUrl =
          'https://api.openweathermap.org/data/2.5/weather?lat=${position.latitude}&lon=${position.longitude}&units=metric&appid=$apiKey';
      String forecastUrl =
          'https://api.openweathermap.org/data/2.5/forecast?lat=${position.latitude}&lon=${position.longitude}&units=metric&appid=$apiKey';

      // Fetch current weather
      final weatherResponse = await http.get(Uri.parse(weatherUrl));
      if (weatherResponse.statusCode == 200) {
        var data = json.decode(weatherResponse.body);
        location = data['name'];
        temperature = '${data['main']['temp']} °C';
        humidity = '${data['main']['humidity']}%';
        windSpeed = '${data['wind']['speed']} km/hr';
        city = data['name'];
        currentWeather = data;
      } else {
        throw Exception('Failed to load current weather data');
      }

      // Fetch forecast data
      final forecastResponse = await http.get(Uri.parse(forecastUrl));
      if (forecastResponse.statusCode == 200) {
        var forecastData = json.decode(forecastResponse.body);
        hourlyForecast = forecastData['list']?.take(8).toList();
        dailyForecast = forecastData['list']
            ?.where((item) => DateTime.parse(item['dt_txt']).hour == 12)
            .toList();
      } else {
        throw Exception('Failed to load forecast data');
      }
    } catch (e) {
      errorMessage = e.toString();
    }

    isLoading = false;
    // Notify listeners only after all operations complete
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    return await Geolocator.getCurrentPosition();
  }
}