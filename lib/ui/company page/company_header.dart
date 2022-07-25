import 'package:flutter/material.dart';
import 'package:investtech_app/const/colors.dart';
import 'package:investtech_app/const/text_style.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:investtech_app/ui/subscription/subscription_page.dart';

class CompanyHeader extends StatelessWidget {
  final String ticker,
      companyName,
      close,
      changePct,
      changeValue,
      evaluation,
      chartId,
      access;
  final bool subscribedUser;
  final String? formattedDate, market, term, evalCode, priceDate, showDate;

  // ignore: use_key_in_widget_constructors
  const CompanyHeader(
      {required this.ticker,
      required this.companyName,
      required this.changePct,
      required this.changeValue,
      required this.close,
      required this.evaluation,
      required this.chartId,
      required this.access,
      required this.subscribedUser,
      this.market,
      this.term,
      this.formattedDate,
      this.evalCode,
      this.priceDate,
      this.showDate});

  @override
  Widget build(BuildContext context) {
    Map<String, String> evalInfo = {
      "4": AppLocalizations.of(context)!.eval_info_medium_term,
      "5": AppLocalizations.of(context)!.eval_info_short_term,
      "6": AppLocalizations.of(context)!.eval_info_long_term,
    };
    var date = formattedDate ?? priceDate;
    return access == 'free' || subscribedUser
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '$companyName (${ticker.toUpperCase()})',
                style: Theme.of(context).textTheme.headline3,
              ),
              Row(
                children: [
                  Text(
                    '${double.parse(close)}',
                    style: Theme.of(context).textTheme.headline3,
                  ),
                  Text(
                    ' (${double.parse(changePct)}%)',
                    style: TextStyle(
                        color: double.parse(changePct) > 0.0
                            ? const Color(ColorHex.green)
                            : const Color(ColorHex.red),
                        fontSize: 12),
                  ),
                  Text(showDate == null ? '' : ', ${date.toString()} ',
                      style: Theme.of(context).textTheme.headline3),
                ],
              ),
              const SizedBox(
                height: 4,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                //crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        evalInfo[chartId].toString(),
                        style: getSmallestTextStyle(),
                        textAlign: TextAlign.right,
                      ),
                    ],
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  Container(
                    padding: const EdgeInsets.only(bottom: 2),
                    decoration: BoxDecoration(
                        border: Border(
                      bottom: BorderSide(
                          color:
                              ColorHex().getBoarderColor(int.parse(evalCode!)),
                          width: 7),
                    )),
                    child: Text(
                      evaluation.toString(),
                      style: Theme.of(context).textTheme.headline1,
                    ),
                  )
                ],
              ),
            ],
          )
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '$companyName (${ticker.toUpperCase()})',
                style: Theme.of(context).textTheme.headline3,
              ),
              Row(
                children: [
                  Text(
                    '${double.parse(close)}',
                    style: Theme.of(context).textTheme.headline3,
                  ),
                  Text(
                    ' (${double.parse(changePct)}%)',
                    style: TextStyle(
                        color: double.parse(changePct) > 0.0
                            ? const Color(ColorHex.green)
                            : const Color(ColorHex.red),
                        fontSize: 12),
                  ),
                  Text(showDate == null ? '' : ', ${date.toString()} ',
                      style: Theme.of(context).textTheme.headline3),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  //crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          evalInfo[chartId].toString(),
                          style: getSmallestTextStyle(),
                          textAlign: TextAlign.right,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        padding: const EdgeInsets.only(bottom: 2, right: 2),
                        decoration: BoxDecoration(
                            border: Border(
                          bottom: BorderSide(
                              color: ColorHex().getBoarderColor(2), width: 7),
                        )),
                        child: Text(
                          AppLocalizations.of(context)!.positive,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Text(
                        AppLocalizations.of(context)!.or,
                        style: const TextStyle(fontSize: 8),
                      ),
                      Container(
                        padding: const EdgeInsets.only(bottom: 2, left: 2),
                        decoration: BoxDecoration(
                            border: Border(
                          bottom: BorderSide(
                              color: ColorHex().getBoarderColor(-2), width: 7),
                        )),
                        child: Text(
                          AppLocalizations.of(context)!.negative,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10, bottom: 15),
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const Subscription(),
                            ));
                      },
                      child: Text(
                        AppLocalizations.of(context)!.free_trail_button_text,
                        style: const TextStyle(
                          color: Color(ColorHex.ACCENT_COLOR),
                        ),
                      ),
                    ),
                  )
                ],
              )
            ],
          );
  }
}
