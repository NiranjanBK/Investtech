import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:investtech_app/network/api_repo.dart';
import 'package:investtech_app/network/models/evaluation.dart';
import 'package:investtech_app/ui/blocs/indices_eval_bloc.dart';
import 'package:investtech_app/widgets/evaluation_head.dart';
import 'package:investtech_app/widgets/indices_list.dart';

class IndicesEvalDetailPage extends StatefulWidget {
  final String title;

  const IndicesEvalDetailPage(this.title, {Key? key}) : super(key: key);

  @override
  State<IndicesEvalDetailPage> createState() => _IndicesEvalDetailPageState();
}

class _IndicesEvalDetailPageState extends State<IndicesEvalDetailPage> {
  Evaluation? indices;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Container(
          padding: EdgeInsets.all(10),
          child: BlocProvider<IndicesEvalBloc>(
            create: (BuildContext ctx) => IndicesEvalBloc(
              ApiRepo(),
            )..add(IndicesEvalBlocEvents.LOAD_INDICES),
            child: BlocBuilder<IndicesEvalBloc, IndicesEvalBlocState>(
                builder: (context, state) {
              if (state is IndicesEvalLoadedState) {
                indices = state.IndicesEval;
              }
              return indices == null
                  ? const Align(
                  alignment: Alignment.topCenter,
                  child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.orange)))
                  : SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Analysis: ${indices!.analysesDate.toString()}'),
                          const SizedBox(
                            height: 2,
                          ),
                          IndicesEvalTableHead(
                            indicesEvaluation: indices!,
                            page: 'detail',
                          ),
                          IndicesList(
                            indices!.content!,
                            indices!.content!.length,
                            page: 'detail',
                          ),
                        ],
                      ),
                    );
            }),
          ),
        ));
  }
}
