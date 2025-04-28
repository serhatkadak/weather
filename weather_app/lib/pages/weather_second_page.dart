import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:weather_app/models/weather_model.dart';
import 'package:weather_app/services/weather_services.dart';

class Weather5Days extends StatefulWidget {
  const Weather5Days({super.key});

  @override
  State<Weather5Days> createState() => _Weather5DaysState();
}

class _Weather5DaysState extends State<Weather5Days> {
  final _weatherServices = WeatherServices();
  Weather? _weather;
  List<TodayHourlyWeather> _5DaysForecast = [];

  @override
  void initState() {
    super.initState();
    _fetchWeather();
    _fetch5DayForecast();
  }

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

  Future<void> _fetch5DayForecast() async {
    String cityName = await _weatherServices.getCurrentCity();
    try {
      final forecast = await _weatherServices.get5DayForecast(cityName);
      print("Forecast data: $forecast"); 
      setState(() {
        _5DaysForecast = forecast;
      });
    } catch (e) {
      print("Error fetching forecast: $e");  
    }
  }

  String getWeatherAnimation(String? mainCondition) {
  int currentHour = DateTime.now().hour;
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("5 Günlük Hava Durumu",style: TextStyle(color: Colors.white70,fontSize: 22,fontWeight: FontWeight.bold),),
        backgroundColor: Colors.transparent,
        leading: IconButton(  icon:  Icon(Icons.keyboard_arrow_left,color: Colors.white,),onPressed: () => Navigator.pop(context),),
        
        
      ),
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Center(
          
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Align(),
                Container(
                    height: 350,
                    width: 350,
                    decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(20)),
                    child: Column(
                      children: [
                        Stack(
                          children: [
                            
            Align(
              alignment: AlignmentDirectional(0, -1.2),
              child: Container(
                height: 200,
                width: 300,
                decoration: BoxDecoration(color: Colors.amber[300]),
              ),
            ),
            Align(
              alignment: AlignmentDirectional(0, -1.2),
              child: Container(
                height: 230,
                width: 150,
                decoration: BoxDecoration(color: Colors.blue[600]),
              ),
            ),
            
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 100.0, sigmaY: 100.0),
              child: Container(
                decoration: BoxDecoration(color: Colors.transparent),
              ),
            ),
                            Row(
                              children: [
                                Lottie.asset(
                                    getWeatherAnimation(_weather?.mainCondition),
                                    height: 200,
                                    width: 200),
                                Text(
                                  '${_weather?.cityName}',
                                  style: TextStyle(fontSize: 20, color: Colors.white,fontWeight: FontWeight.bold),
                                )
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 110.0, left: 65),
                              child: Row(
                              children: [
                                Text(
                                  '${_weather?.temperature.round()}',
                                  style: TextStyle(
                                      fontSize: 100, color: Colors.amber,fontWeight: FontWeight.bold),
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "°C",
                                      style: TextStyle(
                                          fontSize: 22, color: Colors.amber),
                                    ),
                                    Text("")
                                  ],
                                ),
                              ],
                            ),
                            )
                          ],
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
                      ],
                    ),
                  ),
                  Expanded(child: besgunluk())
              ],
            ),
          ),
        ),
        
      ),
    );
  }

  Column besgunluk() {
    return Column(
      children: [
        
        Expanded(
                child: ListView.builder(
                  itemCount: _5DaysForecast.length,
                  itemBuilder: (context, index) {
                    TodayHourlyWeather weather = _5DaysForecast[index];
                    return Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Container(
                        height: 120,
                        decoration: BoxDecoration(
                          color:  Colors.grey[50],
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(
                              '${weather.day}',
                              style:
                                  TextStyle(fontSize: 25, color: Colors.blue,fontWeight: FontWeight.bold),
                            ),
                            Row(
                              children: [
                                Text(
                                  '${weather.temperature?.round()}',
                                  style: TextStyle(
                                      fontSize: 55, color: Colors.amber),
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "°C",
                                      style: TextStyle(
                                          fontSize: 22, color: Colors.amber),
                                    ),
                                    Text("")
                                  ],
                                ),
                              ],
                            ),
                            Lottie.asset(
                                getWeatherAnimation(weather.mainCondition)),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
      ],
    );
  }
}


 