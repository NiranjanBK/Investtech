import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:investtech_app/const/text_style.dart';
import 'package:investtech_app/network/database/database_helper.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:investtech_app/network/models/favorites.dart';
import 'package:investtech_app/widgets/company_body.dart';

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
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: DatabaseHelper().checkNoteAndFavorite(widget.cmpId),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (jsonDecode(snapshot.data!.toString())['isFavourite']) {
            widget.isFavourite =
                jsonDecode(snapshot.data!.toString())['isFavourite'];
            widget.hasNote = jsonDecode(snapshot.data!.toString())['note']
                        .toString()
                        .length >
                    0
                ? true
                : false;
            widget.hasTimestamp =
                jsonDecode(snapshot.data!.toString())['timeStamp']
                            .toString()
                            .length >
                        0
                    ? true
                    : false;

            notesController.text =
                jsonDecode(snapshot.data!.toString())['note'].toString();
          }

          print(widget.isFavourite);
          return Scaffold(
            appBar: AppBar(
              iconTheme: const IconThemeData(
                color: Colors.black, //change your color here
              ),
              backgroundColor: Colors.white,
              actions: [
                Icon(
                  widget.isFavourite
                      ? Icons.star_outlined
                      : Icons.star_border_outlined,
                  color: Colors.orange[500],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: InkWell(
                    onTap: () {
                      showDialog(
                        context: context,
                        barrierDismissible:
                            false, // dialog is dismissible with a tap on the barrier
                        useSafeArea: true,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            contentPadding: EdgeInsets.symmetric(
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
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Text(
                                        widget.hasTimestamp
                                            ? '${AppLocalizations.of(context)!.last_modified} : ${AppLocalizations.of(context)!.note_timestamp(DateTime.fromMillisecondsSinceEpoch(int.parse(jsonDecode(snapshot.data!.toString())['timeStamp'])))}'
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
                                          'Save',
                                          style: TextStyle(
                                              color: Colors.orange[800]),
                                        ),
                                      ),
                                      onPressed: () {
                                        var favorite = Favorites(
                                            companyName:
                                                widget.companyName ?? "",
                                            companyId: int.parse(widget.cmpId),
                                            ticker: widget.ticker ?? "",
                                            note: notesController.text,
                                            noteTimestamp: DateTime.now()
                                                .millisecondsSinceEpoch
                                                .toString());
                                        DatabaseHelper()
                                            .addNoteAndFavorite(favorite);
                                        setState(() {
                                          widget.isFavourite = true;
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
                Icon(
                  Icons.share,
                  color: Colors.orange[500],
                ),
              ],
            ),
            body: SingleChildScrollView(
              child: Container(
                  padding: const EdgeInsets.all(10),
                  child: CompanyBody(widget.cmpId, widget.chartId)),
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
