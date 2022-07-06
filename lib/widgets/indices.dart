import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:investtech_app/const/chart_const.dart';
import 'package:investtech_app/const/colors.dart';
import 'package:investtech_app/const/text_style.dart';
import 'package:investtech_app/network/api_repo.dart';
import 'package:investtech_app/ui/indices_detail_page.dart';
import 'package:investtech_app/widgets/product_Item_Header.dart';
import '../network/models/company.dart';
import '../widgets/company_header.dart';

class Indices extends StatelessWidget {
  final dynamic _companyData, _product;

  Indices(this._companyData, this._product);

  @override
  Widget build(BuildContext context) {
    var _companyJson =
        jsonDecode(jsonEncode(_companyData))['content']['analyses'];

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
                        jsonDecode(jsonEncode(_companyData))['title'])),
              );
            },
            child:
                ProductHeader(jsonDecode(jsonEncode(_companyData))['title'], 1),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
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
                    imageUrl: ApiRepo().getChartUrl(CHART_TYPE_ADVANCED, 4,
                        CHART_STYLE_NORMAL, companyObj.companyId),
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
