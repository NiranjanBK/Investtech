import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:investtech_app/network/models/mc_detail.dart';
import 'package:investtech_app/ui/blocs/mc_bloc.dart';

class McListPage extends StatefulWidget {
  Function() onItemSelected;
  Function() onBackPressed;
  McListPage(this.onItemSelected, this.onBackPressed);

  @override
  _McListPageState createState() => _McListPageState();
}

class _McListPageState extends State<McListPage> {
  MarketCommentaryDetail? mc;
  MarketCommentaryBloc? bloc;

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
        mc = state.mc;
      }
      return mc == null
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Analysis: ${mc!.analysesDate.toString()}'),
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: mc!.marketCommentary.length,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (ctx, index) {
                      return InkWell(
                        onTap: () {
                          bloc!.index = index;
                          widget.onItemSelected();
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: Text(
                                mc!.marketCommentary[index].analyze!.title
                                    .toString(),
                                style: const TextStyle(
                                    fontWeight: FontWeight.w700, fontSize: 12),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              width: double.infinity,
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                      width: 1, color: (Colors.grey[400])!),
                                  top: BorderSide(
                                      width: 1, color: (Colors.grey[400])!),
                                ),
                              ),
                              child: Column(
                                children: [
                                  Text(
                                    mc!.marketCommentary[index].analyze!
                                        .ingress!.text
                                        .toString(),
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: mc!.marketCommentary[index]
                                        .analyze!.stocks!.stock.length,
                                    itemBuilder: (ctx, i) {
                                      return Text(
                                          mc!.marketCommentary[index].analyze!
                                              .stocks!.stock[i].companyName
                                              .toString(),
                                          style: const TextStyle(fontSize: 12));
                                    },
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            );
    });
  }
}
