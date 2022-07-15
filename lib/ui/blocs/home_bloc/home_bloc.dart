import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:investtech_app/network/api_repo.dart';
import 'package:investtech_app/network/models/home.dart';
import 'package:meta/meta.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(HttpInitialState());


  @override
  Stream<HomeState> mapEventToState(HomeEvent event) async* {
    yield HttpLoadingState();
    if (event is GetHomePageEvent) {
      var response = await getHomePageData(event);
      yield response;
    }
  }

  Future<HomeState> getHomePageData(GetHomePageEvent event) async {
    Response response = await ApiRepo().getHomePgae(event.marketCode);
    if (response.statusCode == 200) {
      var data = Home.fromJson(jsonDecode(jsonEncode(response.data)));
      return HomeLoadedState(data);
    } else {
      var errorBody = json.decode(response.data);
      return ErrorState(errorBody);
    }
  }
}
