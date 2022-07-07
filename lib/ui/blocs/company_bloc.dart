import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:investtech_app/const/pref_keys.dart';
import 'package:investtech_app/network/api_repo.dart';
import 'package:investtech_app/network/models/company.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum CompanyBlocEvents { LOAD_COMPANY }

abstract class CompanyBlocState extends Equatable {
  @override
  List<Object> get props => [];
}

class ReloadCompanyState extends CompanyBlocState {}

class InitialState extends CompanyBlocState {}

class CompanyLoadedState extends CompanyBlocState {
  Company cmpData;
  bool scuscribedUser;

  CompanyLoadedState(this.cmpData, this.scuscribedUser);
}

class CompanyErrorState extends CompanyBlocState {
  String error;

  CompanyErrorState(this.error);
}

class CompanyBloc extends Bloc<CompanyBlocEvents, CompanyBlocState> {
  ApiRepo apiRepo;
  String companyId;
  int? chartId = 4;

  CompanyBloc(this.apiRepo, this.companyId) : super(InitialState());

  @override
  Stream<CompanyBlocState> mapEventToState(CompanyBlocEvents event) async* {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool user = prefs.getBool(PrefKeys.SUBSCRIBED_USER) ?? false;
    switch (event) {
      case CompanyBlocEvents.LOAD_COMPANY:
        Response response = await apiRepo.getCompanyData(chartId, companyId);
        if (response.statusCode == 200) {
          yield CompanyLoadedState(
              Company.fromJson(
                  jsonDecode(jsonEncode(response.data))['company']),
              user);
        } else {
          yield CompanyErrorState(response.statusCode.toString());
        }
        break;
    }
  }
}
