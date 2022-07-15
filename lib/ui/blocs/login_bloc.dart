import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

import 'package:investtech_app/network/api_repo.dart';
import 'package:investtech_app/network/models/search_result.dart';

enum LoginBlocEvents { LOGIN_SUBMIT, LOGIN_LOADING }

abstract class LoginBlocState extends Equatable {
  @override
  List<Object> get props => [];
}

class ReloadLoginState extends LoginBlocState {}

class InitialState extends LoginBlocState {}

class LoginLoadedState extends LoginBlocState {
  bool isVerifiedUser;

  LoginLoadedState(this.isVerifiedUser);
}

class LoginLoadingState extends LoginBlocState {
  final bool isLoading;
  LoginLoadingState(this.isLoading);
}

class LoginErrorState extends LoginBlocState {
  String error;

  LoginErrorState(this.error);
}

class LoginBloc extends Bloc<LoginBlocEvents, LoginBlocState> {
  ApiRepo apiRepo;
  String uid = '';
  String pwd = '';
  LoginBloc(this.apiRepo) : super(InitialState());

  @override
  Stream<LoginBlocState> mapEventToState(LoginBlocEvents event) async* {
    switch (event) {
      case LoginBlocEvents.LOGIN_SUBMIT:
        yield LoginLoadingState(true);

        try {
          Response response = await apiRepo.login(uid, pwd);
          if (response.statusCode == 200) {
            yield LoginLoadedState(jsonDecode(response.data));
          }
        } on DioError catch (e) {
          final errorMessage = DioExceptions.fromDioError(e).toString();
          yield LoginErrorState(errorMessage);
        } on FormatException {
          yield LoginErrorState('Format exception');
        } catch (e) {
          yield LoginErrorState(e.toString());
        }

        break;
      case LoginBlocEvents.LOGIN_LOADING:
        // TODO: Handle this case.
        //isLoading = true;
        break;
    }
  }
}
