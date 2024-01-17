import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:weather_app/core/error/exception.dart';
import 'package:weather_app/core/error/failure.dart';
import 'package:weather_app/data/data_sources/remote_data_source.dart';
import 'package:weather_app/data/model/weather_model.dart';
import 'package:weather_app/data/repository/weather_repository_impl.dart';
import 'package:weather_app/domain/entities/weather.dart';

import '../../helpers/test_helpers.mocks.dart';

void main(){

  late WeatherRepositoryImpl weatherRepositoryImpl;
  late MockWeatherRemoteDataSource mockWeatherRemoteDataSource;
  setUp((){
    mockWeatherRemoteDataSource =MockWeatherRemoteDataSource();
    weatherRepositoryImpl = WeatherRepositoryImpl(weatherRemoteDataSource: mockWeatherRemoteDataSource);
  });
  const testWeatherEntity=  WeatherEntity(
      cityName: 'New York',
      main: 'Snow',
      description: 'snow',
      iconCode: '13d',
      temperature: 270.5,
      pressure: 1014,
      humidity: 87
  );
  const testWeatherModel = WeatherModel(
      cityName: 'New York',
      main: 'Snow',
      description: 'snow',
      iconCode: '13d',
      temperature: 270.5,
      pressure: 1014,
      humidity: 87
  );
  const cityName = 'New York';
  group('get current weather',
          () {
              test('Should return current weather when call to data source is successful',
                      ()async {
                        //arrange
                        when(
                          mockWeatherRemoteDataSource.getCurrentWeather(cityName)
                        ).thenAnswer((_)async => testWeatherModel);
                        //act
                        final response = await weatherRepositoryImpl.getCurrentWeather(cityName);
                        //
                        expect(response, equals(const Right(testWeatherEntity)));
                  });
              test('Should return a server failure when call to data source is unsuccessful',
                      ()async {
                    //arrange
                    when(
                        mockWeatherRemoteDataSource.getCurrentWeather(cityName)
                    ).thenThrow(ServerException());
                    //act
                    final response = await weatherRepositoryImpl.getCurrentWeather(cityName);
                    //
                    expect(response, equals(const Left(ServerFailure('An error has occurred'))));
                  });
              test('Should return a connection failure when the device has no internet',
                      ()async {
                    //arrange
                    when(
                        mockWeatherRemoteDataSource.getCurrentWeather(cityName)
                    ).thenThrow(const SocketException('Failed to connect to the network'));
                    //act
                    final response = await weatherRepositoryImpl.getCurrentWeather(cityName);
                    //
                    expect(response, equals(const Left(ConnectionFailure('Failed to connect to the network'))));
                  });
    
          }
  );


}