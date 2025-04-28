import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import 'package:weather_app/models/weather_model.dart';
import 'package:weather_app/pages/weather_second_page.dart';
import 'package:weather_app/services/weather_services.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  final _weatherServices = WeatherServices();
  Weather? _weather;
   
  List<TodayHourlyWeather> _todayHourlyForecast = [];

  _fetchWeather() async {
    String cityName = await _weatherServices.getCurrentCity();

    try {
      final weather = await _weatherServices.getWeather(cityName);

      setState(() {
        _weather = weather;
      });
    } catch (e) {
      print(e);
    }
  }

  Future<void> _fetchTodayHourlyForecast() async {
  String cityName = await _weatherServices.getCurrentCity();
  try {
    final forecast = await _weatherServices.getTodayHourlyForecast(cityName);
    print("Forecast data: $forecast");  
    setState(() {
      _todayHourlyForecast = forecast;
    });
  } catch (e) {
    print("Error fetching forecast: $e");  
  }
}


  String getWeatherAnimation(String? mainCondition) {
  int currentHour = DateTime.now().hour;
  print(currentHour);
  bool isNight = currentHour >= 18 || currentHour < 6;

  if (mainCondition == null) return isNight ? 'assets/moon.json' : 'assets/sun.json';

  switch (mainCondition.toLowerCase()) {
    case 'clouds':
      return isNight ? 'assets/night_cloud.json' : 'assets/cloud.json';
    case 'mist':
    case 'smoke':
    case 'haze':
    case 'dust':
    case 'fog':
      return isNight ? 'assets/night_mist.json' : 'assets/mist.json';
    case 'rain':
    case 'drizzle':
    case 'shower rain':
      return isNight ? 'assets/night_thunder.json' : 'assets/rain.json';
    case 'thunderstorm':
      return isNight ? 'assets/night_thunder.json' : 'assets/rain.json';
    case 'clear':
      return isNight ? 'assets/moon.json' : 'assets/sun.json';
    case 'snow':
      return isNight ? 'assets/night_snow.json' : 'assets/snow.json';

    default:
      return isNight ? 'assets/moon.json' : 'assets/sun.json';
  }
}

  @override
  void initState() {
    super.initState();
    _fetchWeather();
    _fetchTodayHourlyForecast();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        systemOverlayStyle:
            SystemUiOverlayStyle(statusBarBrightness: Brightness.dark),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(40, 1.2 * kToolbarHeight, 40, 20),
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Stack(children: [
            Align(
              alignment: AlignmentDirectional(3, -0.3),
              child: Container(
                height: 300,
                width: 300,
                decoration: BoxDecoration(
                    shape: BoxShape.circle, color: Colors.amber[800]),
              ),
            ),
            Align(
              alignment: AlignmentDirectional(-3, -0.3),
              child: Container(
                height: 300,
                width: 300,
                decoration: BoxDecoration(
                    shape: BoxShape.circle, color: Colors.amber[400]),
              ),
            ),
            Align(
              alignment: AlignmentDirectional(0, -1.2),
              child: Container(
                height: 300,
                width: 600,
                decoration: BoxDecoration(color: Colors.blue[400]),
              ),
            ),
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 100.0, sigmaY: 100.0),
              child: Container(
                decoration: BoxDecoration(color: Colors.transparent),
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    _weather?.cityName ?? 'Şehir bulunamadı.',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w400,
                        fontSize: 22),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Lottie.asset(
                    getWeatherAnimation(_weather?.mainCondition),
                  ),
                  Center(
                    child: Text(
                      '${_weather?.temperature.round().toString()} °C',
                      style: TextStyle(
                          fontSize: 55,
                          fontWeight: FontWeight.w600,
                          color: Colors.white),
                    ),
                  ),
                  Center(
                    child: Text(
                      _weather?.mainCondition ?? ' ',
                      style: TextStyle(
                          fontSize: 35,
                          fontWeight: FontWeight.w400,
                          color: Colors.white),
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Center(
                    child: Text(
                      'Hissedilen Sıcaklık ${_weather?.temperature.round().toString()} °C',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: Colors.white),
                    ),
                  ),
                  Divider(
                    color: Colors.white,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        children: [
                          Icon(
                            Icons.wind_power,
                            color: Colors.white,
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            '${_weather?.windSpeed.round()} Km/h',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w600),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            'Rüzgar',
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          )
                        ],
                      ),
                      Column(
                        children: [
                          Icon(
                            Icons.water_drop_sharp,
                            color: Colors.white,
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            '${_weather?.humidity} %',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w600),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            'Nem Oranı',
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          )
                        ],
                      ),
                      Column(
                        children: [
                          Icon(
                            Icons.cloud,
                            color: Colors.white,
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            '${_weather?.cloud} %',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w600),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            'Bulut',
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          )
                        ],
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Container(
                      child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'Bugün',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: Colors.white),
                          ),
                          GestureDetector(
                            onTap: () => Navigator.push((context),MaterialPageRoute(builder: (context)=>Weather5Days())),
                            child: Text(
                              'Daha Fazla',
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                  color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      _todayHourlyForecast.isEmpty
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: _todayHourlyForecast.map((weather) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 10.0),
                    child: denemeDeneme(weather),
                  );
                }).toList(),
              ),
            ),
    
                    ],
                  )),
                ],
              ),
            )
          ]),
        ),
      ),
    );
  }

  Widget denemeDeneme(TodayHourlyWeather weather) {
    return Container(
      height: 130,
      width: 70,
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(19)),
      child: Padding(
        padding: EdgeInsets.only(top: 14, right: 8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: Text(
                '${weather.time}',  
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.amber),
              ),
            ),
             
            Lottie.asset(getWeatherAnimation(weather.mainCondition)), 
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Center(
                child: Text(
                  '${weather.temperature?.round()}°C',  
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.amber),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  
}
