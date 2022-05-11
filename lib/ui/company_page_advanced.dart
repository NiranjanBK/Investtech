import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:investtech_app/network/api_repo.dart';
import 'package:investtech_app/network/models/company.dart';
import 'package:investtech_app/ui/blocs/company_bloc.dart';
import 'package:investtech_app/widgets/company_body.dart';
import 'package:investtech_app/widgets/company_header.dart';

const List<Tab> tabs = [
  Tab(
    child: Text(
      'SHORT TERM',
      //style: TextStyle(color: Colors.grey),
    ),
  ),
  Tab(
    child: Text(
      'MEDIUM TERM',
      //style: TextStyle(color: Colors.grey),
    ),
  ),
  Tab(
    child: Text(
      'LONG TERM',
      //style: TextStyle(color: Colors.grey),
    ),
  ),
];

var chartMap = {0: 5, 1: 4, 2: 6};

class CompanyPageAdvance extends StatelessWidget {
  Company? cmpData;
  int? chartId;
  String companyId;

  CompanyPageAdvance(this.companyId);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      initialIndex: 1,
      child: Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(
            color: Colors.black, //change your color here
          ),
          backgroundColor: Colors.white,
          actions: [
            Icon(
              Icons.star_border_outlined,
              color: Colors.orange[500],
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Icon(
                Icons.mode_comment_outlined,
                color: Colors.orange[500],
              ),
            ),
            Icon(
              Icons.share,
              color: Colors.orange[500],
            ),
          ],
          bottom: const TabBar(
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
                  return CompanyBody(companyId, chartId!);
                },
                itemCount: 1,
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
