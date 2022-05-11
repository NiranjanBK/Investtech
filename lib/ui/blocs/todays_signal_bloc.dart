import 'dart:async';
import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

import 'package:investtech_app/network/api_repo.dart';
import 'package:investtech_app/network/models/todays_signals_detal.dart';

enum TodaysSignalBlocEvents { LOAD_SIGNALS }

abstract class TodaysSignalBlocState extends Equatable {
  @override
  List<Object> get props => [];
}

class ReloadTodaysSignalState extends TodaysSignalBlocState {}

class InitialState extends TodaysSignalBlocState {}

class TodaysSignalLoadedState extends TodaysSignalBlocState {
  TodaysSignalDetail todaysSignal;

  TodaysSignalLoadedState(this.todaysSignal);
}

class TodaysSignalErrorState extends TodaysSignalBlocState {
  String error;

  TodaysSignalErrorState(this.error);
}

class TodaysSignalBloc
    extends Bloc<TodaysSignalBlocEvents, TodaysSignalBlocState> {
  ApiRepo apiRepo;
  TodaysSignalBloc(this.apiRepo) : super(InitialState());

  @override
  Stream<TodaysSignalBlocState> mapEventToState(
      TodaysSignalBlocEvents event) async* {
    switch (event) {
      case TodaysSignalBlocEvents.LOAD_SIGNALS:
        http.Response response = await apiRepo.getTodaysSignalDetailPage();
        if (response.statusCode == 200) {
          yield TodaysSignalLoadedState(
              TodaysSignalDetail.fromJson(jsonDecode(response.body)));
        } else {
          yield TodaysSignalErrorState(response.statusCode.toString());
        }
        break;
    }
  }
}
