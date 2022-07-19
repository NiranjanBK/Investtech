import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:investtech_app/const/text_style.dart';
import 'package:investtech_app/network/database/database_helper.dart';
import 'package:investtech_app/network/firebase/firebase_services.dart';
import 'package:investtech_app/network/models/company.dart';
import 'package:investtech_app/network/models/favorites.dart';
import 'package:investtech_app/network/models/top20.dart';
import 'package:investtech_app/ui/home/home_page.dart';

import 'package:investtech_app/ui/company%20page/company_body.dart';

class CompanyPageAdvance extends StatefulWidget {
  String companyId;
  final Top20 top20;
  String? companyName;
  String? ticker;
  bool isFavourite = false;
  bool hasNote = false;
  bool hasTimestamp = false;
  CompanyPageAdvance(this.companyId, this.top20);

  @override
  State<CompanyPageAdvance> createState() => _CompanyPageAdvanceState();
}

class _CompanyPageAdvanceState extends State<CompanyPageAdvance> {
  Company? cmpData;
  int? chartId;
  late Future future;
  TextEditingController notesController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    future = DatabaseHelper().checkNoteAndFavorite(widget.companyId);
    super.initState();
  }

  String interpolate(String string, List<String> params) {
    String result = string;
    for (int i = 1; i < params.length + 1; i++) {
      result = result.replaceAll('%$i\$', params[i - 1]);
    }

    return result;
  }

  @override
  Widget build(BuildContext context) {
    var snackBar = SnackBar(
      behavior: SnackBarBehavior.floating,
      width: 230,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      backgroundColor: const Color(0xFF9E9E9E),
      content: Text(
        AppLocalizations.of(context)!.saved_to_favorites,
        style: TextStyle(color: Colors.white),
      ),
      //duration: Duration(seconds: 3),
    );
    List<Tab> tabs = [
      Tab(
        child: Text(
          AppLocalizations.of(context)!.short_term,
          //style: TextStyle(color: Colors.grey),
        ),
      ),
      Tab(
        child: Text(
          AppLocalizations.of(context)!.medium_term,
          style: const TextStyle(fontSize: 12),
        ),
      ),
      Tab(
        child: Text(
          AppLocalizations.of(context)!.long_term,
          //style: TextStyle(color: Colors.grey),
        ),
      ),
    ];

    var chartMap = {0: 5, 1: 4, 2: 6};
    return FutureBuilder(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (jsonDecode(snapshot.data!.toString())['isFavourite']) {
            widget.isFavourite =
                jsonDecode(snapshot.data!.toString())['isFavourite'];
            widget.hasNote = jsonDecode(snapshot.data!.toString())['note']
                    .toString()
                    .isNotEmpty
                ? true
                : false;
            widget.hasTimestamp =
                jsonDecode(snapshot.data!.toString())['timeStamp'] != false
                    ? true
                    : false;

            notesController.text =
                jsonDecode(snapshot.data!.toString())['note'].toString();
          } else {
            widget.isFavourite =
                jsonDecode(snapshot.data!.toString())['isFavourite'];
          }
          return DefaultTabController(
            length: 3,
            initialIndex: 1,
            child: Scaffold(
              appBar: AppBar(
                /*iconTheme: const IconThemeData(
              color: Colors.black, //change your color here
            ),
            backgroundColor: Colors.white,*/
                actions: [
                  InkWell(
                    onTap: () async {
                      if (widget.isFavourite && widget.hasNote) {
                        showDialog<String>(
                          context: context,
                          builder: (BuildContext context) => AlertDialog(
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 24, vertical: 10),
                            title: Text(
                                AppLocalizations.of(context)!.are_you_sure),
                            content: Text(AppLocalizations.of(context)!
                                .note_exists_warning),
                            actions: <Widget>[
                              Column(
                                children: [
                                  SizedBox(
                                    height: 25,
                                    child: TextButton(
                                      style: ButtonStyle(
                                        fixedSize: MaterialStateProperty.all(
                                            const Size(50, 25)),
                                        padding: MaterialStateProperty.all(
                                            const EdgeInsets.all(5)),
                                      ),
                                      child: SizedBox(
                                        height: 25,
                                        child: Text(
                                          AppLocalizations.of(context)!.delete,
                                          style: TextStyle(
                                              color: Colors.orange[800]),
                                        ),
                                      ),
                                      onPressed: () async {
                                        await DatabaseHelper()
                                            .deleteNoteAndFavourite(
                                                widget.companyId);

                                        setState(() {
                                          future = DatabaseHelper()
                                              .checkNoteAndFavorite(
                                                  widget.companyId);
                                          eventBus.fire(ReloadEvent());
                                        });
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ),
                                  TextButton(
                                    //height: 25,
                                    child: Text(
                                      'Cancel',
                                      style:
                                          TextStyle(color: Colors.orange[800]),
                                    ),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              )
                            ],
                          ),
                        );
                      } else if (widget.isFavourite) {
                        int deleteFlag = await DatabaseHelper()
                            .deleteNoteAndFavourite(widget.companyId);
                        print(deleteFlag);

                        setState(() {
                          future = DatabaseHelper()
                              .checkNoteAndFavorite(widget.companyId);
                        });
                        eventBus.fire(ReloadEvent());
                        myEvent.broadcast(Reload(true));
                      } else {
                        var favorite = Favorites(
                            companyName: widget.companyName ?? "",
                            companyId: int.parse(widget.companyId),
                            ticker: widget.ticker ?? "",
                            note: notesController.text,
                            noteTimestamp: DateTime.now()
                                .millisecondsSinceEpoch
                                .toString());
                        await DatabaseHelper().addNoteAndFavorite(favorite);
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        eventBus.fire(ReloadEvent());
                        setState(() {
                          future = DatabaseHelper()
                              .checkNoteAndFavorite(widget.companyId);
                          print('adding');
                        });
                      }
                    },
                    child: Icon(
                      widget.isFavourite
                          ? Icons.star_outlined
                          : Icons.star_border_outlined,
                      color: Colors.orange[500],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: InkWell(
                      onTap: () {
                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          // dialog is dismissible with a tap on the barrier
                          useSafeArea: true,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 24, vertical: 0),
                              actionsPadding: EdgeInsets.zero,
                              title: Text(
                                '${widget.top20.companyName} (${widget.top20.ticker})',
                              ),
                              content: SingleChildScrollView(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Text(
                                      'Notes',
                                      style: TextStyle(fontSize: 14),
                                    ),
                                    const SizedBox(height: 20),
                                    Row(
                                      children: [
                                        Expanded(
                                            child: TextField(
                                          controller: notesController,
                                          style: const TextStyle(fontSize: 12),
                                          cursorColor: const Color(0xFFEF6C00),
                                          maxLines: 8,
                                          //autofocus: true,
                                          decoration: InputDecoration(
                                              isDense: true,
                                              contentPadding:
                                                  const EdgeInsets.all(5),
                                              enabledBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    width: 1,
                                                    color: (Colors.grey[600])!),
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    width: 1,
                                                    color: (Colors.grey[600])!),
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                              )),
                                          onChanged: (value) {
                                            //teamName = value;
                                          },
                                        ))
                                      ],
                                    ),
                                    if (widget.hasTimestamp)
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          Text(
                                            widget.hasTimestamp
                                                ? jsonDecode(snapshot.data!
                                                                    .toString())[
                                                                'timeStamp']
                                                            .toString() ==
                                                        "false"
                                                    ? ''
                                                    : '${AppLocalizations.of(context)!.last_modified} : ${AppLocalizations.of(context)!.note_timestamp(DateTime.fromMillisecondsSinceEpoch(int.parse(jsonDecode(snapshot.data!.toString())['timeStamp'])))}'
                                                : '',
                                            style: getSmallestTextStyle(),
                                          ),
                                        ],
                                      ),
                                  ],
                                ),
                              ),
                              actions: [
                                Column(
                                  children: [
                                    SizedBox(
                                      height: 25,
                                      child: TextButton(
                                        style: ButtonStyle(
                                          fixedSize: MaterialStateProperty.all(
                                              const Size(50, 25)),
                                          padding: MaterialStateProperty.all(
                                              const EdgeInsets.all(5)),
                                        ),
                                        child: SizedBox(
                                          height: 25,
                                          child: Text(
                                            AppLocalizations.of(context)!.save,
                                            style: TextStyle(
                                                color: Colors.orange[800]),
                                          ),
                                        ),
                                        onPressed: () async {
                                          var favorite = Favorites(
                                              companyName:
                                                  widget.companyName ?? "",
                                              companyId:
                                                  int.parse(widget.companyId),
                                              ticker: widget.ticker ?? "",
                                              note: notesController.text,
                                              noteTimestamp: DateTime.now()
                                                  .millisecondsSinceEpoch
                                                  .toString());
                                          await DatabaseHelper()
                                              .addNoteAndFavorite(favorite);
                                          setState(() {
                                            widget.isFavourite = true;
                                            print('adding notes');
                                          });
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                    ),
                                    TextButton(
                                      //height: 25,
                                      child: Text(
                                        AppLocalizations.of(context)!.cancel,
                                        style: TextStyle(
                                            color: Colors.orange[800]),
                                      ),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ],
                                )
                              ],
                            );
                          },
                        );
                      },
                      child: Icon(
                        widget.hasNote
                            ? Icons.mode_comment
                            : Icons.mode_comment_outlined,
                        color: Colors.orange[500],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 16),
                    child: InkWell(
                      onTap: () async {
                        String mylink = await createDynamicLink(
                            widget.companyId, widget.companyName);
                        var shareText = interpolate(
                            AppLocalizations.of(context)!
                                .share_message_template,
                            [widget.companyName.toString(), mylink]);

                        await FlutterShare.share(
                          title: shareText,
                          text: shareText,
                        );
                      },
                      child: Icon(
                        Icons.share,
                        color: Colors.orange[500],
                      ),
                    ),
                  ),
                ],
                bottom: TabBar(
                  indicatorColor: Colors.orange,
                  labelColor: Colors.orange,
                  unselectedLabelColor: Colors.grey,
                  tabs: tabs,
                ),
              ),
              body: Container(
                padding: const EdgeInsets.all(10),
                child: TabBarView(
                  children: tabs.map((Tab tab) {
                    return PageView.builder(
                      itemBuilder: (context, position) {
                        chartId = chartMap[tabs.indexOf(tab)];
                        return const Text('Not In Use!');
                      },
                      itemCount: 1,
                    );
                  }).toList(),
                ),
              ),
            ),
          );
        } else if (snapshot.hasError) {
          return Text('${snapshot.error}');
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
  }
}