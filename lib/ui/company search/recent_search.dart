import 'package:flutter/material.dart';
import 'package:investtech_app/network/database/database_helper.dart';
import 'package:investtech_app/network/models/recent_search.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:investtech_app/ui/company%20page/company_page.dart';

class RecentSearchList extends StatelessWidget {
  const RecentSearchList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<RecentSearch>>(
      future: DatabaseHelper().getRecentSearches(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return ListView(
            primary: true,
            shrinkWrap: true,
            children: [
              Padding(
                padding: const EdgeInsets.all(10),
                child: Text(AppLocalizations.of(context)!.recent_searches),
              ),
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: snapshot.data!.length,
                separatorBuilder: (BuildContext context, int index) =>
                    const Divider(
                  height: 0,
                ),
                itemBuilder: (context, index) {
                  return ListTile(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CompanyPage(
                              snapshot.data![index].companyId,
                              4,
                            ),
                          ));
                    },
                    dense: true,
                    horizontalTitleGap: 1.0,
                    leading: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.update,
                            color: DefaultTextStyle.of(context).style.color),
                      ],
                    ),
                    title: Text(snapshot.data![index].ticker),
                    subtitle: Text(snapshot.data![index].companyName),
                  );
                },
              ),
            ],
          );
        } else if (snapshot.hasError) {
          return Text('${snapshot.error}');
        } else {
          return Text(AppLocalizations.of(context)!.recent_searches);
        }
      },
    );
  }
}
