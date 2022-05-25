import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:investtech_app/widgets/theme.dart';
import 'package:meta/meta.dart';

class ThemeEvent {
  final AppTheme? appTheme;
  ThemeEvent({this.appTheme});
}

class ThemeState {
  final ThemeData? themeData;
  ThemeState({this.themeData});
}

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  AppTheme loadTheme;
  ThemeBloc(this.loadTheme)
      : super(
          ThemeState(
            themeData: AppThemes.appThemeData[loadTheme],
          ),
        );
  @override
  Stream<ThemeState> mapEventToState(ThemeEvent event) async* {
    if (event is ThemeEvent) {
      yield ThemeState(
        themeData: AppThemes.appThemeData[event.appTheme],
      );
    }
  }
}
