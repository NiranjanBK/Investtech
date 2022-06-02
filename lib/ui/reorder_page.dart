import 'dart:convert';
import 'package:drag_and_drop_lists/drag_and_drop_lists.dart';
import 'package:flutter/material.dart';
import 'package:investtech_app/network/models/home.dart';
import 'package:investtech_app/ui/home_page.dart';
import 'package:investtech_app/const/pref_keys.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ReorderPage extends StatefulWidget {
  final List<Teaser> products;
  late String reorderString;
  List<Teaser> excludedProducts = [];
  List<Teaser> includedProducts = [];
  List<String> reoderList = [];
  String prefList = '';

  ReorderPage(
    this.products,
    this.reorderString, {
    Key? key,
  }) : super(key: key);

  @override
  _ReorderPageState createState() => _ReorderPageState();
}

class _ReorderPageState extends State<ReorderPage> {
  @override
  void initState() {
    super.initState();

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
    // widget.excludedProducts = [];
    // widget.reoderList = widget.reorderString.split(',');
    // widget.reoderList.map((prodId) {
    //   widget.products.map((product) {
    //     if (prodId == product.id &&
    //         !widget.includedProducts.contains(product)) {
    //       widget.includedProducts.add(product);
    //     }
    //   }).toList();
    // }).toList();

    // widget.products.forEach((element) {
    //   if (!widget.includedProducts.contains(element)) {
    //     widget.excludedProducts.add(element);
    //   }
    // });

    // widget.products.map((product) {
    //   if (widget.reoderList.contains(product.id)) {
    //     widget.includedProducts.add(product);
    //   } else {
    //     widget.excludedProducts.add(product);
    //   }
    // }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          InkWell(
            onTap: () {
              // Navigator.pushAndRemoveUntil(
              //   context,
              //   MaterialPageRoute(builder: (context) => HomeOverview()),
              //   (Route<dynamic> route) => false,
              // );
              String prodId = '';

              int i;
              for (i = 0; i < widget.includedProducts.length - 1; i++) {
                prodId += '${widget.includedProducts[i].id},';
              }
              prodId += widget.includedProducts[i].id;
              addListToSF('items', prodId);
              Navigator.pop(context, true);
            },
            child: const Icon(Icons.check),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ReorderableListView(
              //padding: EdgeInsets.zero,
              shrinkWrap: true,
              children: widget.includedProducts
                  .map((item) => Container(
                        height: 45,
                        decoration: const BoxDecoration(
                            border: Border(
                                bottom: BorderSide(color: Colors.black12))),
                        key: Key(item.id),
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
                                    widget.excludedProducts.add(item);
                                    widget.includedProducts.remove(item);

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
                                item.title,
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
                  Teaser startItem = widget.includedProducts[start];
                  int i = 0;
                  int local = start;
                  do {
                    widget.includedProducts[local] =
                        widget.includedProducts[++local];
                    i++;
                  } while (i < end - start);
                  widget.includedProducts[end] = startItem;
                }
                // dragging from bottom to top
                else if (start > current) {
                  Teaser startItem = widget.includedProducts[start];
                  for (int i = start; i > current; i--) {
                    widget.includedProducts[i] = widget.includedProducts[i - 1];
                  }
                  widget.includedProducts[current] = startItem;
                }
                setState(() {
                  String prodId = '';
                  int i;
                  for (i = 0; i < widget.includedProducts.length - 1; i++) {
                    prodId += '${widget.includedProducts[i].id},';
                  }
                  prodId += widget.includedProducts[i].id;
                  print(prodId);
                  addListToSF('items', prodId);
                });
              },
            ),
            Container(
              height: 45,
              padding: const EdgeInsets.only(left: 10),
              decoration: const BoxDecoration(
                  border: Border(bottom: BorderSide(color: Colors.black12))),
              child: Row(
                children: [
                  Text(widget.excludedProducts.isEmpty
                      ? 'None Excluded'
                      : 'Do not include'),
                ],
              ),
            ),
            ListView.builder(
              shrinkWrap: true,
              itemCount: widget.excludedProducts.length,
              itemBuilder: (context, index) {
                return Container(
                  height: 45,
                  decoration: const BoxDecoration(
                      border:
                          Border(bottom: BorderSide(color: Colors.black12))),
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
                              widget.includedProducts
                                  .add(widget.excludedProducts[index]);
                              widget.excludedProducts
                                  .remove(widget.excludedProducts[index]);
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
                          widget.excludedProducts[index].title.toString(),
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
