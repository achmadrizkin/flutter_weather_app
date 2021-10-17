import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_weather_bloc/model/weather_model.dart';
import 'package:flutter_weather_bloc/repo/weather_repo.dart';

class WeatherEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class FetchWeather extends WeatherEvent {
  // define query
  final _city;

  FetchWeather(this._city);

  @override
  List<Object?> get props => [_city];
}

class ResetWeather extends WeatherEvent {}

class WeatherState extends Equatable {
  @override
  List<Object?> get props => [];
}

class WeatherIsNotSearch extends WeatherState {}

class WeatherIsLoading extends WeatherState {}

class WeatherIsLoaded extends WeatherState {
  final _weather;

  // set getter for using to another class
  WeatherModel get getWeather => _weather;

  WeatherIsLoaded(this._weather);

  @override
  List<Object?> get props => [_weather];
}

class WeatherIsNotLoaded extends WeatherState {}

class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  WeatherBloc(this.weatherRepo) : super(WeatherIsNotSearch());

  WeatherRepo weatherRepo;

  @override
  Stream<WeatherState> mapEventToState(WeatherEvent event) async* {
    if (event is FetchWeather) {
      yield WeatherIsLoading();

      try {
        WeatherModel weatherModel = await weatherRepo.getWeather(event._city);

        // define is loaded
        yield WeatherIsLoaded(weatherModel);
      } catch (e) {
        yield WeatherIsNotLoaded();
      }
    } else if (event is ResetWeather) {
      yield WeatherIsNotSearch();
    }
  }
}
