import 'package:intl/intl.dart';

class Weather {
  final String cityName;
  final double temperature;
  final double feelsLike;
  final String mainCondition;
  final int humidity;
  final double windSpeed;
  final double windDeg;
  final int cloud;
  final int sunrise;
  final int sunset;

  Weather({
    required this.cityName,
    required this.temperature,
    required this.feelsLike,
    required this.mainCondition,
    required this.humidity,
    required this.windSpeed,
    required this.windDeg,
    required this.cloud,
    required this.sunrise,
    required this.sunset,
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      cityName: json['name'],
      temperature: json['main']['temp'].toDouble(),
      feelsLike: json['main']['feels_like'].toDouble(),
      mainCondition: json['weather'][0]['main'],
      humidity: json['main']['humidity'] as int,
      windSpeed: (json['wind']['speed'] as num).toDouble(),
      windDeg: (json['wind']['deg'] as num).toDouble(),
      cloud: json['clouds']['all'] as int,
      sunrise: json['sys']['sunrise'],
      sunset: json['sys']['sunset'],
    );
  }
}


class TodayHourlyWeather {
  final String? day;            // Gün bilgisi  
  final String? time;           // Saat bilgisi  
  final String? cityName;       // Şehir ismi
  final double? temperature;    // Sıcaklık
  final double? feelsLike;      // Hissedilen sıcaklık
  final String? mainCondition;  // Hava durumu  
  final int? humidity;          // Nem oranı
  final double? windSpeed;      // Rüzgar hızı
  final double? windDeg;        // Rüzgarın açısı
  final int? cloud;             // Bulut yüzdesi

  TodayHourlyWeather({
    this.day,
    this.time,
    this.cityName,
    this.temperature,
    this.feelsLike,
    this.mainCondition,
    this.humidity,
    this.windSpeed,
    this.windDeg,
    this.cloud,
  });

  
  factory TodayHourlyWeather.fromJson(Map<String, dynamic> json) {
    DateTime date = DateTime.parse(json['dt_txt']);  

    return TodayHourlyWeather(
      day: DateFormat("EEEE").format(date),             // Gün formatı  
      time: DateFormat("HH:mm").format(date),           // Saat formatı  
      cityName: json['name'] ?? '',                     // Şehir adı
      temperature: json['main']['temp']?.toDouble(),    // Sıcaklık
      feelsLike: json['main']['feels_like']?.toDouble(),// Hissedilen sıcaklık
      mainCondition: json['weather'][0]['main'],        // Hava durumu
      humidity: json['main']['humidity'] as int?,       // Nem
      windSpeed: (json['wind']['speed'] as num?)?.toDouble(), // Rüzgar hızı
      windDeg: (json['wind']['deg'] as num?)?.toDouble(),     // Rüzgar yönü
      cloud: json['clouds']['all'] as int?,             // Bulutluluk
    );
  }
}
