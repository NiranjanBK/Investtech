import 'package:flutter/material.dart';
import 'package:investtech_app/const/text_style.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ProductHeader extends StatelessWidget {
  final String? title;
  final int seeAll;

  ProductHeader(this.title, this.seeAll);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 15, bottom: 10, left: 16, right: 16),
      decoration: BoxDecoration(
          //color: Theme.of(context).primaryColorDark, border: const Border(bottom: BorderSide(color: Colors.black12))
          ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title ?? '',
            style: getHomePageHeadingTextStyle(),
          ),
          Text(
            seeAll == 1 ? AppLocalizations.of(context)!.see_all : '',
            style: getHomePageSeeAllTextStyle(),
          ),
        ],
      ),
    );
  }
}
