import 'dart:async';
import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

import 'package:investtech_app/network/api_repo.dart';
import 'package:investtech_app/network/models/search_result.dart';

enum SearchBlocEvents { LOAD_SEARCH, SEARCH_LOADING }

abstract class SearchBlocState extends Equatable {
  @override
  List<Object> get props => [];
}

class ReloadSearchState extends SearchBlocState {}

class InitialState extends SearchBlocState {}

class SearchLoadedState extends SearchBlocState {
  List<SearchResult> searchResult;

  SearchLoadedState(this.searchResult);
}

class SearchLoadingState extends SearchBlocState {
  final bool isLoading;
  SearchLoadingState(this.isLoading);
}

class SearchErrorState extends SearchBlocState {
  String error;

  SearchErrorState(this.error);
}

class SearchBloc extends Bloc<SearchBlocEvents, SearchBlocState> {
  ApiRepo apiRepo;
  String? searchTerm;
  String? marketId;
  bool? isLoading;
  SearchBloc(this.apiRepo) : super(InitialState());

  @override
  Stream<SearchBlocState> mapEventToState(SearchBlocEvents event) async* {
    switch (event) {
      case SearchBlocEvents.LOAD_SEARCH:
        yield SearchLoadingState(true);
        http.Response response =
            await apiRepo.getSearchTerm(searchTerm, marketId);
        if (response.statusCode == 200) {
          var _searchData = jsonDecode(response.body) as List;
          List<SearchResult> _searchResult = _searchData
              .map((result) => SearchResult.fromJson(result))
              .toList();
          yield SearchLoadedState(_searchResult);
        } else {
          yield SearchErrorState(response.statusCode.toString());
        }
        break;
      case SearchBlocEvents.SEARCH_LOADING:
        // TODO: Handle this case.
        //isLoading = true;
        break;
    }
  }
}
