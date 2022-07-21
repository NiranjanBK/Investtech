import 'dart:convert';

import 'package:dio/dio.dart';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:investtech_app/network/api_repo.dart';
import 'package:investtech_app/network/database/database_helper.dart';
import 'package:investtech_app/network/models/company.dart';

enum FavouriteBlocEvents { LOAD_FAVOURITE, FAVOURITE_MODIFIED }

abstract class FavouriteBlocState extends Equatable {
  @override
  List<Object> get props => [];
}

class ReloadFavouriteBlocState extends FavouriteBlocState {}

class InitialState extends FavouriteBlocState {}

class FavouriteLoadedState extends FavouriteBlocState {
  String favData;
  FavouriteLoadedState(this.favData);
}

class FavouriteModifiedState extends FavouriteBlocState {
  String favData;
  FavouriteModifiedState(this.favData);
}

class FavouriteLoadingState extends FavouriteBlocState {
  final bool isLoading;
  FavouriteLoadingState(this.isLoading);
}

class FavouriteErrorState extends FavouriteBlocState {
  String error;

  FavouriteErrorState(this.error);
}

class FavouriteBloc extends Bloc<FavouriteBlocEvents, FavouriteBlocState> {
  String companyId;
  String? favData;
  FavouriteBloc(this.companyId) : super(InitialState());

  @override
  Stream<FavouriteBlocState> mapEventToState(FavouriteBlocEvents event) async* {
    switch (event) {
      case FavouriteBlocEvents.LOAD_FAVOURITE:
        //yield IndicesLoadingState(true);
        try {
          favData = await DatabaseHelper().checkNoteAndFavorite(companyId);
          yield FavouriteLoadedState(favData!);
        } on DioError catch (e) {
          final errorMessage = DioExceptions.fromDioError(e).toString();
          yield FavouriteErrorState(errorMessage);
        } on FormatException {
          yield FavouriteErrorState('Format exception');
        } catch (e) {
          yield FavouriteErrorState(e.toString());
        }
        break;

      case FavouriteBlocEvents.FAVOURITE_MODIFIED:
        yield FavouriteLoadingState(true);
        try {
          favData = await DatabaseHelper().checkNoteAndFavorite(companyId);
          yield FavouriteModifiedState(favData!);
        } on DioError catch (e) {
          final errorMessage = DioExceptions.fromDioError(e).toString();
          yield FavouriteErrorState(errorMessage);
        } on FormatException {
          yield FavouriteErrorState('Format exception');
        } catch (e) {
          yield FavouriteErrorState(e.toString());
        }
        break;
    }
  }
}
