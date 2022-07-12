import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:investtech_app/network/api_repo.dart';
import 'package:investtech_app/network/models/top20_detail.dart';

enum Top20BlocEvents { LOAD_TOP20 }

abstract class Top20BlocState extends Equatable {
  @override
  List<Object> get props => [];
}

class ReloadTop20State extends Top20BlocState {}

class InitialState extends Top20BlocState {}

class Top20LoadedState extends Top20BlocState {
  Top20Detail top20;

  Top20LoadedState(this.top20);
}

class Top20ErrorState extends Top20BlocState {
  String error;

  Top20ErrorState(this.error);
}

class Top20Bloc extends Bloc<Top20BlocEvents, Top20BlocState> {
  ApiRepo apiRepo;
  Top20Bloc(this.apiRepo) : super(InitialState());

  @override
  Stream<Top20BlocState> mapEventToState(Top20BlocEvents event) async* {
    switch (event) {
      case Top20BlocEvents.LOAD_TOP20:
        try {
          Response response = await apiRepo.getTop20DetailPage();
          if (response.statusCode == 200) {
            yield Top20LoadedState(
                Top20Detail.fromJson(jsonDecode(jsonEncode(response.data))));
          }
        } on DioError catch (e) {
          final errorMessage = DioExceptions.fromDioError(e).toString();
          yield Top20ErrorState(errorMessage);
        }

        break;
    }
  }
}
