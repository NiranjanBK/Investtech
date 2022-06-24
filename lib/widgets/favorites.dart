import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:investtech_app/network/models/company.dart';

import 'package:investtech_app/ui/company_page.dart';
import 'package:investtech_app/ui/favourites_detail_page.dart';
import 'package:investtech_app/widgets/favourites_list.dart';

import 'package:investtech_app/widgets/product_Item_Header.dart';

class FavoritesTeaser extends StatefulWidget {
  final dynamic favObj;
  const FavoritesTeaser(this.favObj, {Key? key}) : super(key: key);

  @override
  State<FavoritesTeaser> createState() => _FavoritesTeaserState();
}

class _FavoritesTeaserState extends State<FavoritesTeaser> {
  @override
  Widget build(BuildContext context) {
    var _favCompanies =
        jsonDecode(jsonEncode(widget.favObj))['content']['company'] as List;
    List<Company> favCmpObj =
        _favCompanies.map((favJson) => Company.fromJson(favJson)).toList();

    var itemCount = favCmpObj.length > 5 ? 5 : favCmpObj.length;

    return Expanded(
      child: ListView(
        primary: true,
        shrinkWrap: true,
        children: [
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => FavoritesDetail(favCmpObj)),
              );
            },
            child: ProductHeader(AppLocalizations.of(context)!.favourites, 1),
          ),
          FavoritesList(favCmpObj, itemCount),
        ],
      ),
    );
  }
}
