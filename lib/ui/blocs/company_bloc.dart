import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:investtech_app/network/api_repo.dart';
import 'package:investtech_app/network/models/company.dart';

enum CompanyBlocEvents { LOAD_COMPANY }

abstract class CompanyBlocState extends Equatable {
  @override
  List<Object> get props => [];
}

class ReloadCompanyState extends CompanyBlocState {}

class InitialState extends CompanyBlocState {}

class CompanyLoadedState extends CompanyBlocState {
  Company cmpData;

  CompanyLoadedState(this.cmpData);
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
    switch (event) {
      case CompanyBlocEvents.LOAD_COMPANY:
        http.Response response =
            await apiRepo.getCompanyData(chartId, companyId);
        if (response.statusCode == 200) {
          yield CompanyLoadedState(
              Company.fromJson(jsonDecode(response.body)['company']));
        } else {
          yield CompanyErrorState(response.statusCode.toString());
        }
        break;
    }
  }
}
