import 'dart:convert';

import 'package:drag_and_drop_lists/drag_and_drop_lists.dart';
import 'package:flutter/material.dart';
import 'package:investtech_app/const/text_style.dart';
import 'package:investtech_app/network/models/home.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:investtech_app/ui/home/home_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ReorderPage extends StatefulWidget {
  final List<Teaser> products;
  final String reorderString;
  final String marketCode;
  List<Teaser> excludedProducts = [];
  List<Teaser> includedProducts = [];
  List<String> reoderList = [];
  List<String> productMap = ['0', '1', '2', '3', '4', '5', '6', '7', '8'];

  List<String> includedProdList = [];
  List<String> excludedProdList = [];

  String prefList = '';

  ReorderPage(
    this.products,
    this.reorderString,
    this.marketCode, {
    Key? key,
  }) : super(key: key);

  @override
  _ReorderPageState createState() => _ReorderPageState();
}

class _ReorderPageState extends State<ReorderPage> {
  @override
  void initState() {
    super.initState();
    print(widget.reorderString);
    if (widget.reorderString == '') {
      widget.products.map((product) {
        widget.includedProducts.add(product);
      }).toList();
    } else {
      widget.reoderList = widget.reorderString.split(',');
      widget.reoderList.map((prodId) {
        widget.products.map((product) {
          if (prodId == product.id &&
              !widget.includedProducts.contains(product)) {
            widget.includedProducts.add(product);
          }
        }).toList();
      }).toList();
    }

    widget.products.forEach((element) {
      if (!widget.includedProducts.contains(element)) {
        widget.excludedProducts.add(element);
      }
    });

    if (widget.reorderString == '') {
      widget.products.map((product) {
        if (product.id == "8" &&
            ["ose", "se_sse", "dk_kfx", "dk_inv"].contains(widget.marketCode)) {
          widget.includedProdList.add(product.id);
        }
        if (product.id != "8") {
          widget.includedProdList.add(product.id);
        }
      }).toList();
      print(widget.includedProdList);
    } else {
      widget.reoderList = widget.reorderString.split(',');
      widget.reoderList.map((prodId) {
        widget.includedProdList.add(prodId);
      }).toList();
    }

    widget.productMap.forEach((element) {
      if (widget.includedProdList.contains(element) == false) {
        if (element == "8" &&
            ["ose", "se_sse", "dk_kfx", "dk_inv"].contains(widget.marketCode)) {
          widget.excludedProdList.add(element);
        }
        if (element != "8") {
          widget.excludedProdList.add(element);
        }
      }
    });

    print(widget.excludedProdList);
  }

  addListToSF(key, value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(key, value);
  }

