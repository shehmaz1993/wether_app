

import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:weather_app/data/model/weather_model.dart';
import 'package:weather_app/domain/entities/weather.dart';

import '../../helpers/json_reader.dart';

void main(){
  const testWeatherModel = WeatherModel(
      cityName: 'New York',
      main: 'Snow',
      description: 'snow',
      iconCode: '13d',
      temperature: 270.5,
      pressure: 1014,
      humidity: 87
  );
  test(
    'should be a subclass of weather entity',
      ()async{
        expect(testWeatherModel, isA<WeatherEntity>());
      }
  );
  test(
         'should return a valid model from json',
          ()async{
           //arrange
           final Map<String,dynamic> map = json.decode(
               readJson(
                   'helpers/dumy_data/dummy_weather_response.json'
               )
           );
           //act
            final result = WeatherModel.fromJson(map) ;
            //assert
            expect(result, equals(testWeatherModel));
         }
  );
}