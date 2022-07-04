import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:investtech_app/const/text_style.dart';
import 'package:investtech_app/network/api_repo.dart';
import 'package:investtech_app/network/models/company.dart';
import 'package:investtech_app/ui/blocs/company_bloc.dart';

class CompanyPriceQuote extends StatelessWidget {
  final String companyId;
  final int chartId;
  Company? cmpData;
  bool? subscribedUser;
  CompanyPriceQuote(this.companyId, this.chartId, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CompanyBloc>(create: (BuildContext ctx) {
      var bloc = CompanyBloc(
        ApiRepo(),
        companyId,
      );
      bloc.chartId = chartId;
      bloc.add(CompanyBlocEvents.LOAD_COMPANY);
      return bloc;
    }, child: BlocBuilder<CompanyBloc, CompanyBlocState>(
      builder: (context, state) {
        if (state is CompanyLoadedState) {
          cmpData = state.cmpData;
          subscribedUser = state.scuscribedUser;
        }
        return cmpData == null
            ? const Center(child: CircularProgressIndicator())
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${cmpData!.name.toString()} (${cmpData!.ticker})',
                    style: getNameAndTickerTextStyle(),
                  ),
                  Row(
                    children: [
                      Text(
                        '${double.parse(cmpData!.closePrice.toString())}',
                        style: getSmallBoldTextStyle(),
                      ),
                      Text(
                        ' (${double.parse(cmpData!.changePct)}%)',
                        style: TextStyle(
                            color: double.parse(cmpData!.changePct) > 0.0
                                ? Colors.green[900]
                                : Colors.red[900],
                            fontSize: 12),
                      ),
                      Text(', ${cmpData!.PriceDate.toString()} ',
                          style: getSmallTextStyle()),
                    ],
                  ),
                ],
              );
      },
    ));
  }
}