  getListValuesSF() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return bool
    widget.prefList = prefs.getString('items') ?? widget.reorderString;
  }

  @override
  Widget build(BuildContext context) {
    Map<String, String> productMap = {
      '0': AppLocalizations.of(context)!.stock_exchange_barometer,
      '1': AppLocalizations.of(context)!.market_commentary,
      '2': AppLocalizations.of(context)!.todays_signals.replaceAll('\\', ''),
      '3': AppLocalizations.of(context)!.indices_analysis,
      '4': AppLocalizations.of(context)!.indices_evaluation,
      '5': AppLocalizations.of(context)!.todays_candidate.replaceAll('\\', ''),
      '6': AppLocalizations.of(context)!.top20,
      '7': AppLocalizations.of(context)!.favourites,
      '8': AppLocalizations.of(context)!.web_tv,
    };
    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Center(
              child: Text(AppLocalizations.of(context)!.close,
                  style: Theme.of(context).appBarTheme.toolbarTextStyle)),
        ),
        title: Text(AppLocalizations.of(context)!.home),
        actions: [
          InkWell(
            onTap: () {
              String prodId = '';

              int i;
              for (i = 0; i < widget.includedProdList.length - 1; i++) {
                prodId += '${widget.includedProdList[i]},';
              }
              prodId += widget.includedProdList[i];
              addListToSF('items', prodId);
              eventBus.fire(ReloadEvent());
              Navigator.pop(context, true);
            },
            child: Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Center(
                child: Text(
                  AppLocalizations.of(context)!.save,
                  style: const TextStyle(fontSize: 14),
                ),
              ),
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ReorderableListView(
              //padding: EdgeInsets.zero,
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              children: widget.includedProdList
                  .map((item) => Container(
                        height: 45,
                        decoration: const BoxDecoration(
                            border: Border(
                                bottom: BorderSide(
                                    color: Colors.grey, width: 0.2))),
                        key: Key(item),
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 0.0, horizontal: 16.0),
                          dense: true,
                          title: Row(
                            children: [
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    //String prodId = '';
                                    widget.excludedProdList.add(item);
                                    widget.includedProdList.remove(item);

                                    // int i;
                                    // for (i = 0;
                                    //     i < widget.includedProducts.length - 1;
                                    //     i++) {
                                    //   prodId +=
                                    //       '${widget.includedProducts[i].id},';
                                    // }
                                    // prodId += widget.includedProducts[i].id;
                                    // addListToSF('items', prodId);
                                  });
                                },
                                child: Container(
                                  margin: const EdgeInsets.only(right: 10),
                                  decoration: BoxDecoration(
                                      color: (Colors.red[800])!,
                                      border: Border.all(
                                        color: (Colors.red[800])!,
                                      ),
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(20))),
                                  child: const Icon(
                                    Icons.remove,
                                    color: Colors.white,
                                    size: 15.0,
                                  ),
                                ),
                              ),
                              Text(
                                productMap[item].toString(),
                                style: const TextStyle(fontSize: 15),
                              ),
                            ],
                          ),
                          trailing: const DragHandle(
                              child: Icon(
                            Icons.menu,
                            color: Colors.blueGrey,
                          )),
                        ),
                      ))
                  .toList(),
              onReorder: (int start, int current) {
                // dragging from top to bottom
                if (start < current) {
                  int end = current - 1;
                  String startItem = widget.includedProdList[start];
                  int i = 0;
                  int local = start;
                  do {
                    widget.includedProdList[local] =
                        widget.includedProdList[++local];
                    i++;
                  } while (i < end - start);
                  widget.includedProdList[end] = startItem;
                }
                // dragging from bottom to top
                else if (start > current) {
                  String startItem = widget.includedProdList[start];
                  for (int i = start; i > current; i--) {
                    widget.includedProdList[i] = widget.includedProdList[i - 1];
                  }
                  widget.includedProdList[current] = startItem;
                }
                setState(() {
                  String prodId = '';
                  int i;
                  for (i = 0; i < widget.includedProdList.length - 1; i++) {
                    prodId += '${widget.includedProdList[i]},';
                  }
                  prodId += widget.includedProdList[i];
                  print(prodId);
                  addListToSF('items', prodId);
                });
              },
            ),
            Container(
              height: 45,
              padding: const EdgeInsets.only(left: 10),
              decoration: const BoxDecoration(
                  border: Border(
                      bottom: BorderSide(color: Colors.grey, width: 0.2))),
              // child: Row(
              //   children: [
              //     Text(widget.excludedProducts.isEmpty
              //         ? 'None Excluded'
              //         : 'Do not include'),
              //   ],
              // ),
            ),
            ListView.builder(
              shrinkWrap: true,
              itemCount: widget.excludedProdList.length,
              itemBuilder: (context, index) {
                return Container(
                  height: 45,
                  decoration: const BoxDecoration(
                      border: Border(
                          bottom: BorderSide(color: Colors.grey, width: 0.2))),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 0.0, horizontal: 10.0),
                    dense: true,
                    title: Row(
                      children: [
                        InkWell(
                          onTap: () {
                            setState(() {
                              //String prodId = '';
                              widget.includedProdList
                                  .add(widget.excludedProdList[index]);
                              widget.excludedProdList
                                  .remove(widget.excludedProdList[index]);
                              // int i;
                              // for (i = 0;
                              //     i < widget.includedProducts.length - 1;
                              //     i++) {
                              //   prodId += '${widget.includedProducts[i].id},';
                              // }
                              // prodId += widget.includedProducts[i].id;
                              // addListToSF('items', prodId);
                            });
                          },
                          child: Container(
                            margin: const EdgeInsets.only(right: 10),
                            decoration: BoxDecoration(
                                color: (Colors.green[800])!,
                                border: Border.all(
                                  color: (Colors.green[800])!,
                                ),
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(20))),
                            child: const Icon(
                              Icons.add,
                              color: Colors.white,
                              size: 15,
                            ),
                          ),
                        ),
                        Text(
                          productMap[widget.excludedProdList[index]].toString(),
                          style: const TextStyle(fontSize: 15),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
