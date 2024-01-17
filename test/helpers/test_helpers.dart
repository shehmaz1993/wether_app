import 'package:mockito/annotations.dart';
import 'package:weather_app/data/data_sources/remote_data_source.dart';
import 'package:weather_app/domain/repositories/weather_repository.dart';
import 'package:http/http.dart' as http;


@GenerateMocks([
  WeatherRepository,
  WeatherRemoteDataSource
],
  customMocks: [MockSpec<http.Client>(as: #MockHttpClient)]
)

main(){

}