import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:investtech_app/const/chart_const.dart';
import 'package:investtech_app/const/text_style.dart';
import 'package:investtech_app/network/api_repo.dart';
import 'package:investtech_app/network/models/company.dart';
import 'package:investtech_app/ui/blocs/company_bloc.dart';
import 'package:investtech_app/widgets/company_header.dart';

class CompanyBody extends StatelessWidget {
  Company? cmpData;
  final String companyId;
  final int chartId;
  CompanyBody(this.companyId, this.chartId, {Key? key}) : super(key: key);

  List timeSpanString = ['Medium Term', 'Short Term', 'Long Term'];
  List timeSpanChart = ['4', '5', '6'];

  @override
  Widget build(BuildContext context) {
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
        }
        return cmpData == null
            ? const Center(child: CircularProgressIndicator())
            : Column(
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
                      //market: companyObj.marketCode.toString(),
                      term: timeSpanString[
                          chartId - 4]), //companyObj.term.toString(),
                  const SizedBox(
                    height: 10,
                  ),
                  Image.network(ApiRepo().getChartUrl(
                      CHART_TYPE_ADVANCED,
                      timeSpanChart[chartId - 4],
                      CHART_STYLE_NORMAL,
                      companyId)),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    cmpData!.commentText.toString(),
                    style: const TextStyle(
                      fontSize: 12,
                    ),
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
                    height: 10,
                  ),
                  Text(
                    AppLocalizations.of(context)!.short_disclaimer,
                    style: getSmallestTextStyle(),
                    textAlign: TextAlign.center,
                  ),
                ],
              );
      }),
    );
  }
}
