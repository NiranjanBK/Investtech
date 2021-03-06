import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:investtech_app/network/api_repo.dart';
import 'package:investtech_app/network/models/evaluation.dart';

enum IndicesEvalBlocEvents { LOAD_INDICES }

abstract class IndicesEvalBlocState extends Equatable {
  @override
  List<Object> get props => [];
}

class ReloadIndicesEvalState extends IndicesEvalBlocState {}

class InitialState extends IndicesEvalBlocState {}

class IndicesEvalLoadedState extends IndicesEvalBlocState {
  Evaluation IndicesEval;

  IndicesEvalLoadedState(this.IndicesEval);
}

class IndicesEvalErrorState extends IndicesEvalBlocState {
  String error;

  IndicesEvalErrorState(this.error);
}

class IndicesEvalBloc
    extends Bloc<IndicesEvalBlocEvents, IndicesEvalBlocState> {
  ApiRepo apiRepo;
  IndicesEvalBloc(this.apiRepo) : super(InitialState());

  @override
  Stream<IndicesEvalBlocState> mapEventToState(
      IndicesEvalBlocEvents event) async* {
    switch (event) {
      case IndicesEvalBlocEvents.LOAD_INDICES:
        http.Response response = await apiRepo.getIndicesEvalDetailPage();
        if (response.statusCode == 200) {
          yield IndicesEvalLoadedState(
              Evaluation.fromJson(jsonDecode(response.body)));
        } else {
          yield IndicesEvalErrorState(response.statusCode.toString());
        }
        break;
    }
  }
}
