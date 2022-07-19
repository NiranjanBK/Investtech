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
import 'package:investtech_app/ui/indices/indices_detail_page.dart';
import 'package:investtech_app/widgets/product_Item_Header.dart';
import '../../network/models/company.dart';
import '../company page/company_header.dart';

class Indices extends StatefulWidget {
  final dynamic _companyData, _product;

  Indices(this._companyData, this._product);

  @override
  State<Indices> createState() => _IndicesState();
}

class _IndicesState extends State<Indices> {
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
        jsonDecode(jsonEncode(widget._companyData))['content']['analyses'];

    Company companyObj = Company.fromJson(_companyJson);

    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => IndicesDetailPage(
                        jsonDecode(jsonEncode(widget._companyData))['title'])),
              );
            },
            child: ProductHeader(
                jsonDecode(jsonEncode(widget._companyData))['title'], 1),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Column(
              children: [
                CompanyHeader(
                  ticker: companyObj.ticker,
                  companyName: companyObj.companyName.toString(),
                  changePct: companyObj.changePct,
                  changeValue: companyObj.changeValue.toString(),
                  close: companyObj.close!,
                  evaluation: companyObj.evaluation.toString(),
                  market: companyObj.marketCode.toString(),
                  term: companyObj.term.toString(),
                  evalCode: companyObj.evaluationCode,
                  chartId: CHART_TERM_MEDIUM,
                  access: 'free',
                  subscribedUser: true,
                ),
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
                  companyObj.commentary.toString(),
                  style: getDescriptionTextStyle(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
