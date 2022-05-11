import 'dart:async';
import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

import 'package:investtech_app/network/api_repo.dart';
import 'package:investtech_app/network/models/mc_detail.dart';

enum MarketCommentaryBlocEvents { LOAD_MC }

abstract class MarketCommentaryBlocState extends Equatable {
  @override
  List<Object> get props => [];
}

class ReloadTop20State extends MarketCommentaryBlocState {}

class InitialState extends MarketCommentaryBlocState {}

class MarketCommentaryLoadedState extends MarketCommentaryBlocState {
  MarketCommentaryDetail mc;

  MarketCommentaryLoadedState(this.mc);
}

class MarketCommentaryErrorState extends MarketCommentaryBlocState {
  String error;

  MarketCommentaryErrorState(this.error);
}

class MarketCommentaryBloc
    extends Bloc<MarketCommentaryBlocEvents, MarketCommentaryBlocState> {
  ApiRepo apiRepo;
  int index = 0;
  MarketCommentaryBloc(this.apiRepo) : super(InitialState());

  @override
  Stream<MarketCommentaryBlocState> mapEventToState(
      MarketCommentaryBlocEvents event) async* {
    switch (event) {
      case MarketCommentaryBlocEvents.LOAD_MC:
        // TODO: Handle this case.
        http.Response response = await apiRepo.getMCDetailPage();
        if (response.statusCode == 200) {
          yield MarketCommentaryLoadedState(
              MarketCommentaryDetail.fromJson(jsonDecode(response.body)));
        } else {
          yield MarketCommentaryErrorState(response.statusCode.toString());
        }
        break;
    }
  }
}
