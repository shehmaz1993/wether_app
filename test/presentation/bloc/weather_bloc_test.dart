import 'package:flutter_test/flutter_test.dart';
import 'package:weather_app/core/error/failure.dart';

import 'package:weather_app/domain/entities/weather.dart';
import 'package:weather_app/presentation/bloc/weather_bloc.dart';
import 'package:weather_app/presentation/bloc/weather_event.dart';
import 'package:weather_app/presentation/bloc/weather_state.dart';
import 'package:bloc_test/bloc_test.dart';
import '../../helpers/test_helpers.mocks.dart';
import 'package:dartz/dartz.dart';
import 'package:mockito/mockito.dart';

void main(){

  late MockGetCurrentWeatherUseCase mockGetCurrentWeatherUseCase;
  late WeatherBloc weatherBloc;
  setUp((){
    mockGetCurrentWeatherUseCase = MockGetCurrentWeatherUseCase();
    weatherBloc = WeatherBloc(mockGetCurrentWeatherUseCase);
  });
  const testWeather=  WeatherEntity(
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
         'Initial bloc test should be empty',
          (){
               expect(weatherBloc.state, WeatherEmpty());
          });
  blocTest<WeatherBloc,WeatherState>(
      'should emit [WeatherLoading, WeatherLoaded] when data is gotten successfully',
      build: () {
        when(
            mockGetCurrentWeatherUseCase.execute(testCityName)
        ).thenAnswer((_)async{
          return const Right(testWeather);
        });
        return weatherBloc;
      },
      act: (bloc)=> bloc.add(const OnCityChanged(testCityName)),
      wait: const Duration(milliseconds: 500),
      expect: ()=>[
        WeatherLoading(),
        const WeatherLoaded(testWeather)
      ]
  );
  blocTest<WeatherBloc,WeatherState>(
      'should emit [WeatherLoading, WeatherLoadFailure] when get data is  unsuccessful',
      build: () {
        when(
            mockGetCurrentWeatherUseCase.execute(testCityName)
        ).thenAnswer((_)async{
          return const Left(ServerFailure('Server failure'));
        });
        return weatherBloc;
      },
      act: (bloc)=> bloc.add(const OnCityChanged(testCityName)),
      wait: const Duration(milliseconds: 500),
      expect: ()=>[
        WeatherLoading(),
        const WeatherLoadFailure('Server failure')
      ]
  );


}