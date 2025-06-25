import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/weather_provider.dart';

class WeatherBox extends StatefulWidget {
  const WeatherBox({super.key});

  @override
  _WeatherBoxState createState() => _WeatherBoxState();
}

class _WeatherBoxState extends State<WeatherBox> {
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchWeatherData();
  }

  Future<void> _fetchWeatherData() async {
    final weatherProvider = Provider.of<WeatherProvider>(context, listen: false);

    try {
      await weatherProvider.fetchWeatherData();
      setState(() {
        errorMessage = null;
      });
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final weatherProvider = Provider.of<WeatherProvider>(context);

    return Container(
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF3F3), // Light reddish background
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(color: const Color(0xFFE66A6C), width: 2.0),
        boxShadow: [
          BoxShadow(
            // ignore: deprecated_member_use
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            '🌦 Weather Details',
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.w700,
              color: Color(0xFFE66A6C),
            ),
          ),
          const SizedBox(height: 12.0),

          if (errorMessage != null)
            const Text(
              "⚠️ Location is turned off",
              style: TextStyle(
                color: Colors.red,
                fontSize: 14.0,
                fontWeight: FontWeight.w600,
              ),
            )
          else
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _weatherDetail(
                      icon: Icons.place,
                      label: 'Location',
                      value: weatherProvider.location,
                    ),
                    _weatherDetail(
                      icon: Icons.thermostat,
                      label: 'Temp',
                      value: weatherProvider.temperature,
                    ),
                  ],
                ),
                const SizedBox(height: 10.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _weatherDetail(
                      icon: Icons.water_drop,
                      label: 'Humidity',
                      value: weatherProvider.humidity,
                    ),
                    _weatherDetail(
                      icon: Icons.air,
                      label: 'Wind',
                      value: weatherProvider.windSpeed,
                    ),
                  ],
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _weatherDetail({required IconData icon, required String label, required String value}) {
    return Row(
      children: [
        Icon(icon, color: Color(0xFFE66A6C), size: 20),
        const SizedBox(width: 6),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 12.0,
                color: Colors.grey,
              ),
            ),
            Text(
              value,
              style: const TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
