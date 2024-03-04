import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:weather_icons/weather_icons.dart';
import 'package:intl/intl.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _WeatherAppState createState() => _WeatherAppState();
}

class _WeatherAppState extends State<MyApp> {
  int temperature = 0;
  String location = 'San Francisco';
  String weather = 'clear';
  String weatherDescription = '';
  double windSpeed = 0.0;
  int humidityValue = 0;
  double chanceOfRainValue = 0.0;

  String apiKey = 'ba2d2be433c1275a6836de7097f7f7e0';
  String searchApiUrl = 'https://api.openweathermap.org/data/2.5/weather?q=';
  String locationApiUrl = 'https://api.openweathermap.org/data/2.5/weather';

  Future<void> fetchSearch(String input) async {
    try {
      var searchResult = await http.get(Uri.parse('$searchApiUrl$input&appid=$apiKey'));
      var result = json.decode(searchResult.body);

      setState(() {
        location = result["name"];
      });

      fetchLocation(location);
    } catch (e) {
      print('Error fetching search: $e');
      setState(() {
        weather = '';
      });
    }
  }

  void fetchLocation(String city) async {
    try {
      var locationResult = await http.get(Uri.parse('$locationApiUrl?q=$city&appid=$apiKey'));
      var result = json.decode(locationResult.body);

      setState(() {
        temperature = (result["main"]["temp"] - 273.15).round(); // Convert to Celsius
        weather = result["weather"][0]["main"].toString().toLowerCase();
        getWeatherIcon(weather);
        weatherDescription = result["weather"][0]["description"];
        windSpeed = result["wind"]["speed"];
        humidityValue = result["main"]["humidity"];
        chanceOfRainValue = (result["rain"] != null && result["rain"]["1h"] != null)
            ? result["rain"]["1h"]
            : 0.0;
      });
    } catch (e) {
      print('Error fetching location: $e');
    }
  }

  Future<void> onTextFieldSubmitted(String input) async {
    try {
      await fetchSearch(input);
    } catch (e) {
      print('Error on text field submitted: $e');
    }
  }

  Icon getWeatherIcon(String weather) {
    switch (weather) {
      case 'clear':
        return Icon(WeatherIcons.day_sunny, size: 150, color: Colors.white);
      case 'clouds':
        return Icon(WeatherIcons.cloud, size: 150, color: Colors.white);
      case 'rain':
        return Icon(WeatherIcons.rain, size: 150, color: Colors.white);
      case 'thunderstorm':
        return Icon(WeatherIcons.thunderstorm, size: 150, color: Colors.white);
      case 'snow':
        return Icon(WeatherIcons.snow, size: 150, color: Colors.white);
      case 'mist':
        return Icon(WeatherIcons.fog, size: 150, color: Colors.white);
      case 'windy':
        return Icon(WeatherIcons.strong_wind, size: 150, color: Colors.white);
      case 'hail':
        return Icon(WeatherIcons.hail, size: 150, color: Colors.white);
      case 'sleet':
        return Icon(WeatherIcons.sleet, size: 150, color: Colors.white);
      case 'tornado':
        return Icon(WeatherIcons.tornado, size: 150, color: Colors.white);
      case 'foggy':
        return Icon(WeatherIcons.fog, size: 150, color: Colors.white);
      case 'partly_cloudy':
        return Icon(WeatherIcons.day_cloudy, size: 150, color: Colors.white);
      case 'drizzle':
        return Icon(WeatherIcons.showers, size: 150, color: Colors.white);
      default:
        return Icon(WeatherIcons.night_rain_mix, size: 150, color: Colors.white);
    }
  }

  Icon getSearchWeatherIcon() {
    if (weather.isEmpty) {
      return Icon(Icons.hourglass_empty, size: 150, color: Colors.white);
    } else {
      return getWeatherIcon(weather);
    }
  }

  String getCurrentDate() {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('EEEE, d MMMM').format(now);
    return formattedDate;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/background.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: SingleChildScrollView(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    width: 300,
                    margin: EdgeInsets.only(bottom: 10, top: 100),
                    child: TextField(
                      onSubmitted: (String input) {
                        onTextFieldSubmitted(input);
                      },
                      style: TextStyle(color: Colors.white, fontSize: 25),
                      decoration: InputDecoration(
                        hintText: 'Search another location...',
                        hintStyle: TextStyle(color: Colors.white, fontSize: 18.0),
                        prefixIcon: Icon(Icons.search, color: Colors.white),
                      ),
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(height: 5),
                      Text(
                        temperature.toString() + ' °C',
                        style: TextStyle(color: Colors.white, fontSize: 100.0),
                      ),
                      Text(
                        location,
                        style: TextStyle(color: Colors.white, fontSize: 40.0),
                      ),
                      getSearchWeatherIcon(),
                      SizedBox(height: 80),
                      Text(
                        weatherDescription,
                        style: TextStyle(color: Colors.white, fontSize: 20.0),
                      ),
                      SizedBox(height: 10),
                      Text(
                        getCurrentDate(),
                        style: TextStyle(color: Colors.white, fontSize: 18.0),
                      ),
                      SizedBox(height: 100),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Column(
                            children: [
                              Text(
                                'Wind',
                                style: TextStyle(color: Colors.white, fontSize: 18.0),
                              ),
                              Icon(
                                Icons.waves,
                                color: Colors.white,
                                size: 30,
                              ),
                              Text(
                                '${windSpeed.toString()} m/s',
                                style: TextStyle(color: Colors.white, fontSize: 18.0),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              Text(
                                'Humidity',
                                style: TextStyle(color: Colors.white, fontSize: 18.0),
                              ),
                              Icon(
                                Icons.opacity,
                                color: Colors.white,
                                size: 30,
                              ),
                              Text(
                                '${humidityValue.toString()}%',
                                style: TextStyle(color: Colors.white, fontSize: 18.0),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              Text(
                                'Rain Chance',
                                style: TextStyle(color: Colors.white, fontSize: 18.0),
                              ),
                              Icon(
                                Icons.wb_sunny,
                                color: Colors.white,
                                size: 30,
                              ),
                              Text(
                                '${chanceOfRainValue.toString()}%',
                                style: TextStyle(color: Colors.white, fontSize: 18.0),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
