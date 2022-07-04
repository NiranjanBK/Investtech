import 'dart:async';
import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:investtech_app/const/chart_const.dart';
import 'package:investtech_app/const/colors.dart';
import 'package:investtech_app/const/text_style.dart';

import 'package:investtech_app/network/api_repo.dart';
import 'package:investtech_app/network/database/database_helper.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:investtech_app/network/firebase/firebase_services.dart';
import 'package:investtech_app/network/models/favorites.dart';
import 'package:investtech_app/ui/home_page.dart';
import 'package:investtech_app/widgets/company_body.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:investtech_app/widgets/company_price_quote.dart';

import '../widgets/progress_indicator.dart';

class CompanyPage extends StatefulWidget {
  final String cmpId;
  final int chartId;
  String? companyName;
  String? ticker;

  bool isFavourite = false;
  bool hasNote = false;
  bool hasTimestamp = false;

  CompanyPage(this.cmpId, this.chartId,
      {Key? key, this.companyName, this.ticker})
      : super(key: key);

  @override
  State<CompanyPage> createState() => _CompanyPageState();
}

class _CompanyPageState extends State<CompanyPage> {
  TextEditingController notesController = TextEditingController();
  late Future future;
  bool hideAppBar = false;
  int type = CHART_STYLE_NORMAL;

  @override
  void initState() {
    // TODO: implement initState
    future = DatabaseHelper().checkNoteAndFavorite(widget.cmpId);

    super.initState();
  }

  @override
  dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
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

    Widget PortraitMode() {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
          overlays: SystemUiOverlay.values);
      return FutureBuilder(
        future: future,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            print(snapshot.data);
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

            return Scaffold(
              appBar: AppBar(
                // iconTheme: const IconThemeData(
                //   color: Colors.w, //change your color here
                // ),
                // backgroundColor: Colors.white,
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
                                                widget.cmpId);

                                        setState(() {
                                          future = DatabaseHelper()
                                              .checkNoteAndFavorite(
                                                  widget.cmpId);
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
                            .deleteNoteAndFavourite(widget.cmpId);
                        print(deleteFlag);

                        setState(() {
                          future = DatabaseHelper()
                              .checkNoteAndFavorite(widget.cmpId);
                        });
                        eventBus.fire(ReloadEvent());
                        myEvent.broadcast(Reload(true));
                      } else {
                        var favorite = Favorites(
                            companyName: widget.companyName ?? "",
                            companyId: int.parse(widget.cmpId),
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
                              .checkNoteAndFavorite(widget.cmpId);
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
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 24, vertical: 0),
                              actionsPadding: EdgeInsets.zero,
                              title: Text(
                                '${widget.companyName} (${widget.ticker})',
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
                                                  int.parse(widget.cmpId),
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
                            widget.cmpId, widget.companyName);
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
              ),
              body: SingleChildScrollView(
                child: Container(
                    padding: const EdgeInsets.all(10),
                    child: CompanyBody(widget.cmpId, widget.chartId, 'paid')),
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

    Widget LandscapeMode() {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
      if (!hideAppBar) {
        Future.delayed(const Duration(seconds: 10), () {
          setState(() {
            hideAppBar = true;
          });
        });
      }

      return Scaffold(
        // extendBodyBehindAppBar: true,
        // appBar: hideAppBar
        //     ? null
        //     : AppBar(
        //         title: CompanyPriceQuote(widget.cmpId, widget.chartId),
        //       ),
        body: Stack(
          children: [
            GestureDetector(
              onTap: () {
                setState(() {
                  hideAppBar = !hideAppBar;
                });
              },
              child: Stack(
                children: [
                  CachedNetworkImage(
                    width: double.infinity,
                    imageUrl: ApiRepo()
                        .getChartUrl(CHART_TYPE_FREE, 4, type, widget.cmpId),
                    imageBuilder: (context, imageProvider) => Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                            image: imageProvider,
                            fit: BoxFit.fitWidth,
                            colorFilter: const ColorFilter.mode(
                                Colors.red, BlendMode.colorBurn)),
                      ),
                    ),
                    placeholder: (context, url) => Container(
                        height: 275,
                        width: double.infinity,
                        child: const Center(
                            child: CircularProgressIndicator(
                                color: Color(
                          ColorHex.ACCENT_COLOR,
                        )))),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                  ),
                  hideAppBar
                      ? Container()
                      : Positioned(
                          bottom: 0.0,
                          right: 0.0,
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                type = CHART_STYLE_BLACK;
                              });
                            },
                            child: Container(
                              height: 50,
                              width: 50,
                              decoration: const BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(100.0),
                                ),
                              ),
                            ),
                          ),
                        )
                ],
              ),
            ),
            hideAppBar
                ? Container()
                : Container(
                    height: 45,
                    width: double.infinity,
                    padding:
                        const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    decoration: const BoxDecoration(
                        color: Color(ColorHex.white),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey,
                            offset: Offset(0.0, 2.0),
                            blurRadius: 1.5,
                            spreadRadius: 0,
                          ),
                        ],
                        border: Border(
                            bottom: BorderSide(
                          width: 0.8,
                          color: Colors.black12,
                        ))),
                    child: Row(children: [
                      CompanyPriceQuote(widget.cmpId, widget.chartId),
                      const Spacer(),
                      InkWell(
                          onTap: () {
                            setState(() {
                              hideAppBar = !hideAppBar;
                            });
                          },
                          child: const Icon(Icons.close))
                    ]),
                  ),
          ],
        ),
      );
    }

    return OrientationBuilder(
      builder: (context, orientation) {
        return orientation == Orientation.landscape
            ? LandscapeMode()
            : PortraitMode();
      },
    );
  }
}
