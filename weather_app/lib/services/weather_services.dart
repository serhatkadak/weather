import 'dart:convert';

import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weather_app/models/weather_model.dart';
import 'package:http/http.dart' as http;

class WeatherServices {
  static const BASE_URL = ' ';
  final String apiKey=' ';
  WeatherServices();

  Future<Weather> getWeather(String cityName) async {
    final response = await http
        .get(Uri.parse('$BASE_URL/weather?q=$cityName&appid=$apiKey&units=metric'));

    if (response.statusCode == 200) {
      return Weather.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('hava durumu yüklenirken hata oluştu');
    }
  }

  Future<String> getCurrentCity() async {
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    List<Placemark> placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);

    String? city = placemarks[0].locality;
  
  // Şehir bilgisi alınamazsa hata fırlatıyoruz
  if (city == null || city.isEmpty) {
    throw Exception('Şehir bilgisi alınamadı');
  }
  
  return city;
}

  Future<List<TodayHourlyWeather>> getTodayHourlyForecast(String cityName) async {
String cityName = await getCurrentCity();
print('City Name: $cityName');
final response = await http.get(Uri.parse(
    '$BASE_URL/forecast?q=${Uri.encodeComponent(cityName)}&appid=$apiKey&units=metric',
  ));


   print('Response Status: ${response.statusCode}');
  print('Response Body: ${response.body}');

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    
    // 'list' alanının olup olmadığını kontrol ediyoruz
    if (data['list'] != null) {
      List<dynamic> forecastData = data['list'];

      DateTime today = DateTime.now();
      List<TodayHourlyWeather> todayForecast = [];

      for (var item in forecastData) {
        DateTime date = DateTime.parse(item['dt_txt']);
        if (date.day == today.day && date.month == today.month && date.year == today.year) {
          todayForecast.add(TodayHourlyWeather.fromJson(item));
        }
      }
      
      return todayForecast;
    } else {
      throw Exception('Hava durumu verisi bulunamadı.');
    }
  } else {
    throw Exception('Error: ${response.statusCode}, ${response.reasonPhrase}');
  }
}


  Future<List<TodayHourlyWeather>> get5DayForecast(String cityName) async {
  final response = await http.get(Uri.parse(
    '$BASE_URL/forecast?q=$cityName&appid=$apiKey&units=metric',
  ));

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    List<dynamic> forecastData = data['list'];

    List<TodayHourlyWeather> fiveDayForecast = [];
    DateTime? lastDate;

     
    for (var item in forecastData) {
      DateTime date = DateTime.parse(item['dt_txt']);
      if (date.hour == 12 && (lastDate == null || date.day != lastDate.day)) {
        fiveDayForecast.add(TodayHourlyWeather.fromJson(item));
        lastDate = date;
      }
    }

    return fiveDayForecast;
  } else {
    throw Exception('5 günlük hava durumu yüklenirken hata oluştu');
  }
}
}
