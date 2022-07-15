import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:investtech_app/const/chart_const.dart';
import 'package:investtech_app/const/colors.dart';
import 'package:investtech_app/const/text_style.dart';
import 'package:investtech_app/const/theme.dart';
import 'package:investtech_app/network/api_repo.dart';
import 'package:investtech_app/ui/blocs/theme_bloc.dart';
import 'package:investtech_app/ui/company_page.dart';
import 'package:investtech_app/widgets/product_Item_Header.dart';
import '../network/models/company.dart';
import '../widgets/company_header.dart';

class TodaysCandidate extends StatefulWidget {
  final dynamic _companyData, _product;

  TodaysCandidate(this._companyData, this._product);

  @override
  State<TodaysCandidate> createState() => _TodaysCandidateState();
}

class _TodaysCandidateState extends State<TodaysCandidate> {
  ThemeBloc? bloc;
  @override
  void initState() {
    // TODO: implement initState
    bloc = context.read<ThemeBloc>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var _companyJson =
        jsonDecode(jsonEncode(widget._companyData))['content']['case'][0];

    Company companyObj = Company.fromJson(_companyJson);

    return Expanded(
      child: InkWell(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CompanyPage(
                  companyObj.companyId.toString(),
                  4,
                  companyName: companyObj.assetName,
                  ticker: companyObj.ticker,
                ),
              ));
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ProductHeader(
                jsonDecode(jsonEncode(widget._companyData))['title'], 0),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  CompanyHeader(
                      ticker: companyObj.ticker,
                      companyName: companyObj.assetName.toString(),
                      changePct: companyObj.changePct,
                      changeValue: companyObj.changeVal.toString(),
                      close: companyObj.close!,
                      evaluation: companyObj.evaluationText.toString(),
                      evalCode: companyObj.evaluationCode,
                      formattedDate: companyObj.formattedDate,
                      showDate: 'true',
                      chartId: CHART_TERM_MEDIUM,
                      access: 'free',
                      subscribedUser: true,
                      //market: companyObj.marketCode.toString(),
                      term: 'Medium Term'), //companyObj.term.toString(),

                  Padding(
                    padding: const EdgeInsets.only(top: 10, bottom: 10),
                    child: CachedNetworkImage(
                      imageUrl: ApiRepo().getChartUrl(
                          CHART_TYPE_ADVANCED,
                          4,
                          bloc!.loadTheme == AppTheme.lightTheme
                              ? CHART_STYLE_NORMAL
                              : CHART_STYLE_BLACK,
                          companyObj.companyId),
                      placeholder: (context, url) => Container(
                          height: 275,
                          width: double.infinity,
                          child: const Center(
                              child: CircularProgressIndicator(
                                  color: Color(
                            ColorHex.ACCENT_COLOR,
                          )))),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                    ),
                  ),
                  Text(
                    companyObj.text.toString(),
                    style: getDescriptionTextStyle(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
