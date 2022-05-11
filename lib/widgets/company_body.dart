import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
                  Image.network(
                      'https://www.investtech.com/main/img.php?CompanyID=$companyId&chartId=4&indicators=80,81,82,83,84,85,87,88&w=451&h=198'),
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
                      fontSize: 12,
                    ),
                  )
                ],
              );
      }),
    );
  }
}
