import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:investtech_app/const/chart_const.dart';
import 'package:investtech_app/const/colors.dart';
import 'package:investtech_app/const/text_style.dart';
import 'package:investtech_app/const/theme.dart';
import 'package:investtech_app/main.dart';
import 'package:investtech_app/network/api_repo.dart';
import 'package:investtech_app/network/models/company.dart';
import 'package:investtech_app/ui/blocs/indices_analysis_bloc.dart';
import 'package:investtech_app/ui/blocs/theme_bloc.dart';
import 'package:investtech_app/ui/company%20page/company_page.dart';
import 'package:investtech_app/ui/company%20page/company_header.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:investtech_app/widgets/no_internet.dart';

// ignore: must_be_immutable
class IndicesDetailPage extends StatefulWidget {
  final String title;

  const IndicesDetailPage(this.title, {Key? key}) : super(key: key);

  @override
  State<IndicesDetailPage> createState() => _IndicesDetailPageState();
}

class _IndicesDetailPageState extends State<IndicesDetailPage> {
  List<Company>? indicesAnalysis;
  String? analysesDate;
  ThemeBloc? bloc;

  @override
  void initState() {
    // TODO: implement initState
    bloc = context.read<ThemeBloc>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
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

            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppLocalizations.of(context)!.analysis_home_header_template(
                        DateTime.fromMillisecondsSinceEpoch(
                            int.parse(analysisDate) * 1000)),
                    style: getSmallTextStyle(),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  ListView.separated(
                    itemCount: indicesAnalysis!.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    separatorBuilder: (BuildContext context, int index) =>
                        const Divider(),
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CompanyPage(
                                    indicesAnalysis![index]
                                        .companyId
                                        .toString(),
                                    4,
                                    companyName:
                                        indicesAnalysis![index].companyName,
                                    ticker: indicesAnalysis![index].ticker),
                              ));
                        },
                        child: Column(
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
                              evaluation:
                                  indicesAnalysis![index].evaluation.toString(),
                              market:
                                  indicesAnalysis![index].marketCode.toString(),
                              term: indicesAnalysis![index].term.toString(),
                              evalCode: indicesAnalysis![index].evaluationCode,
                              chartId: CHART_TERM_MEDIUM,
                              access: 'free',
                              subscribedUser: true,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: CachedNetworkImage(
                                imageUrl: ApiRepo().getChartUrl(
                                    CHART_TYPE_ADVANCED,
                                    4,
                                    bloc!.loadTheme == AppTheme.lightTheme
                                        ? CHART_STYLE_NORMAL
                                        : CHART_STYLE_BLACK,
                                    indicesAnalysis![index].companyId),
                                placeholder: (context, url) => Container(
                                    height: 275,
                                    width: double.infinity,
                                    child: const Center(
                                        child: CircularProgressIndicator(
                                            color: Color(
                                      ColorHex.ACCENT_COLOR,
                                    )))),
                                errorWidget: (context, url, error) =>
                                    Icon(Icons.error),
                              ),
                            ),
                            Text(
                              indicesAnalysis![index].commentary.toString(),
                              style: const TextStyle(
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            );
          } else if (state is IndicesAnalysesErrorState) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                NoInternet(state.error),
                ElevatedButton(
                  onPressed: () {
                    context
                        .read<IndicesAnalysesBloc>()
                        .add(IndicesAnalysesBlocEvents.LOAD_INDICES);
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
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.orange)));
          }
        }),
      ),
    );
  }
}
