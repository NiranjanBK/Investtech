import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:investtech_app/network/api_repo.dart';
import 'package:investtech_app/network/models/todays_signals_detal.dart';
import 'package:investtech_app/ui/blocs/todays_signal_bloc.dart';

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
          }
          return todaysSignal == null
              ? const Align(
              alignment: Alignment.topCenter,
              child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.orange)))
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Analysis: ' + analysesDate.toString()),
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
                                      companyName: todaysSignal!
                                          .signalList.signal[index].companyName,
                                      ticker: todaysSignal!
                                          .signalList.signal[index].ticker,
                                    ),
                                  ));
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              width: double.infinity,
                              decoration: const BoxDecoration(
                                  border: Border(
                                      bottom: BorderSide(
                                          color: Colors.blueGrey, width: 0.5))),
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
                                    todaysSignal!.signalList.signal[index].data,
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
                      const Text('Disclaimer'),
                    ],
                  ),
                );
        }),
      ),
    );
  }
}
