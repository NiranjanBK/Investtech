import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:investtech_app/const/chart_const.dart';
import 'package:investtech_app/const/pref_keys.dart';
import 'package:investtech_app/network/api_repo.dart';
import 'package:investtech_app/network/database/database_helper.dart';
import 'package:investtech_app/network/models/company.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum CompanyBlocEvents {
  LOAD_COMPANY,
  FAVOURITE_LOADED,
  REFRESH,
  LOAD_SHORT_TERM,
  LOAD_LONG_TERM,
  LOAD_MEDIUM_TERM
}

abstract class CompanyBlocState extends Equatable {
  @override
  List<Object> get props => [];
}

class ReloadCompanyState extends CompanyBlocState {}

class InitialState extends CompanyBlocState {}

class CompanyLoadedState extends CompanyBlocState {
  Company cmpData;
  bool scuscribedUser;
  String favData;
  int initialIndex;

  CompanyLoadedState(
      this.cmpData, this.scuscribedUser, this.favData, this.initialIndex);
}

class FavouriteLoadedState extends CompanyBlocState {
  Company cmpData;
  bool scuscribedUser;
  String favData;
  FavouriteLoadedState(this.cmpData, this.scuscribedUser, this.favData);
}

class FavouriteRefreshState extends CompanyBlocState {
  FavouriteRefreshState();
}

class CompanyErrorState extends CompanyBlocState {
  String error;

  CompanyErrorState(this.error);
}

class CompanyBloc extends Bloc<CompanyBlocEvents, CompanyBlocState> {
  ApiRepo apiRepo;
  String companyId;
  int? chartId = 4;
  Company? cmpData;
  String? favData;
  bool user = false;

  CompanyBloc(this.apiRepo, this.companyId) : super(InitialState());

  @override
  Stream<CompanyBlocState> mapEventToState(CompanyBlocEvents event) async* {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    user = prefs.getBool(PrefKeys.UNLOCK_ALL) ?? false;

    switch (event) {
      case CompanyBlocEvents.LOAD_COMPANY:
        try {
          favData = await DatabaseHelper().checkNoteAndFavorite(companyId);
          Response response = await apiRepo.getCompanyData(chartId, companyId);
          if (response.statusCode == 200) {
            cmpData = Company.fromJson(
                jsonDecode(jsonEncode(response.data))['company']);
            yield CompanyLoadedState(cmpData!, user, favData!, 1);
          }
        } on DioError catch (e) {
          final errorMessage = DioExceptions.fromDioError(e).toString();
          print(errorMessage);
          yield CompanyErrorState(errorMessage);
        } on FormatException {
          yield CompanyErrorState('Format exception');
        } catch (e) {
          yield CompanyErrorState(e.toString());
        }
        break;

      case CompanyBlocEvents.FAVOURITE_LOADED:
        yield FavouriteRefreshState();
        favData = await DatabaseHelper().checkNoteAndFavorite(companyId);
        yield FavouriteLoadedState(cmpData!, user, favData!);
        break;

      case CompanyBlocEvents.REFRESH:
        break;

      case CompanyBlocEvents.LOAD_SHORT_TERM:
        yield FavouriteRefreshState();
        try {
          Response response =
              await apiRepo.getCompanyData(CHART_TERM_SHORT, companyId);
          if (response.statusCode == 200) {
            cmpData = Company.fromJson(
                jsonDecode(jsonEncode(response.data))['company']);
            yield CompanyLoadedState(cmpData!, user, favData!, 0);
          }
        } on DioError catch (e) {
          final errorMessage = DioExceptions.fromDioError(e).toString();
          print(errorMessage);
          yield CompanyErrorState(errorMessage);
        } on FormatException {
          yield CompanyErrorState('Format exception');
        } catch (e) {
          yield CompanyErrorState(e.toString());
        }
        break;

      case CompanyBlocEvents.LOAD_LONG_TERM:
        yield FavouriteRefreshState();
        try {
          Response response =
              await apiRepo.getCompanyData(CHART_TERM_LONG, companyId);
          if (response.statusCode == 200) {
            cmpData = Company.fromJson(
                jsonDecode(jsonEncode(response.data))['company']);
            yield CompanyLoadedState(cmpData!, user, favData!, 2);
          }
        } on DioError catch (e) {
          final errorMessage = DioExceptions.fromDioError(e).toString();
          print(errorMessage);
          yield CompanyErrorState(errorMessage);
        } on FormatException {
          yield CompanyErrorState('Format exception');
        } catch (e) {
          yield CompanyErrorState(e.toString());
        }
        break;

      case CompanyBlocEvents.LOAD_MEDIUM_TERM:
        yield FavouriteRefreshState();
        try {
          Response response =
              await apiRepo.getCompanyData(CHART_TERM_MEDIUM, companyId);
          if (response.statusCode == 200) {
            cmpData = Company.fromJson(
                jsonDecode(jsonEncode(response.data))['company']);
            yield CompanyLoadedState(cmpData!, user, favData!, 1);
          }
        } on DioError catch (e) {
          final errorMessage = DioExceptions.fromDioError(e).toString();
          print(errorMessage);
          yield CompanyErrorState(errorMessage);
        } on FormatException {
          yield CompanyErrorState('Format exception');
        } catch (e) {
          yield CompanyErrorState(e.toString());
        }
        break;
    }
  }
}
