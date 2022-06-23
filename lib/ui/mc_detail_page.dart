import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:investtech_app/const/text_style.dart';
import 'package:investtech_app/network/models/mc_detail.dart';
import 'package:investtech_app/ui/blocs/mc_bloc.dart';
import 'package:investtech_app/ui/company_page.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MarketCommentaryDetailPage extends StatefulWidget {
  Function(BuildContext context, String companyId) onItemSelected;
  Function() onBackPressed;
  MarketCommentaryDetailPage(this.onItemSelected, this.onBackPressed,
      {Key? key})
      : super(key: key);

  @override
  State<MarketCommentaryDetailPage> createState() =>
      _MarketCommentaryDetailPageState();
}

class _MarketCommentaryDetailPageState
    extends State<MarketCommentaryDetailPage> {
  MarketCommentary? mcDetail;
  MarketCommentaryBloc? bloc;
  String? analysisDate;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    bloc = context.read<MarketCommentaryBloc>();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MarketCommentaryBloc, MarketCommentaryBlocState>(
        builder: (context, state) {
      if (state is MarketCommentaryLoadedState) {
        mcDetail = state.mc.marketCommentary[bloc!.index];
        analysisDate = state.mc.analysesDate;
      } else if (state is InitialState) {
        bloc?.add(MarketCommentaryBlocEvents.LOAD_MC);
      }
      return mcDetail == null
          ? const Align(
              alignment: Alignment.topCenter,
              child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.orange)))
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppLocalizations.of(context)!.analysis_home_header_template(
                        DateTime.fromMillisecondsSinceEpoch(
                            int.parse(analysisDate.toString()) * 1000)),
                    style: getSmallTextStyle(),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Text(
                          mcDetail!.analyze!.title.toString(),
                          style: const TextStyle(
                              fontWeight: FontWeight.w700, fontSize: 12),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          // Navigator.push(
                          //     context,
                          //     MaterialPageRoute(
                          //       builder: (context) => CompanyPage(
                          //         mcDetail!.analyze!.ingress!.companyId
                          //             .toString(),
                          //         4,
                          //       ),
                          //     ));
                          widget.onItemSelected(context,
                              mcDetail!.analyze!.ingress!.companyId.toString());
                        },
                        child: Container(
                          padding: const EdgeInsets.only(bottom: 10),
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                  width: 0.5, color: (Colors.grey[400])!),
                              top: BorderSide(
                                  width: 0.5, color: (Colors.green[400])!),
                            ),
                          ),
                          child: Column(
                            children: [
                              Text(
                                mcDetail!.analyze!.ingress!.text.toString(),
                                style: const TextStyle(fontSize: 12),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Text(
                                mcDetail!.analyze!.marketInfo!.numUpDown
                                    .toString(),
                                style: const TextStyle(fontSize: 12),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Text(
                                mcDetail!.analyze!.marketInfo!.totalTurnOver
                                    .toString(),
                                style: const TextStyle(fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: mcDetail!.analyze!.stocks!.stock.length,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (ctx, index) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          InkWell(
                            onTap: () {
                              widget.onItemSelected(
                                  context,
                                  mcDetail!.analyze!.ingress!.companyId
                                      .toString());
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                      width: 0.5, color: (Colors.grey[400])!),
                                  top: BorderSide(
                                      width: 0.5, color: (Colors.grey[400])!),
                                ),
                              ),
                              child: Text(
                                mcDetail!.analyze!.stocks!.stock[index].text
                                    .toString(),
                                style: const TextStyle(fontSize: 12),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            );
    });
  }
}
