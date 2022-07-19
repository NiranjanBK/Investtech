import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:investtech_app/const/chart_const.dart';
import 'package:investtech_app/const/colors.dart';
import 'package:investtech_app/const/text_style.dart';
import 'package:investtech_app/const/theme.dart';
import 'package:investtech_app/network/api_repo.dart';
import 'package:investtech_app/network/models/company.dart';
import 'package:investtech_app/ui/blocs/company_bloc.dart';
import 'package:investtech_app/ui/blocs/theme_bloc.dart';
import 'package:investtech_app/ui/company%20page/company_header.dart';
import 'package:investtech_app/widgets/no_internet.dart';
import 'package:investtech_app/widgets/progress_indicator.dart';

class CompanyBody extends StatelessWidget {
  Company? cmpData;
  final String companyId;
  final String access;
  final int chartId;
  bool subscribedUser = false;
  CompanyBody(this.companyId, this.chartId, this.access, {Key? key})
      : super(key: key);

  List timeSpanString = ['Medium Term', 'Short Term', 'Long Term'];
  List timeSpanChart = ['4', '5', '6'];

  @override
  Widget build(BuildContext context) {
    ThemeBloc themeBloc = context.read<ThemeBloc>();
    return BlocProvider<CompanyBloc>(
      create: (BuildContext ctx) {
        var bloc = CompanyBloc(
          ApiRepo(),
          companyId,
        );
        bloc.chartId = chartId;
        bloc.add(CompanyBlocEvents.LOAD_COMPANY);
        return bloc;
      },
      child:
          BlocBuilder<CompanyBloc, CompanyBlocState>(builder: (context, state) {
        if (state is CompanyLoadedState) {
          cmpData = state.cmpData;
          subscribedUser = state.scuscribedUser;

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CompanyHeader(
                    ticker: cmpData!.ticker,
                    companyName: cmpData!.name.toString(),
                    changePct: cmpData!.changePct,
                    changeValue: cmpData!.change!.toString(),
                    close: cmpData!.closePrice!,
                    evaluation: cmpData!.evaluationText.toString(),
                    evalCode: cmpData!.evaluationCode,
                    priceDate: cmpData!.priceDate,
                    showDate: 'show',
                    chartId: chartId.toString(),
                    access: access,
                    subscribedUser: subscribedUser,
                    //market: companyObj.marketCode.toString(),
                    term: timeSpanString[
                        chartId - 4]), //companyObj.term.toString(),
                const SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: CachedNetworkImage(
                    imageUrl: ApiRepo().getChartUrl(
                        subscribedUser ? CHART_TYPE_ADVANCED : CHART_TYPE_FREE,
                        chartId,
                        themeBloc.loadTheme == AppTheme.lightTheme
                            ? CHART_STYLE_NORMAL
                            : CHART_STYLE_BLACK,
                        companyId),
                    placeholder: (context, url) => Container(
                        height: 275,
                        width: double.infinity,
                        child: const Center(
                            child: CircularProgressIndicator(
                                color: Color(
                          ColorHex.ACCENT_COLOR,
                        )))),
                    errorWidget: (context, url, error) => SizedBox(
                        height: 275,
                        width: double.infinity,
                        child: Center(
                            child:
                                Image.asset('assets/images/no_thumbnail.png'))),
                  ),
                ),
                subscribedUser
                    ? Text(
                        cmpData!.commentText.toString(),
                        style: const TextStyle(
                          fontSize: 12,
                        ),
                      )
                    : RichText(
                        text: TextSpan(
                            text:
                                '${cmpData!.commentText.toString().substring(0, 110)}... ',
                            style: DefaultTextStyle.of(context).style,
                            children: <TextSpan>[
                              TextSpan(
                                  text: AppLocalizations.of(context)!.read_more,
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      print('Go to subscription page');
                                    },
                                  style: const TextStyle(
                                    color: Color(ColorHex.black),
                                    //decoration: TextDecoration.underline,
                                  ))
                            ]),
                      ),

                const SizedBox(
                  height: 10,
                ),
                Text(
                  'Market: ${cmpData!.marketName}',
                  style: const TextStyle(
                    fontSize: 10,
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Text(
                    AppLocalizations.of(context)!.short_disclaimer,
                    style: getSmallestTextStyle(),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          );
        } else if (state is CompanyErrorState) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              NoInternet(state.error),
              ElevatedButton(
                onPressed: () {
                  context
                      .read<CompanyBloc>()
                      .add(CompanyBlocEvents.LOAD_COMPANY);
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
          return const Center(
            child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.orange)),
          );
        }
      }),
    );
  }
}