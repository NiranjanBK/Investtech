import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:investtech_app/const/text_style.dart';
import 'package:investtech_app/network/api_repo.dart';
import 'package:investtech_app/network/models/company.dart';
import 'package:investtech_app/ui/blocs/indices_analysis_bloc.dart';
import 'package:investtech_app/widgets/company_header.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// ignore: must_be_immutable
class IndicesDetailPage extends StatelessWidget {
  final String title;
  List<Company>? indicesAnalysis;
  String? analysesDate;

  IndicesDetailPage(this.title, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: BlocProvider<IndicesAnalysesBloc>(
        create: (BuildContext ctx) => IndicesAnalysesBloc(
          ApiRepo(),
        )..add(IndicesAnalysesBlocEvents.LOAD_INDICES),
        child: BlocBuilder<IndicesAnalysesBloc, IndicesAnalysesBlocState>(
            builder: (context, state) {
          if (state is IndicesAnalysesLoadedState) {
            indicesAnalysis = state.IndicesAnalyses;
            analysesDate = state.analysesDate;
          }
          return indicesAnalysis == null
              ? const Align(
                  alignment: Alignment.topCenter,
                  child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.orange)))
              : Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppLocalizations.of(context)!
                              .analysis_home_header_template(
                                  DateTime.fromMillisecondsSinceEpoch(
                                      int.parse(analysesDate.toString()) *
                                          1000)),
                          style: getSmallestTextStyle(),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        ListView.separated(
                          itemCount: indicesAnalysis!.length,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          separatorBuilder: (BuildContext context, int index) =>
                              const Divider(),
                          itemBuilder: (context, index) {
                            return Column(
                              children: [
                                CompanyHeader(
                                  ticker: indicesAnalysis![index].ticker,
                                  companyName: indicesAnalysis![index]
                                      .companyName
                                      .toString(),
                                  changePct: indicesAnalysis![index].changePct,
                                  changeValue: indicesAnalysis![index]
                                      .changeValue
                                      .toString(),
                                  close: indicesAnalysis![index].close!,
                                  evaluation: indicesAnalysis![index]
                                      .evaluation
                                      .toString(),
                                  market: indicesAnalysis![index]
                                      .marketCode
                                      .toString(),
                                  term: indicesAnalysis![index].term.toString(),
                                  evalCode:
                                      indicesAnalysis![index].evaluationCode,
                                ),
                                Image.network(
                                    'https://www.investtech.com/main/img.php?CompanyID=${indicesAnalysis![index].companyId}&chartId=4&indicators=80,81,82,83,84,85,87,88&w=451&h=198'),
                                Text(
                                  indicesAnalysis![index].commentary.toString(),
                                  style: const TextStyle(
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                );
        }),
      ),
    );
  }
}
