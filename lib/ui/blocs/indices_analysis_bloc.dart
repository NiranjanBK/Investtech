import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:investtech_app/network/api_repo.dart';
import 'package:investtech_app/network/models/company.dart';

enum IndicesAnalysesBlocEvents { LOAD_INDICES }

abstract class IndicesAnalysesBlocState extends Equatable {
  @override
  List<Object> get props => [];
}

class ReloadIndicesAnalysesState extends IndicesAnalysesBlocState {}

class InitialState extends IndicesAnalysesBlocState {}

class IndicesAnalysesLoadedState extends IndicesAnalysesBlocState {
  dynamic IndicesAnalyses;
  String analysesDate;

  IndicesAnalysesLoadedState(this.IndicesAnalyses, this.analysesDate);
}

class IndicesAnalysesErrorState extends IndicesAnalysesBlocState {
  String error;

  IndicesAnalysesErrorState(this.error);
}

class IndicesAnalysesBloc
    extends Bloc<IndicesAnalysesBlocEvents, IndicesAnalysesBlocState> {
  ApiRepo apiRepo;
  IndicesAnalysesBloc(this.apiRepo) : super(InitialState());

  @override
  Stream<IndicesAnalysesBlocState> mapEventToState(
      IndicesAnalysesBlocEvents event) async* {
    switch (event) {
      case IndicesAnalysesBlocEvents.LOAD_INDICES:
        http.Response response = await apiRepo.getIndicesAnalysesDetailPage();
        if (response.statusCode == 200) {
          var _indicesAnalyses = jsonDecode(response.body)['analyses'] as List;
          List<Company> indicesAnalysis = _indicesAnalyses
              .map((indice) => Company.fromJson(indice))
              .toList();
          yield IndicesAnalysesLoadedState(
              indicesAnalysis, jsonDecode(response.body)['analysesDate']);
        } else {
          yield IndicesAnalysesErrorState(response.statusCode.toString());
        }
        break;
    }
  }
}
