import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:investtech_app/const/chart_const.dart';
import 'package:investtech_app/const/text_style.dart';
import 'package:investtech_app/ui/company_page.dart';
import 'package:investtech_app/widgets/product_Item_Header.dart';
import '../network/models/company.dart';
import '../widgets/company_header.dart';

class TodaysCandidate extends StatelessWidget {
  final dynamic _companyData, _product;

  TodaysCandidate(this._companyData, this._product);

  @override
  Widget build(BuildContext context) {
    var _companyJson =
        jsonDecode(jsonEncode(_companyData))['content']['case'][0];

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
            ProductHeader(jsonDecode(jsonEncode(_companyData))['title'], 0),
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
                  Image.network(
                      'https://www.investtech.com/main/img.php?CompanyID=91294651&chartId=4&indicators=80,81,82,83,84,85,87,88&w=451&h=198'),
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
