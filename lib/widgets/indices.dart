import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:investtech_app/const/chart_const.dart';
import 'package:investtech_app/const/text_style.dart';
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
                Image.network(
                    'https://www.investtech.com/main/img.php?CompanyID=91294651&chartId=4&indicators=80,81,82,83,84,85,87,88&w=451&h=198'),
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
