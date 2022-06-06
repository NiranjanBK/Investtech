import 'package:flutter/material.dart';
import 'package:investtech_app/network/database/database_helper.dart';
import 'package:investtech_app/network/models/recent_search.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:investtech_app/ui/company_page.dart';

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
                physics: const ScrollPhysics(),
                padding: EdgeInsets.zero,
                itemCount: snapshot.data!.length,
                separatorBuilder: (BuildContext context, int index) =>
                    const Divider(),
                itemBuilder: (context, index) {
                  return SizedBox(
                    height: 35,
                    child: ListTile(
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
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 5.0, horizontal: 10.0),
                      horizontalTitleGap: 1.0,
                      leading: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.update),
                        ],
                      ),
                      title: Text(snapshot.data![index].ticker),
                      subtitle: Text(snapshot.data![index].companyName),
                    ),
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
