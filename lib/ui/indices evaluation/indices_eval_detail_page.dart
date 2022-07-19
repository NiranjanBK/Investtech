import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:investtech_app/const/colors.dart';
import 'package:investtech_app/const/text_style.dart';
import 'package:investtech_app/main.dart';
import 'package:investtech_app/network/api_repo.dart';
import 'package:investtech_app/network/models/evaluation.dart';
import 'package:investtech_app/ui/blocs/indices_eval_bloc.dart';
import 'package:investtech_app/ui/indices%20evaluation/evaluation_head.dart';
import 'package:investtech_app/ui/indices/indices_list.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:investtech_app/widgets/no_internet.dart';

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
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: BlocProvider<IndicesEvalBloc>(
            create: (BuildContext ctx) => IndicesEvalBloc(
              ApiRepo(),
            )..add(IndicesEvalBlocEvents.LOAD_INDICES),
            child: BlocBuilder<IndicesEvalBloc, IndicesEvalBlocState>(
                builder: (context, state) {
              if (state is IndicesEvalLoadedState) {
                indices = state.IndicesEval;

                return SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Text(
                          AppLocalizations.of(context)!
                              .analysis_home_header_template(
                                  DateTime.fromMillisecondsSinceEpoch(
                                      int.parse(analysisDate) * 1000)),
                          style: getSmallTextStyle(),
                        ),
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
              } else if (state is IndicesEvalErrorState) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    NoInternet(state.error),
                    ElevatedButton(
                      onPressed: () {
                        context
                            .read<IndicesEvalBloc>()
                            .add((IndicesEvalBlocEvents.LOAD_INDICES));
                      },
                      child: Text(AppLocalizations.of(context)!.refresh),
                      style: ButtonStyle(
                          foregroundColor: MaterialStateProperty.all<Color>(
                              const Color(ColorHex.ACCENT_COLOR)),
                          backgroundColor:
                              MaterialStateProperty.all<Color>(Colors.white)),
                    ),
                  ],
                );
              } else {
                return const Align(
                    alignment: Alignment.topCenter,
                    child: CircularProgressIndicator(
                        valueColor:
                            AlwaysStoppedAnimation<Color>(Colors.orange)));
              }
            }),
          ),
        ));
  }
}
