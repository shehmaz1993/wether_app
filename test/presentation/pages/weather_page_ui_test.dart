import 'dart:io';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mocktail/mocktail.dart';
import 'package:weather_app/domain/entities/weather.dart';
import 'package:weather_app/presentation/bloc/weather_bloc.dart';
import 'package:weather_app/presentation/bloc/weather_event.dart';
import 'package:weather_app/presentation/bloc/weather_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:weather_app/presentation/pages/weather_page.dart';


class MockWeatherBloc extends MockBloc<WeatherEvent,WeatherState> implements WeatherBloc{}

void main(){

  late MockWeatherBloc mockWeatherBloc;

  setUp((){

    mockWeatherBloc = MockWeatherBloc();
    HttpOverrides.global = null;

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
  Widget _makeTestableWidget(Widget body){
    return BlocProvider<WeatherBloc>(
      create: (context) =>mockWeatherBloc,
      child: MaterialApp(
        home:body ,
      ),
    );
  }
  testWidgets(
      'text field should trigger state from empty to Loading',
          (widgetTester) async {
             //arrange
            when(
                ()=>mockWeatherBloc.state
            ).thenReturn(WeatherEmpty());
            //act
            await widgetTester.pumpWidget(_makeTestableWidget(const WeatherPage()));
            var textField = find.byType(TextField);
            expect(textField, findsOneWidget);
            await widgetTester.enterText(textField, 'New York');
            await widgetTester.pump();
          }
          );
  testWidgets(
      'should show the progress indicator when the state is loading',
          (widgetTester) async {
        //arrange
        when(()=>mockWeatherBloc.state
        ).thenReturn(WeatherLoading());
        //act
        await widgetTester.pumpWidget(_makeTestableWidget(const WeatherPage()));
        var circularProgressIndicator = find.byType(CircularProgressIndicator);
        expect(circularProgressIndicator, findsOneWidget);

      }
  );
  testWidgets(
      'should show widget contain weather data when the state is WeatherLoaded',
          (widgetTester) async {
        //arrange
        when(()=>mockWeatherBloc.state).thenReturn(const WeatherLoaded(testWeather));
        //act
        await widgetTester.pumpWidget(_makeTestableWidget(const WeatherPage()));
        //assert
        expect(find.byKey(const Key('weather_data')), findsOneWidget);

      }
  );
}