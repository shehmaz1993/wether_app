
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:weather_app/domain/entities/weather.dart';

import 'package:weather_app/domain/usecases/get_current_weather.dart';

import '../../helpers/test_helpers.mocks.dart';

void main(){

 late GetCurrentWeatherUseCase getCurrentWeatherUseCase;
 late MockWeatherRepository  mockWeatherRepository;

  setUp((){
    mockWeatherRepository = MockWeatherRepository();
    getCurrentWeatherUseCase = GetCurrentWeatherUseCase(mockWeatherRepository);
  });
    const testWeatherDetails=  WeatherEntity(
        cityName: 'New York',
        main: 'Snow',
        description: 'snow',
        iconCode: '13d',
        temperature: 270.5,
        pressure: 1014,
        humidity: 87
    );
    const testCityName ='New York';
         test(
           'Should get current weather details from the repository',
           ()async{
             //arrange
             when(
               mockWeatherRepository.getCurrentWeather(testCityName)
             ).thenAnswer((_) async => const Right(testWeatherDetails));

             //act
             final result =await  getCurrentWeatherUseCase.execute(testCityName);
             //assert
             expect(result, const Right(testWeatherDetails));
            }
           );
}