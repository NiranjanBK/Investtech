import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:investtech_app/const/theme.dart';
import 'package:meta/meta.dart';

enum ThemeBlocEvents { themeChamged, localeChanged, clearState }

abstract class ThemeBlocState extends Equatable {
  @override
  List<Object> get props => [];
}

class ReloadThemeState extends ThemeBlocState {}

class InitialState extends ThemeBlocState {}

class ThemeLoadedState extends ThemeBlocState {
  final ThemeData? themeData;

  ThemeLoadedState(this.themeData);
}

class ThemeClearState extends ThemeBlocState {
  ThemeClearState();
}

class LocaleChangedState extends ThemeBlocState {
  final Locale? locale;
  LocaleChangedState(this.locale);
}

class ThemeErrorState extends ThemeBlocState {
  String error;

  ThemeErrorState(this.error);
}

class ThemeBloc extends Bloc<ThemeBlocEvents, ThemeBlocState> {
  AppTheme loadTheme;
  Locale locale;
  ThemeBloc(this.loadTheme, this.locale) : super(InitialState());

  @override
  Stream<ThemeBlocState> mapEventToState(ThemeBlocEvents event) async* {
    switch (event) {
      case ThemeBlocEvents.themeChamged:
        yield ThemeLoadedState(AppThemes.appThemeData[loadTheme]);
        break;

      case ThemeBlocEvents.localeChanged:
        yield LocaleChangedState(locale);
        break;
      case ThemeBlocEvents.clearState:
        yield ThemeClearState();
        break;
    }
  }
}
