import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:weather_app/core/constants/constants.dart';
import 'package:weather_app/core/error/exception.dart';
import 'package:weather_app/data/data_sources/remote_data_source.dart';
import 'package:http/http.dart' as http;
import 'package:weather_app/data/model/weather_model.dart';
import '../../helpers/json_reader.dart';
import '../../helpers/test_helpers.mocks.dart';

void main(){

  late MockHttpClient  mockHttpClient;
  late WeatherRemoteDataSourceImpl weatherRemoteDataSourceImpl;

  setUp((){
     mockHttpClient = MockHttpClient();
     weatherRemoteDataSourceImpl = WeatherRemoteDataSourceImpl(client: mockHttpClient);
  });
  const city =" New Work";
  group(
      'get current weather',
          () {
             test('Should return weather model when the response code is 200',
                     ()async {

                        when(
                          mockHttpClient.get(
                            Uri.parse(Urls.currentWeatherByName(city))
                          )
                        ).thenAnswer((_)async =>
                            http.Response(
                                readJson('helpers/dumy_data/dummy_weather_response.json'),
                                200
                            )
                        );
                        //act
                       final result = await weatherRemoteDataSourceImpl.getCurrentWeather(city);
                       //assert
                       expect(result, isA<WeatherModel>());

                     }
             );
             test('Should throw a server exception when the response code is 404 or others',
                     ()async {
                   //arrange
                   when(
                       mockHttpClient.get(
                           Uri.parse(Urls.currentWeatherByName(city))
                       )
                   ).thenAnswer((_)async =>
                       http.Response(
                           'Not found',
                            404
                       )
                   );
                   //act
                   final result =  weatherRemoteDataSourceImpl.getCurrentWeather(city);
                   //assert
                   expect(result, throwsA(isA<ServerException>()));

                 }
             );
          });

}