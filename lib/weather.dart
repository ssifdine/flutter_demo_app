import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:weather_icons/weather_icons.dart';

class Weather extends StatefulWidget {
  @override
  _WeatherTabState createState() => _WeatherTabState();
}

class _WeatherTabState extends State<Weather> {
  String city = "Fes";
  List<dynamic>? forecast;

  Future<void> fetchWeather() async {
    final apiKey = kIsWeb
        ? '' 
        : dotenv.env['OPENWEATHER_API_KEY'];

    if (apiKey == null || apiKey.isEmpty) {
      print("❌ API key not found. Please check .env file or provide a key.");
      return;
    }

    final url =
        "https://api.openweathermap.org/data/2.5/forecast?q=$city&appid=$apiKey&units=metric";

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode != 200) {
        throw Exception("Failed to load weather: ${response.body}");
      }
      final data = json.decode(response.body);
      setState(() {
        forecast = data["list"];
      });
    } catch (e) {
      print("❌ Error fetching weather: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    fetchWeather();
  }

  IconData _getWeatherIcon(String condition) {
    switch (condition.toLowerCase()) {
      case 'clear':
        return WeatherIcons.day_sunny;
      case 'clouds':
        return WeatherIcons.cloud;
      case 'rain':
        return WeatherIcons.rain;
      case 'drizzle':
        return WeatherIcons.sprinkle;
      case 'thunderstorm':
        return WeatherIcons.thunderstorm;
      case 'snow':
        return WeatherIcons.snow;
      case 'mist':
      case 'fog':
      case 'haze':
        return WeatherIcons.fog;
      default:
        return WeatherIcons.na;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              decoration: InputDecoration(hintText: "Enter a city..."),
              onChanged: (value) => city = value,
              onSubmitted: (value) {
                city = value;
                fetchWeather();
              },
            ),
          ),
          ElevatedButton(
            onPressed: fetchWeather,
            child: Text("Get Weather"),
          ),
          Expanded(
            child: forecast == null
                ? Center(child: CircularProgressIndicator())
                : ListView.builder(
                    itemCount: forecast!.length,
                    itemBuilder: (context, index) {
                      final item = forecast![index];
                      final date = DateTime.fromMillisecondsSinceEpoch(
                          item["dt"] * 1000);
                      final icon = item["weather"][0]["main"].toLowerCase();
                      final temp = item["main"]["temp"];
                      final desc = item["weather"][0]["description"];

                      return Card(
                        color: Colors.deepOrangeAccent,
                        child: ListTile(
                          leading: BoxedIcon(
                            _getWeatherIcon(icon),
                            color: Colors.white,
                            size: 36,
                          ),
                          title: Text(
                            "${DateFormat('E dd MMM HH:mm').format(date)}",
                            style: TextStyle(color: Colors.white),
                          ),
                          subtitle: Text(
                            "$desc | ${temp.round()}°C",
                            style: TextStyle(color: Colors.white70),
                          ),
                        ),
                      );
                    },
                  ),
          )
        ],
      ),
    );
  }
}
