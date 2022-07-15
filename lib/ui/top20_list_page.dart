import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:investtech_app/const/colors.dart';
import 'package:investtech_app/network/api_repo.dart';
import 'package:investtech_app/network/models/top20_detail.dart';
import 'package:investtech_app/ui/blocs/top20_bloc.dart';
import 'package:investtech_app/widgets/no_internet.dart';
import 'package:investtech_app/widgets/top20_list.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Top20ListPage extends StatelessWidget {
  final String title;
  Top20Detail? top20Companies;
  Top20ListPage(this.title);

  Top20Bloc? bloc;

  @override
  Widget build(BuildContext context) {
    // bloc = BlocProvider.of<Top20Bloc>(context);
    //bloc?.add(Top20BlocEvents.LOAD_TOP20);
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Container(
        padding: const EdgeInsets.all(10),
        child: BlocProvider<Top20Bloc>(
          create: (BuildContext ctx) => Top20Bloc(
            ApiRepo(),
          )..add(Top20BlocEvents.LOAD_TOP20),
          child:
              BlocBuilder<Top20Bloc, Top20BlocState>(builder: (context, state) {
            if (state is Top20LoadedState) {
              top20Companies = state.top20;

              return SingleChildScrollView(
                child: Top20List(top20Companies!.company),
              );
            } else if (state is Top20ErrorState) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  NoInternet(state.error),
                  ElevatedButton(
                    onPressed: () {
                      context.read<Top20Bloc>().add(Top20BlocEvents.LOAD_TOP20);
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
                      valueColor:
                          AlwaysStoppedAnimation<Color>(Colors.orange)));
            }
          }),
        ),
      ),
    );
  }
}
