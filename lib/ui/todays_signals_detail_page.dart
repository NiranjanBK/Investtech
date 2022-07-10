import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:investtech_app/const/colors.dart';
import 'package:investtech_app/const/text_style.dart';
import 'package:investtech_app/main.dart';
import 'package:investtech_app/network/api_repo.dart';
import 'package:investtech_app/network/models/todays_signals_detal.dart';
import 'package:investtech_app/ui/blocs/todays_signal_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:investtech_app/widgets/no_internet.dart';

import 'company_page.dart';

class TodaysSignalDetailPage extends StatelessWidget {
  final String title;
  TodaysSignalDetail? todaysSignal;
  String? analysesDate;

  TodaysSignalDetailPage(this.title, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: BlocProvider<TodaysSignalBloc>(
        create: (BuildContext ctx) => TodaysSignalBloc(
          ApiRepo(),
        )..add(TodaysSignalBlocEvents.LOAD_SIGNALS),
        child: BlocBuilder<TodaysSignalBloc, TodaysSignalBlocState>(
            builder: (context, state) {
          if (state is TodaysSignalLoadedState) {
            todaysSignal = state.todaysSignal;
            analysesDate = state.todaysSignal.analysesDate;

            return todaysSignal == null
                ? const Align(
                    alignment: Alignment.topCenter,
                    child: CircularProgressIndicator(
                        valueColor:
                            AlwaysStoppedAnimation<Color>(Colors.orange)))
                : SingleChildScrollView(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppLocalizations.of(context)!
                              .analysis_home_header_template(
                                  DateTime.fromMillisecondsSinceEpoch(
                                      int.parse(analysisDate) * 1000)),
                          style: getSmallTextStyle(),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        ListView.builder(
                          itemCount: todaysSignal!.signalList.signal.length,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => CompanyPage(
                                        todaysSignal!
                                            .signalList.signal[index].companyId,
                                        4,
                                        companyName: todaysSignal!.signalList
                                            .signal[index].companyName,
                                        ticker: todaysSignal!
                                            .signalList.signal[index].ticker,
                                      ),
                                    ));
                              },
                              child: Container(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10),
                                width: double.infinity,
                                decoration: const BoxDecoration(
                                    border: Border(
                                        bottom: BorderSide(
                                            color: Colors.blueGrey,
                                            width: 0.5))),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${todaysSignal!.signalList.signal[index].companyName} (${todaysSignal!.signalList.signal[index].ticker})',
                                      style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      todaysSignal!
                                          .signalList.signal[index].data,
                                      style: const TextStyle(
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 15),
                          child: Center(
                            child: Text(
                              AppLocalizations.of(context)!.short_disclaimer,
                              style: getSmallestTextStyle(),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
          } else if (state is TodaysSignalErrorState) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const NoInternet(),
                ElevatedButton(
                  onPressed: () {
                    context
                        .read<TodaysSignalBloc>()
                        .add(TodaysSignalBlocEvents.LOAD_SIGNALS);
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
            return const Align(
                alignment: Alignment.topCenter,
                child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.orange)));
          }
        }),
      ),
    );
  }
}
