import 'package:dartz/dartz.dart';
import 'package:weather_app/core/error/failure.dart';
import 'package:weather_app/domain/entities/weather.dart';

abstract class WeatherRepository{

  Future<Either<Failure,WeatherEntity>> getCurrentWeather(String cityName);

} 