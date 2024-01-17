import 'package:weather_app/domain/entities/weather.dart';

class WeatherModel extends WeatherEntity{
  const WeatherModel(
      {
        required cityName,
        required main,
        required description,
        required iconCode,
        required temperature,
        required pressure,
        required humidity
      }):super(
          cityName:cityName,
          main:main,
          description:description,
          iconCode:iconCode,
          temperature:temperature,
          pressure:pressure,
          humidity:humidity
     );
  factory WeatherModel.fromJson(Map<String,dynamic> json)=>WeatherModel(
    cityName: json['name'],
    main: json['weather'][0]['main'],
    description:  json['weather'][0]['description'],
    iconCode: json['weather'][0]['icon'],
    temperature: json['main']['temp'],
    pressure: json['main']['pressure'],
    humidity: json['main']['humidity']
  );
  WeatherEntity toEntity()=>WeatherEntity(
      cityName: cityName,
      main: main,
      description: description,
      iconCode: iconCode,
      temperature: temperature,
      pressure: pressure,
      humidity: humidity
  );

}